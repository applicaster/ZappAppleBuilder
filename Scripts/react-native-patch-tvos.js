#!/usr/bin/env node

const { readdir, readFile, writeFile } = require("fs");
const { promisify, inspect } = require("util");
const { resolve } = require("path");

const readdirAsync = promisify(readdir);
const readFileAsync = promisify(readFile);
const writeFileAsync = promisify(writeFile);

const BREAK_LINE = "\n";

function react_native_install_folder(target) {
  const repo_root = resolve(__dirname, "../" + target);
  return resolve(repo_root, "./node_modules/react-native-tvos");
}

function replaceStringInFile(file, { lookUpString, correctString }) {
  return file
    .toString()
    .split(BREAK_LINE)
    .map((line) =>
      line.includes(lookUpString)
        ? line.replace(lookUpString, correctString)
        : line
    )
    .join(BREAK_LINE);
}

function prepareReactPodspec(file) {
  const args = {
    lookUpString: `ss.source_files         = "React/**/RCTTV*.{h,m}"`,
    correctString: `ss.source_files         = "React/**/RCTTV*.{h,m}"\n      ss.dependency             "DoubleConversion" \n      ss.dependency             "glog"\n      ss.compiler_flags       = folly_compiler_flags`,
  };
  const updatedFile = replaceStringInFile(file, args);
  const fileLines = updatedFile.toString().split(BREAK_LINE);
  const ssIndex = fileLines.findIndex((l) =>
    l.includes("ss.tvos.exclude_files")
  );
  fileLines.splice(
    ssIndex + 1,
    0,
    '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"React/Views/RCTWKWebView*",'
  );

  return fileLines.join(BREAK_LINE);
}

async function processFile(
  react_native_install_folder,
  { filePath, operation, args }
) {
  const fullFilePath = resolve(react_native_install_folder, filePath);
  console.log(`processing ${fullFilePath}`);
  console.log(`performing ${operation.name} with ${inspect(args)} \n`);

  try {
    const file = await readFileAsync(fullFilePath);
    const fileContent = file.toString();
    const updatedFile = operation(file, args);

    await writeFileAsync(fullFilePath, Buffer.from(updatedFile));
    console.log("done !\n");
    return;
  } catch (e) {
    console.error(`couldn't process ${filePath} - ${e.message}`);
    process.exit(1);
  }
}

const FILES_TO_PATCH = [
  {
    filePath: "./React/CoreModules/RCTDevMenu.h",
    operation: replaceStringInFile,
    args: {
      lookUpString: "RCT_EXTERN NSString *const RCTShowDevMenuNotification;",
      correctString:
        "static NSString *const RCTShowDevMenuNotification = @\"RCTShowDevMenuNotification\";",
    },
  },
  {
    filePath: "./React/CoreModules/RCTDevMenu.mm",
    operation: replaceStringInFile,
    args: {
      lookUpString: "NSString *const RCTShowDevMenuNotification = @\"RCTShowDevMenuNotification\";",
      correctString:
        "",
    },
  },
  {
    filePath: "./React/CoreModules/RCTTVNavigationEventEmitter.h",
    operation: replaceStringInFile,
    args: {
      lookUpString: "RCT_EXTERN NSString *const RCTTVNavigationEventNotification;",
      correctString:
        "static NSString *const RCTTVNavigationEventNotification = @\"RCTTVNavigationEventNotification\";",
    },
  },
  {
    filePath: "./React/CoreModules/RCTTVNavigationEventEmitter.mm",
    operation: replaceStringInFile,
    args: {
      lookUpString: "NSString *const RCTTVNavigationEventNotification = @\"RCTTVNavigationEventNotification\";",
      correctString:
        "",
    },
  },

];

async function run() {
  var platform_install_folder = process.argv.slice(2);

  console.log("-| Patching react native |-");
  console.log("-| for: " + platform_install_folder + " |-");

  FILES_TO_PATCH.forEach(
    async (fileToPatch) =>
      await processFile(
        react_native_install_folder(platform_install_folder),
        fileToPatch
      )
  );
}

run();

#!/usr/bin/env node

const { readdir, readFile, writeFile } = require("fs");
const { promisify, inspect } = require("util");
const { resolve } = require("path");

const readdirAsync = promisify(readdir);
const readFileAsync = promisify(readFile);
const writeFileAsync = promisify(writeFile);

const BREAK_LINE = "\n";

function react_native_install_folder(target, react_native_folder) {
  const repo_root = resolve(__dirname, "../" + target);
  return resolve(repo_root, "./node_modules/"+react_native_folder);
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

const IOS_FILES_TO_PATCH = [
  {
    filePath: "./React/Base/RCTConvert.h",
    operation: replaceStringInFile,
    args: {
      lookUpString: "#import <WebKit/WebKit.h>",
      correctString: "",
    },
  },
  {
    filePath: "./React/Views/RCTTVView.m",
    operation: replaceStringInFile,
    args: {
      lookUpString:
        "    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{",
      correctString: "    dispatch_async(dispatch_get_main_queue(), ^{",
    },
  },
  {
    filePath: "./React/Base/RCTBridgeModule.h",
    operation: replaceStringInFile,
    args: {
      lookUpString: "  RCT_EXPORT_MODULE(js_name)",
      correctString: `  RCT_EXPORT_MODULE_NO_LOAD(js_name, objc_name)\n\n#define RCT_EXPORT_MODULE_NO_LOAD(js_name, objc_name) \\\nRCT_EXTERN void RCTRegisterModule(Class); \\\n+ (NSString *)moduleName { return @#js_name; } \\\n__attribute__((constructor)) static void \RCT_CONCAT(initialize_, objc_name)() { RCTRegisterModule([objc_name class]); }\n\n`,
    },
  },
  {
    filePath: "./Libraries/Image/RCTImageCache.m",
    operation: replaceStringInFile,
    args: {
      lookUpString:
        "  CGFloat bytes = image.size.width * image.size.height * image.scale * image.scale * 4;",
      correctString:
        "  NSData *imgData = UIImageJPEGRepresentation(image, 1.0);\n  CGFloat bytes = [imgData length];",
    },
  },
  {
    filePath: "./Libraries/Text/TextInput/RCTBaseTextInputView.m",
    operation: replaceStringInFile,
    args: {
      lookUpString: "  if (shouldFallbackToBareTextComparison) {",
      correctString:
        "  #if TARGET_OS_TV\n    shouldFallbackToBareTextComparison = YES;\n  #endif\n  if (shouldFallbackToBareTextComparison) {",
    },
  },
];

const TVOS_FILES_TO_PATCH = [
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
]
async function run() {
  var platform_install_folder = process.argv.slice(2);

  console.log("-| Patching react native |-");
  console.log("-| for: " + platform_install_folder + " |-");

  switch(String(platform_install_folder)) {
    case "ZappiOS":
      var react_native_folder = "react-native"
      IOS_FILES_TO_PATCH.forEach(
        async (fileToPatch) =>
          await processFile(
            react_native_install_folder(platform_install_folder, react_native_folder),
            fileToPatch
          )
      );
      break;
    case "ZappTvOS":
      var react_native_folder = "react-native-tvos"
      TVOS_FILES_TO_PATCH.forEach(
        async (fileToPatch) =>
          await processFile(
            react_native_install_folder(platform_install_folder, react_native_folder),
            fileToPatch
          )
      );
      break;
    default:
      break;
  }
}

run();

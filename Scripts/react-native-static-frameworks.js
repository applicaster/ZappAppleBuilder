#!/usr/bin/env node

const { readdir, readFile, writeFile, stat } = require('fs');
const { promisify } = require('util');
const { resolve } = require('path');

const readdirAsync = promisify(readdir);
const readFileAsync = promisify(readFile);
const writeFileAsync = promisify(writeFile);
const statAsync = promisify(stat);

const REACT_NATIVE_INSTALL_FOLDER = resolve(__dirname, "../node_modules/react-native");
const BREAK_LINE = "\n";
const POD_SPEC_EXTENSION = ".podspec";
const POD_SPEC_DECLARATION = "Pod::Spec.new do";
const POD_SPEC_VAR_SEPARATOR = "|";


const EXCLUDED_PODSPECS = ["React.podspec"];
const NESTED_FOLDERS = ["ReactCommon", "yoga", "third-party-podspecs"];

function addStaticFrameworkToPodSpec(podspec) {
  const lines = podspec.toString().split(BREAK_LINE);
  const podSpecDeclarationIndex = lines.findIndex(line => line.includes(POD_SPEC_DECLARATION));
  const podSpecVarName = lines[podSpecDeclarationIndex].split(POD_SPEC_VAR_SEPARATOR)[1];
  lines.splice(podSpecDeclarationIndex + 1, 0, `  ${podSpecVarName}.static_framework = true`);
  return lines.join(BREAK_LINE);
}

async function processFile(file, path) {
  if (EXCLUDED_PODSPECS.includes(file)) {
    console.log(`skipping ${file}`);
    return;
  }

  const filePath = resolve(path, file)

  if (NESTED_FOLDERS.includes(file)) {
    console.log(`Looking in nested folder ${file}`);
    const nestedFiles = await readdirAsync(filePath);
    nestedFiles.forEach(async file => await processFile(file, filePath));
    return;
  }

  if (file.includes(POD_SPEC_EXTENSION)) {
    console.log(`processing podspec ${file}`);
    try {
      const fileContent = await readFileAsync(filePath);
      const podspec = fileContent.toString();
      const updatedPodspec = addStaticFrameworkToPodSpec(podspec);
      await writeFileAsync(filePath, Buffer.from(updatedPodspec));
    } catch (e) {
      console.error(`couldn't process ${file} - ${e.message}`);
      process.exit(1);
    }
  }
}

async function run() {
  console.log("-|| making react frameworks static ||-");
  const files = await readdirAsync(REACT_NATIVE_INSTALL_FOLDER);
  files.forEach(async file => await processFile(file, REACT_NATIVE_INSTALL_FOLDER));
}

run();

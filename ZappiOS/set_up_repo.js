const { resolve } = require("path");
const { writeFileSync } = require("fs");
const semver = require("semver");

const WEBVIEW_RESOLUTION_MINIMUM_VERSION = "5.0.1-rc.22";

function shouldSetResolutions(version) {
  if (version === "next" || version.includes("alpha")) return true;

  return semver.gte(version, WEBVIEW_RESOLUTION_MINIMUM_VERSION);
}

function setUpNodeResolutions() {
  const quickBrickVersion = process.argv.slice(2)[0];

  const pJsonPath = resolve(__dirname, "./package.json");
  const packageJson = require(pJsonPath);

  const defaultVersion =
    packageJson.devDependencies["@applicaster/zapplicaster-cli"];

  if (shouldSetResolutions(quickBrickVersion || defaultVersion)) {
    packageJson.resolutions["react-native-webview"] = "11.3.1";
    packageJson.dependencies["react-native-webview"] = "11.3.1";
  } else {
    delete packageJson.resolutions["react-native-webview"];
    packageJson.dependencies["react-native-webview"] = "9.1.1";
  }

  writeFileSync(pJsonPath, Buffer.from(JSON.stringify(packageJson, null, 2)));
}

function run() {
  setUpNodeResolutions();
}

run();

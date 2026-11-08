const assert = require("assert");
const fs = require("fs");
const read = (f) => fs.readFileSync(f, "utf8");
// devcontainer: tag = "calculator-dev"
assert.strictEqual(JSON.parse(read(".devcontainer/devcontainer.json")).name, "calculator-dev");
assert.strictEqual(JSON.parse(read(".devcontainer/devcontainer.json")).build.target, "dev");
// ci: tag = "calculator-ci"
const build = read(".github/workflows/docker-build.yml");
assert(/image-name: ghcr\.io\/thedeepestspace\/calculator-ci\n\s+target: ci/.test(build));
assert(/image-name: ghcr\.io\/thedeepestspace\/calculator-dev\n\s+target: dev/.test(build));
assert(/calculator-ci/.test(read(".github/workflows/ci.yml")));
const df = read("Dockerfile");
assert(/AS ci\b/.test(df) && /AS dev\b/.test(df));
console.log("ok");

const assert = require("assert");
const fs = require("fs");
const { execSync } = require("child_process");
execSync("make site", { cwd: __dirname, stdio: "pipe" });
for (const f of ["index.html", "evaluate.js", "rtl/alu.v"])
  assert.ok(fs.existsSync(`${__dirname}/site/${f}`), f);
assert.ok(!fs.readFileSync(`${__dirname}/site/index.html`, "utf8").includes("<p>calculator</p>"), "placeholder");
console.log("ok");

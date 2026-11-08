const assert = require("assert");
const fs = require("fs");
const readme = fs.readFileSync(__dirname + "/README.md", "utf8");
// short synopsis
const lines = readme.split("\n").filter((l) => l.trim() && !l.startsWith("#"));
assert.ok(/calculator/i.test(lines[0]) && lines[0].length < 300, "synopsis");
// link to GitHub Pages deployment
assert.ok(readme.includes("https://thedeepestspace.github.io/calculator/"), "pages link");
console.log("ok");

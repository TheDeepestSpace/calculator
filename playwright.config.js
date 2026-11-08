const { defineConfig } = require("@playwright/test");
module.exports = defineConfig({
  testDir: "tests",
  // Goldens are committed in tests/golden (platform-independent path).
  snapshotPathTemplate: "{testDir}/golden/{arg}{ext}",
  expect: { toHaveScreenshot: { maxDiffPixels: 50 } },
  use: { viewport: { width: 400, height: 500 } },
});

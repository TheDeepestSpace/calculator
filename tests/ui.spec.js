const { test, expect } = require("@playwright/test");
const url = "file://" + require("path").resolve(__dirname, "../index.html");

test("initial state", async ({ page }) => {
  await page.goto(url);
  await expect(page).toHaveScreenshot("initial.png");
});

test("expression with result", async ({ page }) => {
  await page.goto(url);
  for (const k of ["1", "+", "2", "*", "3"]) {
    await page.getByRole("button", { name: k, exact: true }).click();
  }
  await expect(page.locator("#answer")).toHaveText("=7");
  await page.mouse.move(0, 0);
  await expect(page).toHaveScreenshot("expression.png");
});

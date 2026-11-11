import { expect, test } from "@playwright/test";

test("home page answers with the Jobwright heading", async ({ page }) => {
  const consoleErrors: string[] = [];
  page.on("console", (message) => {
    if (message.type() === "error") consoleErrors.push(message.text());
  });

  const response = await page.goto("/");

  expect(response?.status()).toBe(200);
  await expect(
    page.getByRole("heading", { level: 1, name: "Jobwright" }),
  ).toBeVisible();
  expect(consoleErrors).toEqual([]);
});

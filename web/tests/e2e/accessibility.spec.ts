import AxeBuilder from "@axe-core/playwright";
import { expect, test } from "@playwright/test";

// Every page the app serves today; each later page joins this list.
const pages = [
  { path: "/", status: 200 },
  { path: "/no-such-page", status: 404 },
];

// WCAG 2.2 AA and the levels below it (AC12).
const wcagTags = ["wcag2a", "wcag2aa", "wcag21a", "wcag21aa", "wcag22aa"];

test("AC12 every page has no WCAG 2.2 AA violation", async ({ page }) => {
  for (const { path, status } of pages) {
    await test.step(path, async () => {
      const response = await page.goto(path);
      expect(response?.status(), path).toBe(status);

      const results = await new AxeBuilder({ page })
        .withTags(wcagTags)
        .analyze();

      const violations = results.violations.map((violation) => ({
        rule: violation.id,
        impact: violation.impact,
        targets: violation.nodes.map((node) => node.target.join(" ")),
      }));
      expect(violations, path).toEqual([]);
    });
  }
});

import { configDefaults, defineConfig } from "vitest/config";

// Unit tests only: browser tests under tests/e2e run with Playwright.
export default defineConfig({
  test: {
    exclude: [...configDefaults.exclude, "tests/e2e/**"],
  },
});

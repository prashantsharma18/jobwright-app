import { defineConfig, devices } from "@playwright/test";

// Browser tests run against the production build (`pnpm build` first), started on 127.0.0.1:15300 (plan K4) by the
// standalone server.js that Dockerfile.web ships; `next start` does not support output: "standalone".
const baseURL = "http://127.0.0.1:15300";

const widths = [360, 1440] as const;
const schemes = ["light", "dark"] as const;

export default defineConfig({
  testDir: "./tests/e2e",
  forbidOnly: !!process.env.CI,
  retries: 0,
  reporter: [["list"], ["html", { open: "never" }]],
  use: {
    baseURL,
    trace: "retain-on-failure",
  },
  webServer: {
    // server.js serves .next/static only from inside the standalone folder (nextjs.org, output: standalone)
    command:
      "cp -R .next/static .next/standalone/.next/ && node .next/standalone/server.js",
    env: { PORT: "15300", HOSTNAME: "127.0.0.1" },
    url: baseURL,
    reuseExistingServer: false,
  },
  projects: [
    // The page check and the AC12 scan: 360 and 1440 px, light and dark, in Chromium.
    ...widths.flatMap((width) =>
      schemes.map((colorScheme) => ({
        name: `${width}-${colorScheme}`,
        testIgnore: /budget\.spec\.ts/,
        use: {
          ...devices["Desktop Chrome"],
          viewport: { width, height: 900 },
          colorScheme,
        },
      })),
    ),
    // AC26: one measurement in Chromium at desktop width (plan C6).
    {
      name: "budget",
      testMatch: /budget\.spec\.ts/,
      use: {
        ...devices["Desktop Chrome"],
        viewport: { width: 1440, height: 900 },
      },
    },
  ],
});

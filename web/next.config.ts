import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Dockerfile.web ships .next/standalone (server.js) and .next/static only
  output: "standalone",
  // next dev writes web/AGENTS.md when an AI agent runs it; the scaffold chose no AGENTS.md (--no-agents-md)
  agentRules: false,
  turbopack: {
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
};

export default nextConfig;

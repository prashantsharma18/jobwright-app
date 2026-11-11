import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Dockerfile.web ships .next/standalone (server.js) and .next/static only
  output:    "standalone" ,
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

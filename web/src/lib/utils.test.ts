import { describe, expect, it } from "vitest";

import { cn } from "./utils";

describe("cn", () => {
  it("cn keeps the last of two conflicting Tailwind classes", () => {
    expect(cn("px-2 py-1", "px-4")).toBe("py-1 px-4");
  });

  it("cn drops falsy values", () => {
    expect(cn("flex", false, null, undefined, "", "items-center")).toBe("flex items-center");
  });
});

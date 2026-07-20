import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const apps = ["requests_min", "elastic_min", "git_min", "kafka_ui_min", "redis_min", "log_min"];

for (const app of apps) {
  test(`${app} command palette supports shared keyboard navigation`, async () => {
    const palette = await readFile(
      new URL(`../../${app}/src/components/CommandPalette.tsx`, import.meta.url),
      "utf8",
    );

    assert.match(palette, /vim(?:Mode|Keys)/);
    assert.match(palette, /e\.key === "Tab"/);
    assert.match(palette, /e\.ctrlKey && e\.key\.toLowerCase\(\) === "n"/);
    assert.match(palette, /e\.ctrlKey && e\.key\.toLowerCase\(\) === "p"/);
    assert.match(palette, /Math\.max\(0, filtered\.length - 1\)/);
  });
}

import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const apps = ["requests_min", "elastic_min", "kafka_ui_min", "redis_min", "log_min"];

for (const app of apps) {
  test(`${app} renders Workspace as the first left-dock group`, async () => {
    const sidebar = await readFile(
      new URL(`../../${app}/src/components/Sidebar.tsx`, import.meta.url),
      "utf8",
    );
    const leftDock = sidebar.slice(sidebar.indexOf('<div className="side-scroll">'));
    const groupLabels = [...leftDock.matchAll(
      /className="[^"]*group-title[^"]*"[^>]*>\s*<span>([^<]+)<\/span>/g,
    )].map((match) => match[1]);

    assert.equal(groupLabels[0], "Workspace", `left-dock order: ${groupLabels.join(" > ")}`);
  });
}

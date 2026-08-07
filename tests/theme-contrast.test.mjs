import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

/**
 * The three-step text ramp and the accent/status colors are shipped values, not
 * suggestions: `--text-3` carries form labels, placeholders, table date cells and 10px
 * `kbd` pills — content, so the AA 4.5:1 body threshold applies, not the 3:1 "decorative"
 * escape hatch the doc used to claim. 24 of 27 palettes failed it before the retune.
 * Accents fill dots, badges and rails, so they take the 3:1 non-text minimum.
 */
const relativeLuminance = (hex) => {
  const raw = hex.replace("#", "");
  const full = raw.length === 3 ? raw.split("").map((c) => c + c).join("") : raw;
  const [r, g, b] = [0, 2, 4]
    .map((i) => parseInt(full.slice(i, i + 2), 16) / 255)
    .map((v) => (v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4));
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};

const contrast = (a, b) => {
  const [hi, lo] = [relativeLuminance(a), relativeLuminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
};

const MINIMUM = {
  text: 4.5, "text-2": 4.5, "text-3": 4.5,
  blue: 3, "blue-2": 3, green: 3, orange: 3, red: 3, purple: 3,
};

const readVar = (block, name) =>
  (block.match(new RegExp(`--${name}:\\s*(#[0-9a-fA-F]{3,8})`)) || [])[1];

test("every themes.css palette clears WCAG on its own --pane", async () => {
  const css = await readFile(new URL("../themes.css", import.meta.url), "utf8");
  const blocks = css.split(/^body\[data-theme="/m).slice(1);
  assert.ok(blocks.length >= 20, `expected the full palette set, got ${blocks.length}`);

  const failures = [];
  for (const block of blocks) {
    const theme = block.slice(0, block.indexOf('"'));
    const background = readVar(block, "pane") || readVar(block, "app-bg");
    if (!background) continue;
    for (const [token, minimum] of Object.entries(MINIMUM)) {
      const value = readVar(block, token);
      if (!value) continue; // palette inherits the :root value, covered by the base test
      const ratio = contrast(value, background);
      if (ratio < minimum) {
        failures.push(`${theme} --${token} ${ratio.toFixed(2)}:1 (needs ${minimum})`);
      }
    }
  }
  assert.deepEqual(failures, []);
});

test("the :root dark base and body.light ramp clear WCAG too", async () => {
  const css = await readFile(new URL("../tokens.css", import.meta.url), "utf8");
  // match the rule body, not the first mention of the selector — the file header comment
  // names `body.light` several lines before the rule exists
  const rule = (selector) => {
    const start = css.search(new RegExp(`^${selector}\\s*\\{`, "m"));
    assert.notEqual(start, -1, `${selector} rule not found in tokens.css`);
    return css.slice(start, css.indexOf("\n}", start));
  };
  const blocks = { ":root, body": rule(":root, body"), "body.light": rule("body\\.light") };

  const failures = [];
  for (const [name, block] of Object.entries(blocks)) {
    const background = readVar(block, "pane") || readVar(block, "app-bg");
    assert.ok(background, `${name} defines no --pane/--app-bg`);
    for (const [token, minimum] of Object.entries(MINIMUM)) {
      const value = readVar(block, token);
      if (!value) continue;
      const ratio = contrast(value, background);
      if (ratio < minimum) {
        failures.push(`${name} --${token} ${ratio.toFixed(2)}:1 (needs ${minimum})`);
      }
    }
  }
  assert.deepEqual(failures, []);
});

test("the three-step text ramp stays three distinct tones", async () => {
  const css = await readFile(new URL("../themes.css", import.meta.url), "utf8");
  const failures = [];
  for (const block of css.split(/^body\[data-theme="/m).slice(1)) {
    const theme = block.slice(0, block.indexOf('"'));
    const background = readVar(block, "pane") || readVar(block, "app-bg");
    const tiers = ["text", "text-2", "text-3"].map((t) => readVar(block, t));
    if (!background || tiers.some((t) => !t)) continue;
    const ratios = tiers.map((t) => contrast(t, background));
    // each step must be at least 1.15x the next, else the ramp has collapsed to two tones
    for (let i = 0; i < ratios.length - 1; i++) {
      if (ratios[i] < ratios[i + 1] * 1.15) {
        failures.push(
          `${theme}: --text${i ? `-${i + 1}` : ""} ${ratios[i].toFixed(2)} vs ` +
          `--text-${i + 2} ${ratios[i + 1].toFixed(2)}`,
        );
      }
    }
  }
  assert.deepEqual(failures, []);
});

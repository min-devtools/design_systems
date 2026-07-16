# Design System Standardization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `design-systems/` the single canonical source of shared CSS, symlinked into all four `_min` apps, with one unified loading system.

**Architecture:** Reconcile the bidirectionally-drifted shared CSS files into `design-systems/` first (tokens/base take app versions, layout takes source + app additions, components merges both), add a unified `.loading-bar` + `<LoadingBar>` primitive, then replace each app's five vendored CSS files with relative symlinks. `views.css` (+ app-only override files) stay app-local.

**Tech Stack:** Plain CSS custom properties, React 18 + TypeScript, Vite 5, Tauri 2. No new dependencies.

**Spec:** `docs/superpowers/specs/2026-07-16-design-system-standardization-design.md`

## Global Constraints

- **NO git commits by agents — ever.** The human commits. Each task ends with a CHECKPOINT step that lists exactly which files are ready; then stop and report.
- Canonical shared files live ONLY in `/Users/qc-bright/Project/design-systems/`: `tokens.css`, `themes.css`, `base.css`, `layout.css`, `components.css`.
- App-local CSS files (`views.css`, `requestsmin.css`) are never symlinked.
- No new hardcoded hex outside `tokens.css`/`themes.css`. Tints only via `color-mix(in oklab, <token>, transparent N%)`.
- Symlinks are relative: `../../../design-systems/<file>.css` from each app's `src/styles/`.
- Fonts: Inter (UI) + Google Sans Code (mono). `--font-body-default` must say `"Inter"`, never `"Exo 2"`.
- Apps have no JS test runner — verification is `npm run build` (tsc + vite), grep assertions, and rendering `design-systems/index.html`.
- Absolute app paths: `/Users/qc-bright/Project/{requests_min,elatic_min,kafka_ui_min,redis_min}`.

---

### Task 1: Reconcile canonical `tokens.css` + `base.css`

**Files:**
- Modify: `/Users/qc-bright/Project/design-systems/tokens.css` (line 4)
- Overwrite: `/Users/qc-bright/Project/design-systems/base.css` (19 → 37 lines)

**Interfaces:**
- Produces: canonical `tokens.css` byte-identical to all four apps' copies; canonical `base.css` byte-identical to kafka/redis copies (the newest, with native-control theming). Task 5–8 symlink against these.

- [ ] **Step 1: Fix the stale font token in `tokens.css`**

In `/Users/qc-bright/Project/design-systems/tokens.css` line 4, change:

```css
  --font-body-default: "Exo 2", system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
```

to:

```css
  --font-body-default: "Inter", system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
```

- [ ] **Step 2: Verify tokens.css now matches every app byte-for-byte**

Run:
```bash
for app in elatic_min requests_min kafka_ui_min redis_min; do
  cmp /Users/qc-bright/Project/design-systems/tokens.css /Users/qc-bright/Project/$app/src/styles/tokens.css && echo "$app OK"
done
```
Expected: four lines of `<app> OK`, no `differ` output. If any differs, STOP and diff — the plan's survey says this is the only delta.

- [ ] **Step 3: Adopt the newest `base.css` (kafka/redis 37-line version) as canonical**

Run:
```bash
cmp /Users/qc-bright/Project/kafka_ui_min/src/styles/base.css /Users/qc-bright/Project/redis_min/src/styles/base.css \
  && cp /Users/qc-bright/Project/kafka_ui_min/src/styles/base.css /Users/qc-bright/Project/design-systems/base.css
```
Expected: silent success (the two sources are identical, then copy). The new canonical `base.css` adds over the old 19-line version: `color-scheme: dark` on body + `body.light { color-scheme: light; }`, and themed `input[type="datetime-local"]` (mono font, themed picker indicator, `--text-2` field text brightening to `--text` on focus).

- [ ] **Step 4: Verify canonical base.css**

Run:
```bash
wc -l /Users/qc-bright/Project/design-systems/base.css
grep -c "color-scheme" /Users/qc-bright/Project/design-systems/base.css
```
Expected: `37` lines, `2` color-scheme occurrences.

- [ ] **Step 5: CHECKPOINT — report for human commit**

Ready in `design-systems/`: `tokens.css` (1-line font fix), `base.css` (adopted 37-line version). Suggested message: `fix(tokens): Inter not Exo 2; adopt native-control theming in base.css`. Do not commit; report and continue.

---

### Task 2: Reconcile canonical `layout.css`

**Files:**
- Modify: `/Users/qc-bright/Project/design-systems/layout.css` (427 lines, newest base)

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: canonical `layout.css` = source + universal app additions (`.tab > span:not(.tab-close)`, `.statusbar span`, `.inspector-text`, requests' collection-tree fixes). Tasks 5–8 symlink against it.

- [ ] **Step 1: Add tab-title overflow guard (present in elatic/kafka/redis, missing in source)**

Copy the block verbatim from `/Users/qc-bright/Project/redis_min/src/styles/layout.css` (starts line 218, `.tab > span:not(.tab-close) {`, through its closing `}`) into canonical `layout.css`, placed immediately after the existing `.tab` rules. Its body is flex/overflow only (`flex: 1 1 auto; min-width: 0; white-space: nowrap; overflow: hidden; …`) — read the app file for the exact full block rather than retyping.

- [ ] **Step 2: Add statusbar overflow guard (present in elatic/kafka/redis)**

Copy the block verbatim from `/Users/qc-bright/Project/redis_min/src/styles/layout.css` (starts line 383, `.statusbar span {`, through its closing `}`) into canonical `layout.css`, immediately after the existing `.statusbar` rules.

- [ ] **Step 3: Add `.inspector-text` (redis; generic inspector prose card, shared-worthy)**

Copy the block verbatim from `/Users/qc-bright/Project/redis_min/src/styles/layout.css` (starts line 337, `.inspector-text {`, through its closing `}`) into canonical `layout.css`, next to the other `.inspector` rules.

- [ ] **Step 4: Apply requests_min's collection-tree refinements (requests is the layout origin + newest)**

In canonical `layout.css` around line 173–181, apply the exact diff that `requests_min/src/styles/layout.css` carries:

Add after the `.collection-node`/`.request-node` base rules:
```css
.collection-node.drop-prefix, .request-node.drop-prefix { position: relative; }
.drop-prefix::before { content: "|"; position: absolute; left: 3px; top: 50%; z-index: 2; color: var(--accent, #6ea8fe); font: 700 22px/1 var(--font-mono); transform: translateY(-52%); }
```

Replace:
```css
.request-node { width: 100%; grid-template-columns: 42px minmax(0, 1fr) auto; border: 0; background: transparent; font: inherit; text-align: left; }
.request-node > span:nth-child(2) { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
```
with:
```css
.nav-item.request-node { width: 100%; grid-template-columns: 38px minmax(0, 1fr) auto; border: 0; background: transparent; font: inherit; text-align: left; }
.collection-node > span:nth-child(2), .request-node > span:nth-child(2) { min-width: 0; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
```

Note: the `#6ea8fe` inside `var(--accent, #6ea8fe)` is a var() fallback, not a new palette color — allowed.

- [ ] **Step 5: Verify layout.css converged**

Run:
```bash
DS=/Users/qc-bright/Project/design-systems
diff $DS/layout.css /Users/qc-bright/Project/requests_min/src/styles/layout.css | head -20
for app in elatic_min kafka_ui_min redis_min; do
  echo "--- $app still-missing-from-canonical:"
  diff $DS/layout.css /Users/qc-bright/Project/$app/src/styles/layout.css | sed -n 's/^> \(.*{\) *$/\1/p'
done
```
Expected: requests diff empty (or whitespace-only); the per-app "added selector" lists empty. Property-level `<`/`>` noise on shared selectors is acceptable ONLY if it's the canonical (newest) value — spot-check any that appear.

- [ ] **Step 6: CHECKPOINT — report for human commit**

Ready: `design-systems/layout.css` (fold in universal app additions). Suggested message: `feat(layout): fold app-drifted universal rules back into canonical`. Do not commit; report and continue.

---

### Task 3: Reconcile canonical `components.css` + unified loading CSS

**Files:**
- Modify: `/Users/qc-bright/Project/design-systems/components.css` (1081 lines)

**Interfaces:**
- Consumes: nothing.
- Produces: canonical `components.css` containing `.ai-session-bar`, `.ai-session-select`, `.form-row select:focus`, and the unified `.loading-bar` block (classes `.loading-bar`, `.loading-bar.on`, `.loading-bar.determinate`, CSS var `--progress`). Task 4's `<LoadingBar>` renders exactly these classes. Tasks 5–8 symlink against it.

- [ ] **Step 1: Promote `.ai-session-bar` / `.ai-session-select` (present in 3 of 4 apps)**

Add to canonical `components.css`, in the AI-chat section (immediately after the `.ai-chat` block):

```css
.ai-session-bar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto auto;
  gap: 6px;
  align-items: center;
  padding: 8px 10px;
  border-bottom: 1px solid var(--line);
  background: var(--pane-2);
}

.ai-session-select {
  min-width: 0;
  height: 30px;
  padding: 0 8px;
  color: var(--text);
  background: var(--pane);
  border: 1px solid var(--line-2);
  border-radius: 7px;
  outline: none;
  font: 0.8462rem/1 var(--font-body);
}

.ai-session-select:focus { border-color: var(--blue); }
```

- [ ] **Step 2: Promote redis's `select:focus` refinement (generic form improvement)**

In canonical `components.css`, find the `.form-row input:focus` rule and extend its selector list to match redis:

```css
.form-row input:focus, .form-row select:focus {
  border-color: color-mix(in oklab, var(--blue), transparent 35%);
  box-shadow: 0 0 0 3px color-mix(in oklab, var(--blue), transparent 86%);
}
```

(Keep the existing declarations if they already match — only the selector gains `, .form-row select:focus`.)

- [ ] **Step 3: Add the unified `.loading-bar` block (kafka seed + determinate mode)**

Add to canonical `components.css`, immediately after the existing `.req-progress` block:

```css
/* Unified loading bar — indeterminate by default, determinate with .determinate + --progress.
   Parent must be positioned. Replaces per-app .loading-bar / .full-progress-track. */
.loading-bar { position: absolute; inset: 0 0 auto; height: 2px; overflow: hidden; pointer-events: none; opacity: 0; transition: opacity 160ms ease; z-index: 6; }
.loading-bar.on { opacity: 1; }
.loading-bar.bottom { inset: auto 0 0; }
.loading-bar span { position: absolute; top: 0; height: 100%; width: 35%; border-radius: 2px; background: linear-gradient(90deg, transparent, var(--blue), transparent); animation: loading-bar-slide 1.05s ease-in-out infinite; }
@keyframes loading-bar-slide { 0% { left: -35%; } 100% { left: 100%; } }
.loading-bar.determinate { background: var(--pane-3); }
.loading-bar.determinate span { left: 0; width: calc(var(--progress, 0) * 100%); border-radius: 0; background: var(--blue); animation: none; transition: width 160ms ease; }
@media (prefers-reduced-motion: reduce) { .loading-bar span { animation-duration: 2.2s; } }
```

`.req-progress` stays as-is (already canonical, still referenced by app TSX until Tasks 5–8 swap it). `// ponytail: .req-progress kept as legacy alias, delete after Section D re-skins`.

- [ ] **Step 4: Verify canonical components.css is now a superset for every app**

Run:
```bash
DS=/Users/qc-bright/Project/design-systems
for app in elatic_min requests_min kafka_ui_min redis_min; do
  echo "--- $app selectors still missing from canonical:"
  diff $DS/components.css /Users/qc-bright/Project/$app/src/styles/components.css | sed -n 's/^> \(.*{\) *$/\1/p' | sort -u
done
grep -c "loading-bar" $DS/components.css
```
Expected: elatic/kafka/redis lists empty (kafka's old `.loading-bar` lines count as covered — ignore exact-line diffs, the selector must exist in canonical); requests list shows ONLY `.inspector-environment`, `.kv.metric-status code`, `.progress`, `.progress span` (handled in Task 5 by moving them app-local). `loading-bar` count ≥ 7.

- [ ] **Step 5: Verify no new raw hex outside allowed files**

Run:
```bash
grep -nE '#[0-9a-fA-F]{3,8}' /Users/qc-bright/Project/design-systems/components.css /Users/qc-bright/Project/design-systems/layout.css | grep -v 'var(--accent, #6ea8fe)'
```
Expected: no output.

- [ ] **Step 6: Render the showcase**

Open `/Users/qc-bright/Project/design-systems/index.html` in a browser (`open index.html`). Toggle light/dark and 2–3 `data-theme` palettes. Expected: no visual regressions — tabs, sidebar, buttons, badges render as before; no unstyled elements. (Human eyeball step — report done.)

- [ ] **Step 7: CHECKPOINT — report for human commit**

Ready: `design-systems/components.css`. Suggested message: `feat(components): promote ai-session + select:focus; add unified .loading-bar`. Do not commit; report and continue.

---

### Task 4: Shared `<LoadingBar>` primitive (definition)

**Files:**
- Create: `/Users/qc-bright/Project/kafka_ui_min/src/ui/LoadingBar.tsx` — MODIFY (extend kafka's seed)
- (Tasks 5–8 copy this exact file into the other three apps' `src/ui/`.)

**Interfaces:**
- Consumes: `.loading-bar` CSS classes from Task 3.
- Produces: `export function LoadingBar(props: { active: boolean; value?: number; bottom?: boolean }): JSX.Element`. `value` present → determinate (0..1, sets `--progress`); absent → indeterminate. `bottom` → `.bottom` placement. All apps import as `import { LoadingBar } from "../ui/LoadingBar"` (path depth varies per call site).

- [ ] **Step 1: Extend kafka's LoadingBar with determinate mode**

Replace the full contents of `/Users/qc-bright/Project/kafka_ui_min/src/ui/LoadingBar.tsx` with:

```tsx
/** Unified loading line (design-system). Parent must be positioned.
 *  No `value` → indeterminate slide; `value` (0..1) → determinate width. */
export function LoadingBar({
  active,
  value,
  bottom,
}: {
  active: boolean;
  value?: number;
  bottom?: boolean;
}) {
  const determinate = typeof value === "number";
  return (
    <div
      className={`loading-bar${active ? " on" : ""}${determinate ? " determinate" : ""}${bottom ? " bottom" : ""}`}
      style={determinate ? ({ "--progress": Math.min(1, Math.max(0, value)) } as React.CSSProperties) : undefined}
      aria-hidden
    >
      <span />
    </div>
  );
}
```

- [ ] **Step 2: Verify kafka still typechecks/builds**

Run: `cd /Users/qc-bright/Project/kafka_ui_min && npm run build`
Expected: exits 0. Existing call sites pass only `active` — new props optional, no call-site change needed yet.

- [ ] **Step 3: CHECKPOINT — report for human commit (kafka_ui_min repo)**

Ready in kafka_ui_min: `src/ui/LoadingBar.tsx`. Suggested message: `feat(ui): LoadingBar determinate mode`. Do not commit; report and continue.

---

### Task 5: Migrate `requests_min` to symlinks

**Files:**
- Modify: `/Users/qc-bright/Project/requests_min/src/styles/requestsmin.css` (append 4 extracted blocks)
- Replace with symlinks: `/Users/qc-bright/Project/requests_min/src/styles/{tokens,themes,base,layout,components}.css`
- Create: `/Users/qc-bright/Project/requests_min/src/ui/LoadingBar.tsx` (copy of Task 4 file)

**Interfaces:**
- Consumes: canonical CSS from Tasks 1–3; `LoadingBar.tsx` from Task 4.
- Produces: requests_min consuming canonical via symlink; app-only blocks preserved in `requestsmin.css` (already imported last in `src/main.tsx`).

- [ ] **Step 1: Move requests-only blocks out of `components.css` into `requestsmin.css`**

From `/Users/qc-bright/Project/requests_min/src/styles/components.css`, copy these blocks verbatim (locations as of survey): `.inspector-environment { … }` (line 307), `.kv.metric-status code { … }` (line 698), `.progress { … }` + `.progress span { … }` (lines 884–899). Append them, with a header comment, to `/Users/qc-bright/Project/requests_min/src/styles/requestsmin.css`:

```css
/* ── moved from vendored components.css when it became a design-systems symlink ── */
```
…followed by the four copied blocks, unchanged. Do NOT copy `@keyframes run` (already in canonical components.css).

- [ ] **Step 2: Replace the five vendored files with symlinks**

Run:
```bash
cd /Users/qc-bright/Project/requests_min/src/styles
for f in tokens themes base layout components; do
  rm $f.css && ln -s ../../../design-systems/$f.css $f.css
done
ls -la
```
Expected: five `-> ../../../design-systems/*.css` entries; `views.css` and `requestsmin.css` remain regular files.

- [ ] **Step 3: Copy the LoadingBar primitive in**

Run:
```bash
cp /Users/qc-bright/Project/kafka_ui_min/src/ui/LoadingBar.tsx /Users/qc-bright/Project/requests_min/src/ui/LoadingBar.tsx
```

- [ ] **Step 4: Swap RequestView's ad-hoc `.req-progress` markup to `<LoadingBar>`**

In `/Users/qc-bright/Project/requests_min/src/components/views/RequestView.tsx`, find the element rendering the request-in-flight line (search `req-progress`; it renders like `<div className={"req-progress" + (inFlight ? " on" : "")}><span/></div>`). Replace that element with:

```tsx
<LoadingBar active={inFlight} />
```
(using the actual in-flight boolean already present at the call site), and add the import:

```tsx
import { LoadingBar } from "../../ui/LoadingBar";
```
Adjust the relative path to the file's actual depth. The parent element already has `position: relative` (required by both old and new class).

- [ ] **Step 5: Build**

Run: `cd /Users/qc-bright/Project/requests_min && npm run build`
Expected: exits 0. If Vite errors on symlinked CSS imports (it should not — Vite follows symlinks), STOP and report.

- [ ] **Step 6: Runtime smoke check**

Run: `cd /Users/qc-bright/Project/requests_min && npm run tauri dev` (or `npm run dev` for browser-only). Expected: shell renders (titlebar/sidebar/tabs/statusbar themed correctly); send a request → thin blue loading line animates under the request header. Kill the dev process after checking.

- [ ] **Step 7: CHECKPOINT — report for human commit (requests_min repo)**

Ready: 5 symlinks, `requestsmin.css` (+4 blocks), `src/ui/LoadingBar.tsx`, `RequestView.tsx` swap. Suggested message: `refactor(styles): consume design-systems via symlink; unified LoadingBar`. Do not commit; report and continue.

---

### Task 6: Migrate `elatic_min` to symlinks

**Files:**
- Replace with symlinks: `/Users/qc-bright/Project/elatic_min/src/styles/{tokens,themes,base,layout,components}.css`
- Create: `/Users/qc-bright/Project/elatic_min/src/ui/LoadingBar.tsx`
- Modify: `/Users/qc-bright/Project/elatic_min/src/components/views/QueryView.tsx` (line ~136, `.req-progress` swap)

**Interfaces:**
- Consumes: canonical CSS (Tasks 1–3), `LoadingBar.tsx` (Task 4).
- Produces: elatic_min on symlinks. No app-only components.css blocks to rescue (its additions `.ai-session-*` were promoted in Task 3).

- [ ] **Step 1: Pre-flight — confirm nothing app-only would be lost**

Run:
```bash
DS=/Users/qc-bright/Project/design-systems
for f in tokens themes base layout components; do
  echo "--- $f:"
  diff $DS/$f.css /Users/qc-bright/Project/elatic_min/src/styles/$f.css | sed -n 's/^> \(.*{\) *$/\1/p'
done
```
Expected: all lists empty (canonical is a selector-superset). If anything appears, STOP — move it to elatic's `views.css` first (append verbatim with a `/* moved from vendored … */` header), then proceed.

- [ ] **Step 2: Symlink swap**

Run:
```bash
cd /Users/qc-bright/Project/elatic_min/src/styles
for f in tokens themes base layout components; do rm $f.css && ln -s ../../../design-systems/$f.css $f.css; done
ls -la
```
Expected: five symlinks; `views.css` regular.

- [ ] **Step 3: Copy LoadingBar + swap QueryView**

Run: `cp /Users/qc-bright/Project/kafka_ui_min/src/ui/LoadingBar.tsx /Users/qc-bright/Project/elatic_min/src/ui/LoadingBar.tsx`

In `/Users/qc-bright/Project/elatic_min/src/components/views/QueryView.tsx` (~line 136), replace the `req-progress` element (driven by `qt.running`) with `<LoadingBar active={qt.running} />` (use the actual boolean at the site) and import `{ LoadingBar } from "../../ui/LoadingBar"` (adjust path depth).

- [ ] **Step 4: Build**

Run: `cd /Users/qc-bright/Project/elatic_min && npm run build`
Expected: exits 0.

- [ ] **Step 5: Runtime smoke check**

`npm run tauri dev` (or `npm run dev`): shell themed correctly; run a query → loading line animates. Kill dev process.

- [ ] **Step 6: CHECKPOINT — report for human commit (elatic_min repo)**

Ready: 5 symlinks, `LoadingBar.tsx`, `QueryView.tsx`. Suggested message: `refactor(styles): consume design-systems via symlink; unified LoadingBar`. Do not commit; report and continue.

---

### Task 7: Migrate `kafka_ui_min` to symlinks

**Files:**
- Replace with symlinks: `/Users/qc-bright/Project/kafka_ui_min/src/styles/{tokens,themes,base,layout,components}.css`
- Modify: `/Users/qc-bright/Project/kafka_ui_min/src/components/views/FullTopicSearch.tsx` (determinate bar swap)

**Interfaces:**
- Consumes: canonical CSS (Tasks 1–3); LoadingBar already updated in-place (Task 4).
- Produces: kafka_ui_min on symlinks; determinate search progress via `<LoadingBar value>`.

- [ ] **Step 1: Pre-flight — same superset check as Task 6 Step 1, for kafka_ui_min**

Run the same loop with `kafka_ui_min`. Expected: empty lists — kafka's old `.loading-bar` block is superseded by canonical's (same class names; canonical adds `.bottom`/`.determinate`). If other selectors appear, move to `views.css` first.

- [ ] **Step 2: Symlink swap**

Same as Task 6 Step 2 with `kafka_ui_min`. Expected: five symlinks; `views.css` regular.

- [ ] **Step 3: Swap FullTopicSearch's determinate bar**

In `/Users/qc-bright/Project/kafka_ui_min/src/components/views/FullTopicSearch.tsx`, find the `.full-progress-track` element (renders `<div className="full-progress-track"><span style={{ width: pct }}/></div>` or similar). Replace with:

```tsx
<LoadingBar active bottom value={fraction} />
```
where `fraction` is the existing progress value normalized to 0..1 (if the code has a percent string like `` `${pct}%` ``, pass `pct / 100`). Import LoadingBar if not already imported in that file. Then delete the now-unused `.full-progress-track` rules from `/Users/qc-bright/Project/kafka_ui_min/src/styles/views.css` (lines ~683–684).

- [ ] **Step 4: Build**

Run: `cd /Users/qc-bright/Project/kafka_ui_min && npm run build`
Expected: exits 0.

- [ ] **Step 5: Runtime smoke check**

Dev-run; check shell theming, an in-flight fetch (indeterminate line), and a full-topic search (determinate line filling left→right at the panel bottom). Kill dev process.

- [ ] **Step 6: CHECKPOINT — report for human commit (kafka_ui_min repo)**

Ready: 5 symlinks, `FullTopicSearch.tsx`, `views.css` trim. Suggested message: `refactor(styles): consume design-systems via symlink; determinate LoadingBar`. Do not commit; report and continue.

---

### Task 8: Migrate `redis_min` to symlinks

**Files:**
- Replace with symlinks: `/Users/qc-bright/Project/redis_min/src/styles/{tokens,themes,base,layout,components}.css`
- Create: `/Users/qc-bright/Project/redis_min/src/ui/LoadingBar.tsx`
- Modify: `/Users/qc-bright/Project/redis_min/src/components/views/KeysView.tsx` (loading swaps)

**Interfaces:**
- Consumes: canonical CSS (Tasks 1–3), `LoadingBar.tsx` (Task 4).
- Produces: redis_min on symlinks; both loading patterns via `<LoadingBar>`.

- [ ] **Step 1: Pre-flight — same superset check as Task 6 Step 1, for redis_min**

Expected: empty (redis's `.ai-session-*` and `select:focus` additions were promoted in Task 3; `.inspector-text` in Task 2). If anything appears, move to `views.css` first.

- [ ] **Step 2: Symlink swap**

Same as Task 6 Step 2 with `redis_min`. Expected: five symlinks; `views.css` regular.

- [ ] **Step 3: Copy LoadingBar + swap KeysView**

Run: `cp /Users/qc-bright/Project/kafka_ui_min/src/ui/LoadingBar.tsx /Users/qc-bright/Project/redis_min/src/ui/LoadingBar.tsx`

In `/Users/qc-bright/Project/redis_min/src/components/views/KeysView.tsx` (search `req-progress` and `full-progress`):
- indeterminate site → `<LoadingBar active={<existing boolean>} />`
- determinate `.full-progress-track` site → `<LoadingBar active bottom value={<existing 0..1 fraction>} />` (normalize a percent if needed)
- add `import { LoadingBar } from "../../ui/LoadingBar";` (adjust depth).

Then delete the unused `.full-progress-track` rules from `/Users/qc-bright/Project/redis_min/src/styles/views.css` (lines ~682–683).

- [ ] **Step 4: Build**

Run: `cd /Users/qc-bright/Project/redis_min && npm run build`
Expected: exits 0.

- [ ] **Step 5: Runtime smoke check**

Dev-run; check shell theming, keys scan loading (indeterminate) and full-search progress (determinate). Kill dev process.

- [ ] **Step 6: CHECKPOINT — report for human commit (redis_min repo)**

Ready: 5 symlinks, `LoadingBar.tsx`, `KeysView.tsx`, `views.css` trim. Suggested message: `refactor(styles): consume design-systems via symlink; unified LoadingBar`. Do not commit; report and continue.

---

### Task 9: Delete orphaned design-system copies in requests_min

**Files:**
- Delete: `/Users/qc-bright/Project/requests_min/design-systems/` (entire stale folder — old red-accent `#ff5f5f` theme, pre-dates canonical)
- Delete: `/Users/qc-bright/Project/requests_min/ref_design/` (228-line stray reference sheet)

**Interfaces:** none — dead files, imported nowhere.

- [ ] **Step 1: Prove they are unreferenced**

Run:
```bash
grep -rn "design-systems\|ref_design" /Users/qc-bright/Project/requests_min/src /Users/qc-bright/Project/requests_min/index.html /Users/qc-bright/Project/requests_min/vite.config.ts /Users/qc-bright/Project/requests_min/package.json 2>/dev/null
```
Expected: no output (the five symlinks in `src/styles/` point to `../../../design-systems/`, i.e. the Project-root canonical, NOT this folder — `ls -la src/styles` to confirm the target paths if unsure). If ANY reference appears, STOP and report instead of deleting.

- [ ] **Step 2: Delete**

Run:
```bash
rm -rf /Users/qc-bright/Project/requests_min/design-systems /Users/qc-bright/Project/requests_min/ref_design
```

- [ ] **Step 3: Build still green**

Run: `cd /Users/qc-bright/Project/requests_min && npm run build`
Expected: exits 0.

- [ ] **Step 4: CHECKPOINT — report for human commit (requests_min repo)**

Ready: two folders deleted. Suggested message: `chore: remove stale vendored design-system copies`. Do not commit; report done.

---

## Out of scope (deferred to Section D per spec)

- Per-app `views.css` re-skin against the showcase signature — separate plans, one per app.
- Removing the legacy `.req-progress` CSS from canonical (kept as alias until all markup is confirmed swapped).
- `elatic_min/design/index.html` (2665-line standalone prototype with unrelated tokens) — untouched; flag to the human for manual review.

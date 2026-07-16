# Design System Standardization — Design Doc

**Date:** 2026-07-16
**Scope:** Make `design-systems/` the single canonical source of the shared visual
language, symlinked into the four `_min` apps, with one unified loading system.

## Goal

Standardize UI/color/token/loading/components across the four sibling apps
(`requests_min`, `elatic_min`, `kafka_ui_min`, `redis_min`) so they update
automatically from one source. Chosen model: **symlink shared CSS + full re-skin**,
executed as **A+B+C first (foundation, one pass = all four apps), D later
(per-app view re-skin)**.

## Current state (surveyed 2026-07-16)

All four apps share a stack: React 18 + TS + Vite 5 + Tauri 2, same `src/ui/`
primitives, same shell components, per-app `views/`. Each app vendors a **copy** of
`src/styles/{tokens,themes,base,layout,components,views}.css`.

Token discipline is already high — **0 hardcoded hex** outside `tokens.css` /
`themes.css`; everything is `var()` + `color-mix()`. The problem is **not**
de-hardcoding. It is: (1) the shared layer is copied → drifts; (2) loading is
implemented three different ways; (3) the `design-systems/` source is **not
automatically newest** — divergence is bidirectional per file.

### Divergence map (measured)

| File | Canonical winner | Notes |
|------|------------------|-------|
| `themes.css` | tie — identical everywhere incl. source | No work. |
| `tokens.css` | **apps** (all 4 identical to each other) | Source stale 1 line: `--font-body-default: "Exo 2"` → apps correctly use `"Inter"`. |
| `base.css` | **kafka/redis (37 lines)** | Have `color-scheme` + native `datetime-local`/picker theming; source + elatic/requests (19 lines) lack it. |
| `layout.css` | **source (427 lines)** | Newest; requests_min ≈ source (8-line diff); elatic/kafka (391) + redis (403) are older. |
| `components.css` | **merge** | Every app differs 117–164 lines. Mix of universal drift (promote) and app-specific (keep app-local). |
| `views.css` | **stays app-local** | Genuinely per-app screens (Redis ≠ Kafka ≠ Elastic). Not part of the shared layer. |

### Loading — three drifted patterns to unify

- `.req-progress` + `@keyframes run` — indeterminate bar, all apps.
- `.loading-bar` + `<LoadingBar.tsx>` + `@keyframes loading-bar-slide` — kafka only
  (honors `prefers-reduced-motion`).
- `.full-progress-track` / `.full-search-progress` — determinate width bar, redis + kafka.

No spinners, no skeletons — consistent with the design system's no-spinner stance.

## Architecture (Section A)

`design-systems/` at repo root holds the canonical shared CSS. Each app's five
shared files become **symlinks**; `views.css` (+ optional `app.css`) stay real,
app-local files.

```
design-systems/                       # canonical — the ONLY place shared CSS is edited
  tokens.css  themes.css  base.css  layout.css  components.css

<app>/src/styles/
  tokens.css      -> ../../../design-systems/tokens.css   (symlink)
  themes.css      -> ../../../design-systems/themes.css   (symlink)
  base.css        -> ../../../design-systems/base.css     (symlink)
  layout.css      -> ../../../design-systems/layout.css   (symlink)
  components.css  -> ../../../design-systems/components.css(symlink)
  views.css       # real file — app's own screens
  app.css         # real file — app-only overrides, only if needed
```

Relative symlink (`../../../`) resolves within `/Users/qc-bright/Project/` and is
portable if the whole `Project/` tree moves. Vite resolves symlinks at build time,
so bundling is unaffected.

**Known ceiling (accepted):** symlinks point outside each app's git repo, so they
break on `git clone` to another machine / CI. Acceptable for the local `_min`
family. Upgrade path if CI is ever needed: replace symlinks with a `sync.sh` that
copies `design-systems/*.css` into each `src/styles/`, run on demand or in a
pre-build hook. `// ponytail: symlink, copy-sync if CI ever needs it`.

## Reconcile canonical (Section B) — MUST precede symlinking

Symlinking replaces each app's working CSS with the source's version, so the source
must first become the true superset. Method, per shared file:

1. **`themes.css`** — no change (identical).
2. **`tokens.css`** — take the apps' version (fix `--font-body-default` to `"Inter"`);
   diff to confirm that is the only delta.
3. **`base.css`** — adopt the 37-line kafka/redis version (native input theming) as canonical.
4. **`layout.css`** — start from source (427, newest); diff each app's copy; fold in
   any app-only rule that is genuinely shared-worthy, drop app-specific one-offs.
5. **`components.css`** — the real merge. For each app's 117–164 diff lines, classify:
   - **universal → promote** into canonical `components.css` (e.g. the loading system, common
     `.inspector-*` / `.metric-*` primitives present in multiple apps).
   - **app-specific → move** to that app's `views.css` / `app.css` (e.g. redis `.method-select`
     variants, kafka-only view chrome).
6. After building canonical, **render `design-systems/index.html`** (the showcase) in
   light + dark + a few `data-theme` palettes to confirm nothing visually regressed.

## Unified loading system (Section C)

Collapse the three patterns into **one** system living in canonical `components.css`
plus one shared React primitive:

- CSS: a single `.loading-bar` supporting **indeterminate** (default, `@keyframes`
  slide) and **determinate** (`--progress` width var) modes; honors
  `prefers-reduced-motion`. `.req-progress` and `.full-progress-track` become thin
  aliases / removed in favor of it.
- React: one `<LoadingBar indeterminate | value={0..1} />` primitive in `src/ui/`,
  identical across all four apps (kafka's is the seed). Each app swaps its ad-hoc
  loading markup to this component.
- No spinner, no skeleton — unchanged stance.

## Section D (later, per-app) — view re-skin

Out of scope for this spec's first pass; tracked as follow-up. For each app: audit
`views.css` against the showcase signature (spacing, radius, reuse shared primitives
instead of one-offs, adopt the unified `<LoadingBar>`), one app per plan.

## Verification

- `design-systems/index.html` renders correctly (light/dark/themes) after B.
- Each app builds (`vite build` / `tsc`) with symlinked CSS.
- Each app launches (Tauri dev) and its shell + a loading flow render correctly.
- No new hardcoded hex introduced (`grep` the non-token CSS).
- `git status` in each app shows the five files now as symlinks, `views.css` intact.

## Non-goals

- Not touching `tokens.css` values / the 27 themes (already canonical).
- Not converting to an npm/git package (symlink chosen over package).
- Not refactoring app TS logic beyond swapping the loading component.
- Section D view re-skins — separate specs/plans, later.

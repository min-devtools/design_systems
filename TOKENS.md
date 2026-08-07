# Design Tokens

Every value below is the **real** value shipped in `tokens.css` (default dark
`:root`) and `body.light`. Root font size is **13px**, so `rem` values map:
`1rem = 13px`, `0.9231rem ≈ 12px`, `0.8462rem ≈ 11px`, `0.7692rem ≈ 10px`,
`1.1538rem = 15px`, `1.6154rem ≈ 21px`.

`tokens.css` is the source of truth — change it there first, then update the table.
This file drifted once already (`--left-w` documented as 258px while 322px shipped,
`--shadow` documented as `none` in light after the real value was fixed in CSS), so
treat a mismatch as a doc bug, never as a reason to change the CSS.

## Surface layers

Stacked from deepest background to raised hover. In dark, `--pane` equals
`--app-bg` on purpose — depth comes from `--pane-2`/`--pane-3`, not `--pane`.

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--app-bg` | `#1c2433` | `#F6F7F9` | Deepest app background, editor |
| `--window` | `#181f2c` | `#FFFFFF` | Titlebar/statusbar/workspace shell |
| `--pane` | `#1c2433` | `#FFFFFF` | Sidebar, inspector, panels, cards |
| `--pane-2` | `#253043` | `#F9FAFB` | Inputs, raised cards, hovered nav rows |
| `--pane-3` | `#2a364d` | `#ECEFF4` | Stronger hover / pressed / kbd pills |
| `--editor-bg` | `#1c2433` | `#FFFFFF` | Code editor / JSON tree background |
| `--editor-fg` | `#d0d7e4` | `#3B1D7A` | Editor text |
| `--glass` | `rgba(24,31,44,.82)` | `rgba(255,255,255,.92)` | Overlay/palette/menu backdrop |

## Text

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--text` | `#d0d7e4` | `#3B1D7A` | Primary text — light uses purple ink, not neutral black (10.8:1 dark / 12.8:1 light, AAA) |
| `--text-2` | `#afbbd2` | `#6533C7` | Secondary text, labels (8.1:1 / 7.4:1, AAA) |
| `--text-3` | `#778cb3` | `#8064c2` | Muted, placeholders, form labels, section titles (4.6:1 / 4.7:1, **AA**) |

All three tiers clear AA 4.5:1 against `--pane`, in every one of the 27 palettes.
`--text-3` is not a decorative tier: `components.css` uses it for `.form-row label`,
`.metric .label`, `.cell-date`, input placeholders and 10px `kbd` pills — content, and
below 12px there is no large-text exemption. When adding or retuning a palette, hold hue
and saturation and walk lightness until each tier passes, keeping a ≥1.15× contrast step
between tiers so the ramp stays three distinguishable tones rather than collapsing to two.

## Borders

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--line` | `rgba(17,22,31,.55)` | `#E0E4EB` | 1px hairline (default) |
| `--line-2` | `rgba(17,22,31,.9)` | `#D4DAE4` | Stronger 1px border |

## Accent + status colors

One accent family. On dark the "blue" is a desaturated slate-blue; on light it
collapses to the `#7A3EED` brand purple.

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--accent` | `var(--blue)` | `var(--blue)` | Brand accent (buttons, resize glow, links) |
| `--blue` | `#8196b5` | `#8B33FF` | Primary action, focus, syntax keys |
| `--blue-2` | `#69C3FF` | `#0074CC` | Primary button fill, numbers, info |
| `--green` | `#3CEC85` | `#1D9042` | Success, healthy, money, strings |
| `--orange` | `#FF955C` | `#B85C00` | Warning, pending, dirty, state |
| `--red` | `#E35535` | `#D61F6B` | Error, danger, null |
| `--purple` | `#F38CEC` | `#A855F7` | IDs, SKUs, env tokens, booleans |

`body.light` also defines `--yellow: #AD8200`, which the dark base does not.
These carry UI meaning (dots, badges, rails) as well as syntax, so each clears the
3:1 non-text minimum against `--pane` in every palette — several editor-theme ports
originally sat near 2:1 here, because in their source themes the color only ever
landed on syntax, never on a solid UI fill.

## Connection colors

The palette a user picks from to give a connection / repository / collection an
identity color. Every tab bound to that owner carries the color as a dot, so two
tabs of the same kind on different servers are never confused.

Unlike everything else here these are **theme-independent** and declared `:root`
only. The color is an identity the user chose, not a themed surface — it must
look the same in every theme, and re-tinting it across 20+ themes would destroy
the recognition it exists for. Values are Radix scale-9 solids, the tier built to
hold contrast on both light and dark, so one set covers all themes.

Eight of them, so the picker plus its "none" cell is a square 3×3. Teal and
indigo were dropped as the two least separable — teal sits on green, indigo on
blue — and a palette whose colors get confused defeats the point.

| Token | Hex | | Token | Hex |
|-------|-----|-|-------|-----|
| `--conn-red` | `#E5484D` | | `--conn-blue` | `#0090FF` |
| `--conn-orange` | `#F76B15` | | `--conn-purple` | `#8E4EC6` |
| `--conn-amber` | `#FFB224` | | `--conn-pink` | `#D6409F` |
| `--conn-green` | `#30A46C` | | `--conn-slate` | `#7C8698` |

Apps store the token **name** (`"blue"`), never the hex, so the palette can be
retuned without migrating saved data. See `src/lib/connColor.ts` in any app: it
sets `--conn` inline, and the components below read it. `connStyle()` validates
the name against the palette first — a color later dropped from the set can
still be sitting in a persisted store, and emitting `var(--conn-teal)` for a
token that no longer exists would poison the whole declaration. Unvalidated or
unset = no `--conn`, and every `var(--conn, …)` falls back to what it used
before colors existed.

## Row backgrounds (tables)

| Token | Dark | Light |
|-------|------|-------|
| `--row` | `rgba(255,255,255,.025)` | `rgba(19,24,32,.018)` |
| `--row-alt` | `rgba(255,255,255,.04)` | `rgba(19,24,32,.035)` |

## Semantic aliases

Theme-agnostic names that map onto the raw tokens above. Prefer these in new code.

| Alias | Maps to |
|-------|---------|
| `--surface-app` / `-window` / `-panel` / `-raised` / `-hover` / `-editor` / `-overlay` | `--app-bg` / `--window` / `--pane` / `--pane-2` / `--pane-3` / `--editor-bg` / `--glass` |
| `--text-primary` / `-secondary` / `-muted` | `--text` / `--text-2` / `--text-3` |
| `--text-on-accent` | `--editor-bg` |
| `--border-default` / `--border-strong` | `--line` / `--line-2` |
| `--accent-primary` / `-secondary` / `-focus` | `--blue` / `--blue-2` / `--blue` |
| `--status-success` / `-warning` / `-danger` / `-info` | `--green` / `--orange` / `--red` / `--blue-2` |

## Syntax highlighting

| Token | Dark → | Light (contrast-tuned for white bg) |
|-------|--------|-------------------------------------|
| `--syntax-key` | `--blue` | `#7c3aed` |
| `--syntax-string` | `--green` | `#047857` |
| `--syntax-number` | `--blue-2` | `#1d4ed8` |
| `--syntax-boolean` | `--purple` | `#be185d` |
| `--syntax-null` | `--red` | `#be123c` |
| `--syntax-punctuation` | `--text-3` | `#6b5f79` |
| `--syntax-operator` | `--text-2` | `#5b4a6e` |
| `--syntax-type` | `--orange` | `#b45309` |
| `--syntax-function` | `--blue-2` | `#1d4ed8` |
| `--syntax-property` | `--syntax-key` | `#7c3aed` |
| `--syntax-variable` | `--text` | `#3B1D7A` |
| `--syntax-comment` | `--text-3` | `#8b7fa0` |
| `--syntax-parameter` | `--text-2` | `#6533C7` |
| `--syntax-constant` | `--purple` | `#be185d` |
| `--syntax-tag` | `--orange` | `#b45309` |

`tokens.css` is the only file **in this repo** that defines these. The 27 palettes in
`themes.css` override the raw color tokens but deliberately carry no `--syntax-*` of
their own, so on every alternate palette the syntax colors fall through to the values
above. `themeContract.ts` maps whatever computes out into Monaco.

An app may add a per-theme override locally — `git_min/src/styles/syntax-themes.css` is
one, generated from `netherize_editor/config/themes/*.toml` and imported after
`themes.css`. That file is **app-local, not part of this design system**; the other six
apps ship without it and rely on the fallbacks above.

That leaves one load-bearing detail: the light palettes get the contrast-tuned light
syntax colors purely because `body.light` (in `tokens.css`) and `body[data-theme="…"]`
(in `themes.css`) have **identical specificity** (0-1-1), so the winner is decided by
import order — `tokens.css` before `themes.css`. `themes.css` wins for the raw colors it
redefines; `body.light` keeps `--syntax-*`, `--shadow`, `--control-*`, `--selection` and
`--focus`, which no palette touches. Swap those two imports and every light theme
silently renders dark-tuned syntax on a white editor. Apps must import in that order.

## Highlight

One accent-based highlight system. Rails, focused paths, selected fields and
active titles read these instead of inlining `color-mix()` per component.

| Token | Value |
|-------|-------|
| `--accent-line` | `var(--accent)` — 2px rails and underlines |
| `--accent-soft` | `color-mix(in oklab, var(--accent), transparent 86%)` — selected row/cmd fill |
| `--accent-soft-strong` | `color-mix(in oklab, var(--accent), transparent 74%)` — its 1px inset border |

## Motion

**Corporate** archetype: compact, calm, decisive, keyboard-first. No overshoot, no bounce.

| Token | Value | Use |
|-------|-------|-----|
| `--motion-fast` | `120ms` | hover, press, dialog/palette exit |
| `--motion-standard` | `180ms` | selection, expand/collapse, palette entry, result reveal |
| `--motion-slow` | `260ms` | the rare large move |
| `--ease-ui` | `cubic-bezier(.2, 0, 0, 1)` | default for state changes |
| `--ease-enter` | `cubic-bezier(.05, .7, .1, 1)` | things arriving |
| `--ease-exit` | `cubic-bezier(.3, 0, 1, 1)` | things leaving |

`prefers-reduced-motion: reduce` is handled globally at the bottom of `base.css`:
durations collapse to 1ms and motion-only transforms are dropped, while opacity and
color state changes stay legible. Looping progress indicators (`.loading-bar span`,
`.req-progress span`, `.veil-spinner`) are re-pointed at a slow opacity pulse in
`components.css` so they don't freeze mid-loop and read as "stuck".

## Typography

| Token | Value |
|-------|-------|
| `--font-body` | `"Exo 2", system-ui, -apple-system, BlinkMacSystemFont, sans-serif` |
| `--font-mono` | `"Google Sans Code", "Berkeley Mono", ui-monospace, Menlo, Consolas, monospace` |

- Root: `html { font-size: 13px }` (overridable via `--ui-font-size`).
- Body: `font: 450 1rem/1.45 var(--font-body)` — note weight **450**, not 400.
- Mono (**Google Sans Code**, Berkeley Mono fallback) is used for: code, IDs,
  tables, status bar, badges, kbd pills, method tags, path chips, combobox values.
- **Exo 2 is bundled locally** (SIL OFL 1.1) as `fonts/exo2-{latin,latin-ext,vietnamese}.woff2`
  and registered with `@font-face` at the top of `base.css` — one variable file per
  unicode subset, `font-weight: 100 900`, `font-display: swap`. No CDN: Tauri CSP
  blocks font hosts, and the apps must render offline.
- The user's Interface Font setting still wins — apps set `--font-body` inline on
  `documentElement`, which shadows the `--font-body-default` stack.
- Section/group titles: `text-transform: uppercase; letter-spacing: .06em; color: var(--text-3)`.

### Type scale

`rem` resolves against `--ui-font-size` (13px default), so every step follows the user's
UI-scale setting. px values below are at the default scale.

| Token | Value | px | Usage |
|-------|-------|----|-------|
| `--fs-xs` | `0.7692rem` | 10 | `kbd` pills, badges, tree summaries |
| `--fs-sm` | `0.8462rem` | 11 | Metric labels, captions |
| `--fs-md` | `0.9231rem` | 12 | **Default UI text** — labels, rows, buttons |
| `--fs-base` | `1rem` | 13 | Editors, primary rows |
| `--fs-lg` | `1.0769rem` | 14 | Card titles |
| `--fs-xl` | `1.3846rem` | 18 | Page/section headings |

Never `font-size: <n>px` — a px literal bypasses `--ui-font-size` and stops responding to
the UI-scale setting.

## Geometry

Color got an alias layer, a tint rule and this doc; geometry had 21 distinct radii, 21
font sizes and every integer from 2 to 16 as padding. These tokens **codify the values
already dominant** in the shared CSS rather than introduce a new scale. Outliers stay
literal so they read as the exceptions they are; migrate them when you touch the block
anyway.

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | `6px` | Chips, `kbd` pills, small inputs |
| `--radius-md` | `8px` | **Default** — buttons, rows, cards |
| `--radius-lg` | `10px` | Panels, modals, floating surfaces |
| `--radius-pill` | `999px` | Fully rounded |
| `--radius-circle` | `50%` | Dots, avatars |
| `--space-1` … `--space-5` | `4 / 8 / 12 / 16 / 24px` | Padding, gap |

Spacing is not yet migrated — the tokens exist for new code, the literals stay until the
surrounding rule changes.

## Layout dimensions

| Token | Value | Usage |
|-------|-------|-------|
| `--left-w` | `322px` | Sidebar width (`body.compact` → 230px) |
| `--right-w` | `410px` | Inspector width (`body.compact` → 300px) |
| `--query-top` | `48vh` | Query editor default height |
| `--request-top` | `48%` | Request editor split |

Shell grid: `.app-frame` rows are `42px 1fr 28px` (titlebar / body / statusbar).
`.main` columns are `var(--left-w) minmax(520px,1fr) var(--right-w)`.

## Effects

| Token | Value |
|-------|-------|
| `--shadow` | `0 18px 60px color-mix(in oklab, var(--surface-app), transparent 45%)` (dark) / `0 18px 48px rgba(59,26,110,.12), 0 2px 8px rgba(59,26,110,.08)` (light) — must stay a full `box-shadow` value, a bare color makes `box-shadow: var(--shadow)` invalid and silently drops elevation on every floating pill |
| `--focus-ring` | `color-mix(in oklab, var(--accent-focus), transparent 84%)` |
| `--surface-selected` | `color-mix(in oklab, var(--accent-primary), transparent 86%)` |
| `--modal-backdrop` | `color-mix(in oklab, var(--surface-app), transparent 28%)` |

**The tint rule:** hover/selection/soft-fill states are always
`color-mix(in oklab, <token>, transparent N%)` — never a new hex. Common Ns:
`84–90%` for soft fills, `62–74%` for borders, `82–86%` for glows/rings.

## Stacking order

Nothing in the app shell creates a stacking context — `.app-frame` and `.main` are
`position: relative` with no `z-index` — so every layer here competes in the root
context. Use the token, never a fresh number; when a component must sit one step above
its own layer, `calc()` on that layer.

| Token | Value | Layer |
|-------|-------|-------|
| `--z-raised` | `2` | Lifted above in-flow siblings |
| `--z-veil` | `5` | Section veils, loading strips (`+1` for the bar over the veil) |
| `--z-chrome` | `30` | App-shell furniture: resize handles, corner toggles (`+5`) |
| `--z-menu` | `40` | Combobox lists, context menus, floating popovers |
| `--z-suggest` | `50` | Input-attached suggestions, above their own menu layer |
| `--z-overlay` | `60` | Modal + command-palette scrims — above all shell chrome |
| `--z-toast` | `70` | Above modals by design: a toast must survive a dialog |

The scrims were previously `24` (`.modal`) and `20` (`.command`), i.e. *below* resize
handles, context menus and suggestion popovers, all of which stayed painted and clickable
over the backdrop. If you add a layer, place it in this table first.

## Themes

Default is dark (`:root`). Two switches:

- `body.light` — the light theme (purple brand).
- `body[data-theme="…"]` — one of 27 curated palettes in `themes.css`, generated
  from popular editor themes and shared identically across all my apps.

The 27 palettes each override the raw color tokens (`--app-bg`, `--text`,
`--blue`, `--green`, … and `--editor-bg/fg`); the semantic aliases and every
component inherit automatically:

```
aura-dark · ayu-mirage · bearded-arc-blueberry · bearded-arc-eggplant
bearded-arc-eolstorm · bearded-arc-reversed · bearded-solarized
bearded-solarized-dark · bearded-solarized-light · bearded-solarized-reversed
catppuccin-mocha · cyberpunk-neon · default-dark · dracula · gruv-box · monokai
night-owl · nord-ford · one-dark · rose-milk · rose-pine · sakura-pastel
slate-neutral-dark · slate-neutral-dark-schematic · soft-light · tokyo-night
vscode-dark
```

(`default-dark` mirrors the built-in `:root`, so there are 26 alternate
palettes plus the default.)

```js
document.body.dataset.theme = "tokyo-night";  // apply
document.body.classList.add("light");         // or light mode
```

# Design Tokens

Every value below is the **real** value shipped in `tokens.css` (default dark
`:root`) and `body.light`. Root font size is **13px**, so `rem` values map:
`1rem = 13px`, `0.9231rem ≈ 12px`, `0.8462rem ≈ 11px`, `0.7692rem ≈ 10px`,
`1.1538rem = 15px`, `1.6154rem ≈ 21px`.

## Surface layers

Stacked from deepest background to raised hover. In dark, `--pane` equals
`--app-bg` on purpose — depth comes from `--pane-2`/`--pane-3`, not `--pane`.

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--app-bg` | `#1c2433` | `#f9f8fa` | Deepest app background, editor |
| `--window` | `#181f2c` | `#f9f8fa` | Titlebar/statusbar/workspace shell |
| `--pane` | `#1c2433` | `#ffffff` | Sidebar, inspector, panels, cards |
| `--pane-2` | `#253043` | `#f0ecf4` | Inputs, raised cards, hovered nav rows |
| `--pane-3` | `#2a364d` | `#efebf2` | Stronger hover / pressed / kbd pills |
| `--editor-bg` | `#1c2433` | `#ffffff` | Code editor / JSON tree background |
| `--editor-fg` | `#d0d7e4` | `#3b1d7a` | Editor text |
| `--glass` | `rgba(24,31,44,.82)` | `rgba(255,255,255,.78)` | Overlay/palette/menu backdrop |

## Text

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--text` | `#d0d7e4` | `#3b1d7a` | Primary text — light uses purple ink, not neutral black (12.8:1 on white, AAA) |
| `--text-2` | `#afbbd2` | `#6533c7` | Secondary text, labels (7.4:1, AAA) |
| `--text-3` | `#4a5e84` | `#9b85cf` | Muted, placeholders, section titles (~3.2:1, decorative/UI only) |

## Borders

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--line` | `rgba(17,22,31,.55)` | `#efebf2` | 1px hairline (default) |
| `--line-2` | `rgba(17,22,31,.9)` | `#e3ddea` | Stronger 1px border |

## Accent + status colors

One accent family. On dark the "blue" is a desaturated slate-blue; on light it
collapses to the `#7A3EED` brand purple.

| Token | Dark | Light | Usage |
|-------|------|-------|-------|
| `--accent` | `var(--blue)` | `#7A3EED` | Brand accent (buttons, resize glow, links) |
| `--blue` | `#8196b5` | `#7A3EED` | Primary action, focus, syntax keys |
| `--blue-2` | `#69C3FF` | `#7A3EED` | Primary button fill, numbers, info |
| `--green` | `#3CEC85` | `#10b981` | Success, healthy, money, strings |
| `--orange` | `#FF955C` | `#d97706` | Warning, pending, dirty, state |
| `--red` | `#E35535` | `#f43f5e` | Error, danger, null |
| `--purple` | `#F38CEC` | `#7A3EED` | IDs, SKUs, env tokens, booleans |

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
| `--row` | `rgba(255,255,255,.025)` | `#ffffff` |
| `--row-alt` | `rgba(255,255,255,.04)` | `#f9f8fa` |

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

`tokens.css` owns these fallbacks (JSON trees, quick-query code, any CSS-rendered
syntax). `syntax-themes.css` overrides them per selected editor theme, and
`themeContract.ts` maps the computed values into Monaco — so all three stay in sync.

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

## Layout dimensions

| Token | Value | Usage |
|-------|-------|-------|
| `--left-w` | `258px` | Sidebar width (`body.compact` → 230px) |
| `--right-w` | `328px` | Inspector width (`body.compact` → 300px) |
| `--query-top` | `48vh` | Query editor default height |
| `--request-top` | `48%` | Request editor split |

Shell grid: `.app-frame` rows are `42px 1fr 28px` (titlebar / body / statusbar).
`.main` columns are `var(--left-w) minmax(520px,1fr) var(--right-w)`.

## Effects

| Token | Value |
|-------|-------|
| `--shadow` | `0 18px 60px color-mix(in oklab, var(--surface-app), transparent 45%)` (dark) / `none` (light) |
| `--focus-ring` | `color-mix(in oklab, var(--accent-focus), transparent 84%)` |
| `--surface-selected` | `color-mix(in oklab, var(--accent-primary), transparent 86%)` |
| `--modal-backdrop` | `color-mix(in oklab, var(--surface-app), transparent 28%)` |

**The tint rule:** hover/selection/soft-fill states are always
`color-mix(in oklab, <token>, transparent N%)` — never a new hex. Common Ns:
`84–90%` for soft fills, `62–74%` for borders, `82–86%` for glows/rings.

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

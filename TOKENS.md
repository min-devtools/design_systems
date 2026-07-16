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

## Typography

| Token | Value |
|-------|-------|
| `--font-body` | `"Inter", system-ui, -apple-system, BlinkMacSystemFont, sans-serif` |
| `--font-mono` | `"Google Sans Code", "Berkeley Mono", ui-monospace, Menlo, Consolas, monospace` |

- Root: `html { font-size: 13px }` (overridable via `--ui-font-size`).
- Body: `font: 450 1rem/1.45 var(--font-body)` — note weight **450**, not 400.
- Mono (**Google Sans Code**, Berkeley Mono fallback) is used for: code, IDs,
  tables, status bar, badges, kbd pills, method tags, path chips, combobox values.
- Both fonts are on Google Fonts — see README "Dependencies" for the load snippet.
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

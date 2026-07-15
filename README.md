# Design System

The shared visual language behind my desktop developer tools (`requests_min`,
`elatic_min`, and future apps). Both apps ship the **exact same** `tokens.css`
and `themes.css` — this folder is the canonical source of that language, taken
from `requests_min`.

The point of this folder: anyone building a new app can drop these four CSS
files in, follow the docs, and the result will read as **one family of apps** —
recognizably mine.

---

## The signature — how you know it's one of my apps

If someone opens the app, these traits identify it at a glance:

1. **Dark-first, slate-navy chrome.** Default background is `#1c2433` (the
   *Bearded Arc* palette), not black, not gray — a cool blue-slate. Light mode
   is opt-in and carries a **`#7A3EED` purple** brand accent.
2. **Native macOS desktop frame.** Tauri app. A 42px titlebar with traffic-light
   padding on the left, tools on the right; a 28px monospace status bar at the
   bottom; a three-column shell in between.
3. **Three-pane layout.** Sidebar (`258px`) │ workspace │ inspector (`328px`),
   each divided by 1px hairlines, resizable via handles that light up with a
   **glowing blue bar** on hover.
4. **Rounded-top browser tabs.** `10px 10px 0 0` corners, the active tab washed
   with a faint blue top-gradient and a hairline top highlight, an orange
   **dirty-dot** for unsaved edits, drag-to-reorder, colored method tags
   (GET/POST/PUT/DELETE).
5. **Restrained color.** Grayscale surfaces + **one** accent (a desaturated blue
   on dark, purple on light) + four semantic colors (green / orange / red /
   purple). No Material, no gradients-as-decoration, no dashboard cards.
6. **Two typefaces only.** **Inter** for UI, **Google Sans Code** for everything
   structural — code, IDs, tables, status bar, badges, keyboard hints. (Both on
   Google Fonts. Berkeley Mono is kept as a mono fallback.)
7. **Frosted overlays.** Command palette, context menus, toasts, comboboxes all
   float on `backdrop-filter: blur() saturate(160%)` glass.
8. **`color-mix(in oklab, …)` tints.** Every hover, selection, and soft-fill is a
   transparent mix of a base token — never a separate hardcoded color.
9. **Line-drawn icons.** [lucide](https://lucide.dev) at `strokeWidth: 1.8`,
   ~15px. See `ICONS.md`.
10. **Keyboard-first.** ⌘K command palette, editable tab titles, monospace
    shortcut pills everywhere.

---

## Files

| File | What it is |
|------|-----------|
| `tokens.css` | Core custom properties — default dark + `body.light`. **The foundation.** |
| `themes.css` | 27 curated `data-theme` palettes (shared across all apps). |
| `base.css` | Reset, root font size, body typography. |
| `layout.css` | App shell: titlebar, sidebar, workspace, tabs, inspector, statusbar, resize handles. |
| `components.css` | Every primitive: buttons, inputs, badges, tables, overlays, JSON tree, AI chat. |
| `TOKENS.md` | Token dictionary — real names, real values, usage. |
| `COMPONENTS.md` | Class-by-class component guide. |
| `ICONS.md` | The icon language (lucide names, size, stroke). |
| `index.html` | Live showcase — open in a browser, toggle light/dark, switch themes. |

## Load order

```css
@import "tokens.css";   /* variables first */
@import "themes.css";   /* optional: extra palettes */
@import "base.css";     /* reset + body */
@import "layout.css";   /* shell */
@import "components.css";/* primitives */
```

## Dependencies (to build a real app, not just read)

The CSS assumes two fonts and one icon lib exist. Add them:

**Fonts** — Inter (UI) + Google Sans Code (mono), both free on Google Fonts:

```html
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Google+Sans+Code:ital,wght@0,300..800;1,300..800&family=Inter:wght@100..900&display=swap" rel="stylesheet" />
```

Or via CSS: `@import url("https://fonts.googleapis.com/css2?family=Google+Sans+Code:wght@300..800&family=Inter:wght@100..900&display=swap");`

**Icons** — lucide: `npm i lucide-react`. See `ICONS.md`.

Pure-CSS parts (`tokens/themes/base/layout/components.css`) have **zero**
dependencies — drop in and go.

## Non-negotiable rules

- **Default is dark.** Add `class="light"` to `<body>` for light mode. Add
  `data-theme="…"` for one of the 27 palettes.
- **Surfaces are layered, never flat:** `--app-bg` → `--window` → `--pane` →
  `--pane-2` → `--pane-3`. Deeper = further back.
- **Borders are 1px** `var(--line)` (hairline) or `var(--line-2)` (stronger).
- **Radius:** 8px controls, 9–10px panels/cards/inputs, 12–14px overlays,
  10px 10px 0 0 tabs, 999px pills/dots.
- **One accent family.** `--blue`/`--blue-2` for primary + focus, `--green`/
  `--orange`/`--red`/`--purple` for status/semantics only.
- **Tints via `color-mix(in oklab, <token>, transparent N%)`** — do not invent
  new hex for a hover or selection state.
- **Type:** Inter for UI, Google Sans Code for code/IDs/tables/status/kbd. 13px root.
- **No** Material Design, heavy drop-shadows, gradient hero backgrounds, or
  rounded dashboard cards.

# Shared UI Motion And Syntax Design

## Goal

Make the six Min apps feel like one responsive desktop-tool family through shared typography, motion, interaction states, syntax colors, and operation feedback. All shared visual changes live in `design-systems/` and flow to app CSS through existing symlinks.

## Scope

- UI typography only: bundle Exo 2 locally for interface chrome and body text.
- Keep existing monospace/editor stacks unchanged for code, request bodies, logs, diffs, JSON, hashes, IDs, and terminal-like content.
- Establish one shared motion token contract and a complete reduced-motion fallback.
- Improve existing tabs, sidebar rows, collapsible section headers, and command palette states without changing interaction semantics.
- Unify shared syntax token semantics while leaving per-app language/theme generators as the source for editor-specific syntax themes.
- Standardize existing loading, success, and error feedback. Do not introduce ambient animation, route fades, or notification-system changes.

## Non-goals

- No Tauri windowing, native shell, notification, updater, Settings, or state-flow changes.
- No new animation library or JavaScript animation runtime.
- No page transitions, bouncy motion, parallax, decorative particle effects, or looping ambient effects.
- No replacement of Monaco, Tree-sitter, existing syntax-theme generators, or app-specific editor settings.

## Motion Personality

Use the **Corporate** archetype: compact, calm, decisive, and keyboard-first.

```css
--motion-fast: 120ms;
--motion-standard: 180ms;
--motion-slow: 260ms;
--ease-ui: cubic-bezier(.2, 0, 0, 1);
--ease-enter: cubic-bezier(.05, .7, .1, 1);
--ease-exit: cubic-bezier(.3, 0, 1, 1);
```

- Hover and press feedback: 120ms.
- Selection, expand/collapse, palette entry: 180ms.
- Dialog/palette exit: 120ms using `--ease-exit`.
- No overshoot or bounce.
- `prefers-reduced-motion: reduce` sets animation duration to near-zero and removes transforms while preserving opacity/state changes.

## Typography

### Asset

Bundle Exo 2 from an OFL-compatible source as local WOFF2 assets under `design-systems/fonts/`:

- Regular 400
- Medium 500
- SemiBold 600
- Bold 700

Register them with `@font-face` in shared `base.css` using `font-display: swap`.

### Contract

```css
--font-body-default: "Exo 2", system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
--font-mono-default: "Google Sans Code", "Berkeley Mono", ui-monospace, Menlo, Consolas, monospace;
```

Existing user-selected Interface Font remains the highest priority through the `--font-body` inline override in each app `App.tsx`.

## Interaction Pass

### Tabs

- The active tab gets a 2px accent underline through a pseudo-element.
- Underline uses `transform: scaleX()` to enter/exit without layout movement.
- Active tab title increases to weight 600; inactive stays current muted treatment.
- Close control remains visually quiet until tab hover/focus. It fades and scales in, never changes layout.
- Tab click and close behavior stay unchanged.

### Sidebar Rows

- Selected row gets a 2px left accent rail using a pseudo-element.
- Rail appears with `scaleY()`; background/color transition use `--motion-fast`.
- Hover remains a low-opacity tint. No hand cursor and no row translation.
- Existing collapse chevrons rotate over `--motion-standard` with `--ease-ui`.

### Section Headers

- Section heading receives a restrained left accent rail only when its group is focused, selected, or contains an active item.
- Collapsible section body animates grid-row/opacity, avoiding height animation on arbitrary content.
- A collapsed section must preserve keyboard navigation and current data state.

### Command Palette

- Overlay enters from `translateY(-8px)` plus opacity and scale `.985` over 180ms.
- Dismissal is 120ms opacity plus `translateY(-4px)`.
- Active command row changes background/color over 120ms; no list row translation.
- Existing fuzzy highlighting, Recents, keyboard movement, and click behavior remain unchanged.

## Syntax Pass

Shared semantic roles remain the API:

```css
--syntax-key;
--syntax-string;
--syntax-number;
--syntax-boolean;
--syntax-null;
--syntax-operator;
--syntax-punctuation;
--syntax-type;
--syntax-function;
--syntax-property;
--syntax-variable;
--syntax-comment;
--syntax-parameter;
--syntax-constant;
--syntax-tag;
```

- `tokens.css` owns fallback semantic values for JSON trees and other CSS-rendered syntax.
- `syntax-themes.css` remains editor-theme-specific and may override values per selected theme.
- `themeContract.ts` continues mapping semantic CSS values to Monaco.
- Add the missing CSS selectors for existing semantic roles where JSON tree/quick-query UI lacks them.
- Focused paths, selected fields, and active title labels use one `--accent`-based highlight system, not one-off hardcoded colors.

## Loading, Success, And Error Feedback

- Keep existing loading bars and spinners. Standardize their timing on motion tokens.
- Loading state appears only after the operation crosses 200ms where existing code can determine it; no skeletons.
- Request/query result panel uses a single 180ms opacity + 6px Y reveal after a fresh response.
- Validation error uses a 300ms two-oscillation horizontal shake plus error tint, only for direct form validation failures.
- Success uses accent/green state transition only; no confetti, bounce, or persistent animation.

## Files And Ownership

| Area | Primary files |
|---|---|
| Font assets and registration | `design-systems/fonts/*`, `base.css`, `tokens.css` |
| Tokens and reduced motion | `tokens.css`, `base.css` |
| Shared tabs/sidebar/section motion | `layout.css`, `components.css` |
| Shared palette and feedback | `components.css` |
| Syntax semantic selectors | `tokens.css`, `components.css` |
| Editor mappings | app-local `themeContract.ts` only if a semantic role is missing |
| App-local result reveal/form validation | affected app view CSS only after shared pass is verified |

## Verification

1. Run `npx tsc --noEmit` for all six apps.
2. Build representative apps: `git_min`, `requests_min`, `log_min`.
3. Manual visual test in `git_min`:
   - tabs active/close/focus states
   - sidebar selection and collapse
   - command palette open, fuzzy query, Recents, Escape close
   - syntax in diff/editor and JSON tree
4. Manual visual test in `requests_min`:
   - request response reveal and validation error
   - JSON request/response syntax remains monospace
5. Enable macOS Reduce Motion and confirm transforms/loops stop while state changes remain legible.

## Rollout Order

1. Exo 2 assets and typography contract.
2. Motion tokens and reduced-motion fallback.
3. Tabs/sidebar/section/palette interaction pass.
4. Syntax semantic selector pass.
5. Result reveal, loading, and validation feedback.

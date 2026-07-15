# Icon System

One icon library, one component, one look — across every app.

## The rules

- **Library:** [lucide](https://lucide.dev) (`lucide-react`). Line icons only,
  no filled/duotone sets, no emoji in the UI chrome.
- **Stroke:** `strokeWidth={1.8}` — always. This exact weight is part of the
  signature; thinner or heavier reads as a different app.
- **Default size:** `15px`. Small inline (e.g. tab close) drop to `13`.
- **Layout:** `flex: none` so icons never stretch, `aria-hidden` (decorative —
  the adjacent text label carries meaning).
- **Color:** inherits `currentColor`. Tint by setting text color on the parent
  (`.soft-orange`, `.cell-*`, active states), never a hard-coded fill.

## The component

Both apps wrap lucide in one tiny component with a **named registry** — code
references a stable string name, not the lucide import. This keeps call sites
readable and lets any app swap the underlying glyph without touching callers.

```tsx
import { Activity, Braces, /* … */, X, type LucideIcon } from "lucide-react";

const ICONS = {
  activity: Activity,
  braces: Braces,
  x: X,
  // …
} satisfies Record<string, LucideIcon>;

export type IconName = keyof typeof ICONS;

export function Icon({ name, size = 15, style, className }: {
  name: IconName; size?: number; style?: CSSProperties; className?: string;
}) {
  const C = ICONS[name];
  return <C size={size} strokeWidth={1.8} style={{ flex: "none", ...style }}
            className={className} aria-hidden />;
}
```

Usage: `<Icon name="send" />`, `<Icon name="x" size={13} />`,
`<Icon name="save" className="soft-orange" />`.

## Shared core names

Present in every app — keep these stable so muscle memory and code carry over:

| name | lucide | name | lucide |
|------|--------|------|--------|
| `activity` | Activity | `history` | History |
| `braces` | Braces | `keyboard` | Keyboard |
| `check` | Check | `minify` | Minimize2 |
| `code` | Code2 | `moon` | Moon |
| `copy` | Copy | `more-horizontal` | MoreHorizontal |
| `database` | Database | `panel-left` | PanelLeft |
| `github` | GitBranch | `panel-right` | PanelRight |
| `pencil` | Pencil | `refresh` | RefreshCw |
| `plug` | Plug | `rows` | Rows3 |
| `plus` | Plus | `save` | Save |
| `search` | Search | `settings` | Settings2 |
| `sparkles` | Sparkles | `sun` | Sun |
| `trash` | Trash2 | `wand` | Wand2 |
| `x` | X | | |

Conventions worth reusing: `moon`/`sun` = theme toggle, `panel-left`/
`panel-right` = sidebar/inspector toggles, `sparkles`/`wand` = AI actions,
`github` = GitBranch (sync), `braces`/`code` = JSON/query, `refresh` = reload.

## App-specific names (extend per domain)

Each app adds domain glyphs on top of the core, same pattern:

- **requests_min** — `send` (Send), `request` (FileCode2), `globe` (Globe),
  `grpc` (Boxes), `ws` (Radio), `key` (Key), `folder` (FolderOpen),
  `list` (List), `chevron-down` (ChevronDown).
- **elatic_min** — `query` (FileCode2), `quick-query` (SearchCheck),
  `indexes`/`database` (Database), `mapping` (Braces), `table` (Table2),
  `docs` (Files), `cluster` (Activity), `filter` (Filter), `play` (Play),
  `zap` (Zap), `download` (Download), `status` (CircleDot),
  `arrow-left/right` (Chevron), `chevrons-left/right` (Chevrons).

**To add an icon:** pick the closest lucide glyph, add one `name: Glyph` line to
the registry, import it. Reuse a core name if one fits before minting a new one.

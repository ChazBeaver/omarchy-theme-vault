# Theme vault agent instructions

This private repository owns editable theme sources under `themes/<slug>/`.
Hyprdots owns their installed checkouts, pins, and lifecycle commands.
`README.md` describes this vault's layout and manual examples.

For installation, publication, pinning, renaming, or removal, read the existing
[Hyprdots theme workflow](../hyprdots/.agents/skills/hyprdots-themes/SKILL.md).
Edit this working vault rather than Hyprdots' managed source checkout. Vault
edits alone do not update installed themes or the Hyprdots lock.

Before changing a theme, read its own README when present. For wallpaper
changes or publication, also read its `WALLPAPERS.md`, `UPSTREAM.md`, and
licenses when present; preserve attribution and recorded distribution limits.

For documentation-only changes, check links, the relative `CLAUDE.md` symlink,
and `git diff --check`. This repository has no root installer or doctor.
For Matrix code changes, read its README and run
`python3 -B themes/matrix/tests/test_theme.py`. Follow the Hyprdots workflow's
verification for changes to installed themes; keep visual activation separate
from source edits.

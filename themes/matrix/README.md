# Matrix

A privately maintained snapshot of the installed theme.
See [UPSTREAM.md](UPSTREAM.md) for its source, revision, and preserved
author documentation. Palettes, backgrounds, previews, and appearance
overrides are stored here so restoration uses this vault.

To edit this copy, change these files, commit and push the vault, then run
`./themes.sh update matrix` from hyprdots and select the theme again.

See the [vault workflow](../../README.md#edit-publish-and-apply) for the full
edit, review, publish, pin, and apply sequence.

## Manual tools

Run these examples from `~/Projects/home/omarchy-theme-vault`. The tools are
optional and are not installed on PATH or run by selecting the theme.

### Greeting

```bash
sh themes/matrix/scripts/matrix-greeting
NO_COLOR=1 sh themes/matrix/scripts/matrix-greeting
```

Prints a two-line greeting; colors are used only on a suitable terminal
without `NO_COLOR`. It accepts no options and changes no settings.

### Optional terminal session

Requires Python 3.11+ and the chosen terminal (`ghostty` or `foot`), plus
JetBrainsMono Nerd Font for the intended typography. The session uses this
theme's palette and a process-local Starship config; it does not edit your
terminal or shell configuration. Use in a graphical session:

```bash
python3 themes/matrix/scripts/matrix-terminal --help
python3 themes/matrix/scripts/matrix-terminal --check
python3 themes/matrix/scripts/matrix-terminal --terminal foot --check
python3 themes/matrix/scripts/matrix-terminal
python3 themes/matrix/scripts/matrix-terminal --terminal foot --font-size 12
python3 themes/matrix/scripts/matrix-terminal --phosphor --font-size 13
python3 themes/matrix/scripts/matrix-terminal -- nvim README.md
```

Each launch opens a separate session; choose one. `--check` validates the
chosen terminal's config without opening a window, but still requires that
terminal installed. Font size must be 6–48. `--phosphor` adds the static glow
shader and is supported only by Ghostty. Everything after `--` becomes the
command in the new terminal, preserving argument boundaries.

### Wallpaper renderer

Requires Python 3.11+, Pycairo, PyGObject, Pillow, Pango/PangoCairo and a font
with the required glyphs (default: Noto Sans CJK JP). On Omarchy, install the
renderer dependencies with:

```bash
omarchy pkg add python-cairo python-gobject python-pillow pango noto-fonts-cjk
```

Render into a new temporary output directory to review files before copying
them into the theme. The positional output is a **directory**, not a filename:

```bash
python3 themes/matrix/scripts/render_rain.py --help
rain_output=$(mktemp -d)
python3 themes/matrix/scripts/render_rain.py "$rain_output" --width 1920 --height 1080 --seed 1999 --palette both --format png
ls -l "$rain_output"
```

This writes `1-falling-code.png` and `2-mono-rain.png`. For a portrait export
with all appearance controls made explicit:

```bash
rain_portrait=$(mktemp -d)
python3 themes/matrix/scripts/render_rain.py "$rain_portrait" \
  --width 1080 --height 1920 --seed 2000 --cell 24 --density 0.70 \
  --quiet 0.35 --scanlines 0.05 --bloom 0.20 \
  --font 'Noto Sans CJK JP' --palette mono --format jpg
```

Palette choices are `matrix`, `mono`, or `both`; formats are `jpg` or `png`.
Width/height must be 64–16384 with at most 40 million pixels; cell size is
8–128; density, quiet, scanlines, and bloom are 0–1. The seed makes output
repeatable. With no arguments, the renderer writes both 3840×2160 JPEGs
directly into `themes/matrix/backgrounds`, replacing matching filenames.
Use that form only when intentionally regenerating the shipped assets.

### Tests

```bash
python3 -B themes/matrix/tests/test_theme.py
```

The unittest suite checks glyph clipping, deterministic exports, wallpaper
validity, palette contrast, shell sections, and launcher arguments. It uses
temporary outputs and stub terminals. Install `glslang` if you want its shader
compilation check; otherwise that check is skipped. After changing appearance,
also select Matrix through Omarchy and inspect it visually.

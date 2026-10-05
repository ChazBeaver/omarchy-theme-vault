# Omarchy Theme Vault

Private incubation repository for personal Omarchy themes. Hyprdots pins this
repository to an exact commit and exposes selected theme directories under
`~/.config/omarchy/themes/`.

Hand-made themes store `colors.toml`, icon selection, backgrounds, and
documentation. Preserved upstream themes also retain previews and appearance
overrides, original licenses, and source attribution in `UPSTREAM.md`.
Upstream files that Omarchy did not load from community clones are archived
under each theme's `upstream/` directory for reference. Omarchy generates the
active terminal and editor configurations from `colors.toml`.

## Manual setup and restoration

This repo has no root installer or doctor. Git stores the editable source;
[Hyprdots](../hyprdots/MANUAL.md#themes) installs the exact revision in its
lockfile. Use Omarchy Quattro on Linux for applying themes. You also need
Git access to this private vault (including HTTPS/SSH authentication as
required by Hyprdots' recorded remote).

If the working clone does not exist yet:

```bash
mkdir -p ~/Projects/home
git clone git@github.com:ChazBeaver/omarchy-theme-vault.git ~/Projects/home/omarchy-theme-vault
```

Restore the currently pinned themes and select one:

```bash
cd ~/Projects/home/hyprdots
./sync.sh
./themes.sh status
./doctor.sh
omarchy theme switcher --preload
omarchy theme set coastal-village
omarchy theme bg next              # cycle its backgrounds
```

Sync installs a separate managed checkout under
`~/.local/share/hyprdots/theme-sources/personal-drafts` and links its selected
theme directories into `~/.config/omarchy/themes`. Edit this working repo,
not that managed checkout. A Git pull in this repo alone does not change
the installed themes.

## Edit, publish, and apply

The following example intentionally commits and pushes a change to the
private vault. Start with a clean checkout, edit the named theme, and review
the files before publishing. Substitute your editor for `nvim` if needed.

```bash
cd ~/Projects/home/omarchy-theme-vault
git status --short
git pull --ff-only
nvim themes/coastal-village/colors.toml
# If replacing images, also update the corresponding WALLPAPERS.md.
git diff --check
git diff -- themes/coastal-village
git add themes/coastal-village
git diff --cached --stat
git commit -m "feat(theme): refine coastal village palette"
git push
```

Publish to the source's default branch: `themes.sh update` follows that
branch, not an arbitrary working branch. Then adopt the published revision:

```bash
cd ~/Projects/home/hyprdots
./themes.sh update coastal-village
git diff -- config/themes.lock.tsv
# Run the source diff command printed by update to inspect the new revision.
./doctor.sh
omarchy theme switcher --preload
omarchy theme set coastal-village
git add config/themes.lock.tsv
git commit -m "chore(themes): update personal vault pin"
git push
```

Updating one theme moves every Hyprdots pin sharing `personal-drafts` to
the new vault commit. Applying the theme is a separate step. Keep custom
terminal/editor source overrides separate from Omarchy's generated active
files. `icons.theme` chooses the icon theme; backgrounds and source/rights
records live beside the palette.

## New hand-made theme

Choose a new slug that is absent from both the installed themes and the
vault. Create it outside the managed checkout; this example starts with the
stock Catppuccin palette and backgrounds:

```bash
mkdir ~/.config/omarchy/themes/my-dusk
cp /usr/share/omarchy/themes/catppuccin/colors.toml ~/.config/omarchy/themes/my-dusk/
cp -r /usr/share/omarchy/themes/catppuccin/backgrounds ~/.config/omarchy/themes/my-dusk/
nvim ~/.config/omarchy/themes/my-dusk/colors.toml
HYPRDOTS_THEME_AUTOPIN=0 omarchy theme set my-dusk
```

Check the appearance, then persist it with Hyprdots. **`draft` creates a
commit and pushes the private vault automatically**; it requires a clean,
up-to-date working clone and an existing `personal-drafts` lock entry:

```bash
cd ~/Projects/home/hyprdots
./themes.sh draft my-dusk
./themes.sh status
./doctor.sh
```

The draft command copies `colors.toml`, optional `icons.theme`, and background
files, and scaffolds README/WALLPAPERS records. It does not copy arbitrary
scripts or appearance overrides. Preserve any extra files deliberately in
the vault, review wallpaper attribution/rights, publish those edits using
the workflow above, then update the pin. Commit the resulting Hyprdots lock
to retain the installation decision. `draft` has no dry-run mode.

## Rename a theme

For example, after creating `my-dusk`, rename it to `evening-lab` in a clean
vault checkout, update this README's layout and the theme's own docs, and
publish that rename:

```bash
cd ~/Projects/home/omarchy-theme-vault
git pull --ff-only
git mv themes/my-dusk themes/evening-lab
nvim README.md themes/evening-lab/README.md
git add README.md themes/evening-lab
git diff --cached --stat
git commit -m "chore(theme): rename my dusk to evening lab"
git push

cd ~/Projects/home/hyprdots
./themes.sh rename my-dusk evening-lab
./doctor.sh
omarchy theme switcher --preload
omarchy theme set evening-lab
git diff -- config/themes.lock.tsv
git add config/themes.lock.tsv
git commit -m "chore(themes): adopt evening lab rename"
git push
```

To choose a specific already-published revision, obtain its full hash with
`git rev-parse HEAD` in the vault, then use
`./themes.sh rename my-dusk evening-lab FULL_COMMIT_HASH` in Hyprdots,
substituting that hash. Use `rename` while the old slug is still pinned;
`update` cannot repair a missing old directory after a rename.

## Retire or recover a theme

Stop managing an installed theme with
`./themes.sh unpin evening-lab` from Hyprdots; it leaves an unmanaged copy.
Select another theme and use `omarchy theme remove evening-lab` if you also
want the installed copy removed. If deleting its source from the vault,
unpin it on managed machines before publishing the deletion; otherwise their
next source update will refer to a missing directory.

For an unwanted **published** palette change, revert its commit in the vault
(substitute the actual commit ID), publish the correction, then update the
Hyprdots pin and select the theme again:

```bash
cd ~/Projects/home/omarchy-theme-vault
git log --oneline -- themes/coastal-village
git revert COMMIT_TO_REVERT
git push
cd ~/Projects/home/hyprdots
./themes.sh update coastal-village
./doctor.sh
omarchy theme set coastal-village
```

Review and commit the corrected lock as in the update workflow. To inspect
older files without changing installed state, use
`git show COMMIT_ID:themes/coastal-village/colors.toml` in the vault.

## Included tools and verification

Most theme files are data loaded by Omarchy, not commands. The only included
standalone tools and tests are under Matrix; see the
[Matrix command examples](themes/matrix/README.md#manual-tools) for the
greeting, optional terminal launcher, wallpaper renderer, and tests.

From this repo, run the included suite when changing Matrix:

```bash
python3 -B themes/matrix/tests/test_theme.py
git diff --check
```

The suite needs the renderer dependencies listed in Matrix's README. Other
themes have no automated visual test suite: run Hyprdots doctor and manually
select the edited theme to check terminal colors, editor colors, shell, lock
appearance, and backgrounds. Check `WALLPAPERS.md`, `UPSTREAM.md`, and licenses
before extracting any theme into a public repository.

## Layout

- `themes/coastal-village` — Mediterranean village palette and three coastal backgrounds.
- `themes/sunken-ship` — submerged teal palette and two aquatic backgrounds.
- `themes/afternoon-peaceful-park` — plum and amber palette and one park background.
- `themes/alpine-lake` — pine-green and glacial-blue palette and two mountain-lake backgrounds.
- `themes/i-want-to-believe` — desaturated near-black palette and one UFO hill background.
- `themes/purple-jellyfish` — near-black palette with coral and periwinkle and one jellyfish background.
- `themes/murkwood` — Murkwood.
- `themes/campfire` — Campfire.
- `themes/dark-lotus` — Dark lotus.
- `themes/golden-forest` — Golden forest.
- `themes/blue-sky` — Sky-blue palette and five blue-sky backgrounds.
- `themes/jungle-lab` — Jungle lab.
- `themes/purple-dusk` — Indigo and lavender palette and two dusk backgrounds.
- `themes/redshift` — Redshift.
- `themes/soot` — Soot.
- `themes/stormwave` — Stormwave.
- `themes/football` — Football.
- `themes/nebraska` — Nebraska.
- `themes/bolts` — Bolts.
- `themes/starsend` — Starsend (preserved personal copy).
- `themes/sakura-mochi` — Sakura Mochi (preserved personal copy).
- `themes/matrix` — Matrix (preserved personal copy).
- `themes/mars` — Mars (preserved personal copy).
- `themes/aura` — Aura (preserved personal copy).
- `themes/ethereal-personal` — Ethereal Personal (preserved personal copy).

Wallpaper files remain private until their redistribution rights are verified.
See each theme's `WALLPAPERS.md` before publishing or extracting a public theme.

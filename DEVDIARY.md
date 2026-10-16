# DEVDIARY — DockDoor (pl-coder fork)

Self-built fork of [ejbills/DockDoor](https://github.com/ejbills/DockDoor) (GPL-3.0)
so Dock window previews run from source we've read, not a stranger's binary.
Upstream is `upstream`; our patches live on branch `plcoder`. Rebuild with `./build-local.sh`.

## 2026-10-16 — forked, audited, built

- Lit review: DockDoor does exactly the brief (hover Dock icon → window previews).
  Chose adopt-and-self-build over writing our own.
- Pinned to upstream tag `1.41.0`.
- Audit of outbound network in `DockDoor/`:
  - Sparkle auto-updater → `dockdoor.kepler.cafe/appcast.xml`. **Removed**: it would
    replace our build with upstream's signed binary. Updater never started, feed URL
    deleted from Info.plist, background check removed.
  - Media widget artwork: sends track/artist to `itunes.apple.com/search` when a
    music app's preview shows. Left as-is (Apple endpoint); kill it if wanted.
  - Lyrics (`lyrics.ovh`, `lrclib.net`): only when you ask for lyrics. Left as-is.
  - Everything else is links you click (donate, GitHub, Discord) — no telemetry.
- Signed with our Apple Development team, bundle id `com.plcoder.DockDoor`.

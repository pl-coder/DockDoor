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
- Build traps hit (all now baked into `build-local.sh`):
  - Upstream's "Run Script" phase builds SwiftFormat and rewrites every source file
    on each build. Patched to exit early when `PLCODER_SKIP_FORMAT=1`.
  - `-allowProvisioningUpdates` / automatic signing hung on Apple's servers. Manual
    signing with the Apple Development cert needs no profile for these entitlements.
  - SPM hung at "Resolve Package Graph" on a keychain lookup while fetching Sparkle's
    binary zip. Fixed with `-packageAuthorizationProvider netrc` (no ~/.netrc exists),
    plus `-skipPackageUpdates -disableAutomaticPackageResolution` so branch-pinned
    deps don't re-hit GitHub every build.
  - App reports version 1.18.3: upstream's stale MARKETING_VERSION; CI sets the real
    one. Code is 1.41.0.
- Installed to /Applications, running. Hover test pending Peter granting
  Accessibility + Screen Recording (can't be granted or read from the shell).

## 2026-10-17 — verified on screen

- Mac rebooted 13:04; DockDoor did not come back — it is **not a login item** yet
  (the in-app "Launch DockDoor at login" toggle is off). Relaunched by hand.
- Hover test passed: Finder icon → panel with live thumbnails of both open windows
  (Downloads, personal); Terminal icon → its one window, correctly badged "Hidden".
- Testing gotcha: the computer-use screenshot tool filters out DockDoor's panel (not
  on its allowlist). Verified instead by polling CGWindowList for DockDoor's layer-25
  window and `screencapture -l <id>` on it.

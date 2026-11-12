# Cloud-Mac build for the Grok Bot Widget (no Mac of your own)

This folder now contains everything needed to compile the app on a **cloud
Mac** (GitHub Actions, macOS runner, Xcode preinstalled):

- `.github/workflows/ios-build.yml` — the workflow (3 jobs, see below)
- The Xcode project itself (`GrokBotWidgetApp.xcodeproj`, app + widget targets)

## What the workflow does — and what it does NOT do

| Job | Needs | Produces | Can it go on a real iPhone? |
|---|---|---|---|
| `simulator-build` | Nothing (no Apple account, no secrets) | Unsigned Simulator `.app` | **No** — Simulator only, needs a Mac to run |
| `unsigned-ipa` | Nothing | Unsigned `.ipa` | **No** — cannot install on a stock iPhone |
| `signed-archive` | Apple secrets (see below) | Signed `.ipa` (development) | **Yes**, if signing + App Group are set up |

The honest limit: **no cloud build can install an app on your iPhone
without Apple signing.** An unsigned build proves the code compiles, but
Apple will not let a stock iPhone run it. Installing on a real iPhone
needs one of:
- a **free Apple ID** signed in to Xcode (Personal Team) — build expires
  after **7 days**, and **App Groups usually do NOT work** on a free team
  (this widget shares its state through App Group
  `group.com.grokbot.widget`, so taps may not stick); or
- the **paid Apple Developer Program ($99/year)** — App Groups work,
  TestFlight/App Store distribution works.

## How to run it (the only step that needs a login)

1. Create a GitHub repository — public repos get **free, unlimited**
   standard macOS runner minutes; private repos draw on the free plan's
   2,000 min/month (macOS minutes are billed at a higher rate).
   Create one at: https://github.com/new
2. Push this whole `grok-bot-app` folder (including the hidden `.github`
   folder) to that repo's `main` branch.
3. On GitHub, open the repo → **Actions** tab → **iOS Build (Cloud Mac)**
   → the run starts automatically on push; or **Run workflow** to start it
   manually.
4. When it finishes, download the artifacts from the run page:
   `GrokBotWidgetApp-simulator` and/or `GrokBotWidgetApp-unsigned-ipa`.

## Optional: signed build for a real iPhone

1. Enroll in the Apple Developer Program ($99/year):
   https://developer.apple.com/programs/
2. In Xcode (or at developer.apple.com → Certificates, Identifiers &
   Profiles), create the App Group **`group.com.grokbot.widget`** under
   your team, and make sure both bundle IDs use it:
   `com.grokbot.widget` and `com.grokbot.widget.GrokBotWidgetExtension`.
3. In the GitHub repo, add these Actions secrets
   (Settings → Secrets and variables → Actions):
   - `APPLE_TEAM_ID` — your Team ID
   - `APPLE_ID` — your Apple ID email
   - `APPLE_APP_SPECIFIC_PASSWORD` — an app-specific password
     (appleid.apple.com → Sign-In and Security → App-Specific Passwords)
4. Re-run the workflow. The `signed-archive` job will now run and upload
   `GrokBotWidgetApp-signed-ipa`, which can be installed on your iPhone
   (e.g. via Apple Configurator / Xcode Devices window, or TestFlight).

## What was already checked on this Linux machine (no Xcode here)

- All 16 files referenced in `project.pbxproj` exist; braces/parens
  balanced in the project file (63/63, 31/31) and in all 6 Swift files.
- All 4 plist/entitlement files parse as valid XML plists.
- App Group `group.com.grokbot.widget` matches in both entitlements
  files and in `SharedState.swift`; bundle IDs are consistent.
- All cross-file symbols resolve (`SharedState.*`, `ToggleFaceIntent`,
  `ToggleTaskIntent`, `GrokBotEntry`, `GrokBotWidgetView`,
  `WidgetCenter.shared.reloadAllTimelines`).
- The project ships **no shared .xcscheme**, so the workflow builds with
  `-target GrokBotWidgetApp` (which also builds the embedded widget
  extension) instead of `-scheme`.
- **Not** verified here: an actual `xcodebuild` compile — there is no
  macOS/Xcode on this machine, and SwiftUI/WidgetKit/AppIntents only
  exist on macOS. The first real compile happens on the cloud runner.

## Other cloud-Mac options (all need an account — none is anonymous)

- **Codemagic** (codemagic.io): 500 free macOS minutes/month on personal
  accounts; sign up with a GitHub account; needs Apple signing for device
  installs. No anonymous builds.
- **Bitrise / Appcircle / MacinCloud / Xcode Cloud**: all require an
  account (and, for device installs, Apple signing). Xcode Cloud also
  needs a Mac at least once to set up.
- **Tailscale**: this machine is **not connected** to the user's tailnet
  (`/opt/hatch/bin/tailscale status` → `Not connected`), and joining
  needs the user's approval — so no Mac on the tailnet could be reached
  from here without them.

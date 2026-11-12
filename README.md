# Grok Bot Widget — native iOS app + interactive WidgetKit widget

A real, native iOS app (SwiftUI + WidgetKit, iOS 17+) that puts a Grok Bot
widget on the home screen. **No Scriptable, no WebView, no web link.**

## What the widget looks like (small size)

Black rounded square, matching the reference image:

- Top text: **Account Manager**
- Large round gradient face: white (top) → light blue (bottom)
- Two black vertical oval eyes
- Small blue circle with three black dots at the top-left of the face
- Three task rows below:
  - `Copy final out...`
  - `Start working...`
  - `Prep workspace` — with **Prep** in blue
- Progress line: `0/3 done`

## Interacting ON the home screen (no app opens)

This uses iOS 17 interactive widgets (`Button(intent:)` + AppIntents):

1. **Tap the face** — toggles expression: eyes open → happy closed eyes,
   and the speech text changes from “Tap me!” to “Got it! On it.”
2. **Tap a task row** — cycles that task: todo → doing → done (✓),
   and the `0/3 done` progress updates.
3. **State persists** in a shared App Group (`UserDefaults(suiteName:)`),
   so the app and the widget always agree.

## Project layout

```
GrokBotWidgetApp.xcodeproj/          Xcode project (open this)
GrokBotWidgetApp/                    Host app target
  GrokBotWidgetApp.swift           @main app entry
  ContentView.swift                Preview + how-to-add instructions
  Info.plist
  GrokBotWidgetApp.entitlements    App Group entitlement
  Assets.xcassets/                 App icon (generated placeholder)
GrokBotWidgetExtension/             Widget extension target
  GrokBotWidgetExtension.swift    WidgetBundle, TimelineProvider, Entry, Widget
  GrokBotWidgetView.swift         Widget UI (face, tasks, progress)
  Intents.swift                   ToggleFaceIntent, ToggleTaskIntent (AppIntents)
  Info.plist
  GrokBotWidgetExtension.entitlements
  Assets.xcassets/
SharedState.swift                  Shared App Group state — included in BOTH targets
```

Bundle IDs (change the `com.grokbot` prefix to your own if you prefer,
but keep both targets consistent):

- App: `com.grokbot.widget`
- Widget extension: `com.grokbot.widget.GrokBotWidgetExtension`
- App Group: **`group.com.grokbot.widget`** (must match exactly in both
  entitlements files and in `SharedState.appGroupID`)

## Build steps (exact)

You need a Mac with Xcode 15+ and an iPhone running iOS 17+.

1. Copy this whole `grok-bot-app` folder to your Mac.
2. Open `GrokBotWidgetApp.xcodeproj` in Xcode.
3. Select the **GrokBotWidgetApp** target → **Signing & Capabilities**:
   - Tick **Automatically manage signing**.
   - Choose your Apple ID team.
   - Make sure **App Groups** is listed and
     `group.com.grokbot.widget` is ticked.
     If it is not there, click **+ Capability → App Groups** and add
     `group.com.grokbot.widget`.
4. Do the same for the **GrokBotWidgetExtension** target:
   same team, same App Group `group.com.grokbot.widget` ticked.
   (If the group is not ticked in both targets, the widget and the app
   cannot share state and taps will not stick.)
5. Select your iPhone as the run destination (top bar, next to the Run ▶ button).
   If Xcode asks, trust the developer certificate on the iPhone under
   Settings → General → VPN & Device Management.
6. Press **Run ▶** (or Product → Run). The host app installs and opens.
7. Add the widget:
   - Long-press an empty spot on the home screen → tap **+** (top left).
   - Search **Grok Bot**.
   - Choose the **small** widget → tap **Add Widget** → tap **Done**.
8. Interact on the home screen: tap the face, tap each task row.
   Nothing should open — the face and the checkmarks change in place.

## If something goes wrong

| Symptom | Fix |
|---|---|
| Xcode: “No such module” / signing error | Select a team in Signing & Capabilities for both targets. |
| Widget shows placeholder / taps do nothing | App Group `group.com.grokbot.widget` is not enabled in **both** targets, or the group does not exist under your team — add it in Signing & Capabilities. |
| Widget does not appear in the + menu | Run the app once from Xcode first (the extension is embedded in the app), then try again. |
| Face/tasks reset | The App Group defaults are per-group; reinstalling the app clears them. |

## Notes / limits (honest)

- iOS widgets are not continuously animated: the face does not blink or
  move on its own on the home screen. Taps are interactive in place
  (iOS 17 AppIntents), which is the most interaction Apple allows.
- No external dependencies, no network, no account. All state stays
  on the device in the App Group.
- This project was assembled and structurally validated on Linux
  (all files present, `project.pbxproj` braces balanced, every referenced
  file exists). It was **not** compiled here — there is no Xcode / macOS
  on this machine — so the first real compile must be done in Xcode
  on a Mac, as above.

# GreetingsAI — local testing notes

This repository contains a SwiftUI app (iOS/macOS) that requires Xcode on macOS to run in Simulator.

Quick options to test the code:

- Run in Xcode (recommended):
  1. Open Xcode and create a new iOS or macOS App project.
  2. Add the `.swift` source files from this repository into the new project (drag into Project navigator).
  3. Select a Simulator and press Run.

- Build non-UI modules with SwiftPM (macOS/Linux with Swift installed):
  - This repo includes `Package.swift` exposing `Models`, `Services`, and `ViewModels` targets pointing at the corresponding folders.
  - Build locally on macOS or Linux with Swift installed:

```bash
swift build
swift test
````markdown
# GreetingsAI — local testing notes

This repository contains a SwiftUI app (iOS/macOS) that requires Xcode on macOS to run in Simulator.

[![CI](https://github.com/USERNAME/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/USERNAME/REPO/actions/workflows/ci.yml)

Replace `OWNER/REPO` in the badge URL above with your GitHub username and repository name to enable the badge.

Quick options to test the code:

- Run in Xcode (recommended):
  1. Open Xcode and create a new iOS or macOS App project.
  2. Add the `.swift` source files from this repository into the new project (drag into Project navigator).
  3. Select a Simulator and press Run.

- Build non-UI modules with SwiftPM (macOS/Linux with Swift installed):
  - This repo includes `Package.swift` exposing `Models`, `Services`, and `ViewModels` targets pointing at the corresponding folders.
  - Build locally on macOS or Linux with Swift installed:

```bash
swift build
swift test
```

- CI: A GitHub Actions workflow (`.github/workflows/ci.yml`) is provided that runs on `macos-latest` and executes `swift build` and `swift test`.

Notes:
- The app's UI uses SwiftUI/UIKit and must be run in Xcode on macOS or a macOS CI runner using `xcodebuild` (no `.xcodeproj` is included here).
- If you want I can scaffold an Xcode project (`.xcodeproj`) and wire the files into it so the app can be run directly from Xcode.

````


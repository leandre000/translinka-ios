## Regenerate a clean Xcode project file

If Xcode says the project is damaged or missing build configurations after cloning:

1) Make sure you have Python 3 installed on macOS.
2) From the repo root, run:
   ```bash
   python3 scripts/generate_xcodeproj.py
   ```
3) Open `TransLinka.xcodeproj` in Xcode, select a simulator, and run (Cmd+R).

What the script does
- Scans all `.swift` files under `TransLinka/`.
- Rewrites `TransLinka.xcodeproj/project.pbxproj` with a single app target named `TransLinka`.
- Sets:
  - iOS deployment target: 15.0
  - Bundle ID: `com.translinka.app`
  - Info.plist: `TransLinka/Info.plist`
  - Swift version: 5.0
  - App Icon placeholder: `AppIcon` (you can add assets later)

Notes
- No external dependencies are required; blockchain/maps are stubbed.
- If you change or add files later, rerun the script to refresh the project file.


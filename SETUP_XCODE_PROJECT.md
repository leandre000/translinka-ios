# Setting Up Xcode Project

## Option 1: Create New Project in Xcode (Recommended)

1. Open Xcode
2. File → New → Project
3. Select "iOS" → "App"
4. Product Name: `TransLinka`
5. Interface: `SwiftUI`
6. Language: `Swift`
7. Click "Next" and choose location
8. Once created, add all files from the `TransLinka/` directory to the project

## Option 2: Use Swift Package Manager

The project includes a `Package.swift` file for Swift Package Manager support.

```bash
swift package generate-xcodeproj
```

## Required Frameworks

Add these frameworks in Xcode:

- **ARKit** - For AR navigation
- **RealityKit** - For 3D AR content
- **CoreNFC** - For NFC ticket validation
- **CoreImage** - For QR code generation
- **AVFoundation** - For camera access

## Capabilities to Enable

1. **NFC Tag Reading** - In Signing & Capabilities
2. **Camera Usage** - Add to Info.plist
3. **ARKit** - Automatically enabled with ARKit framework

## Info.plist Entries

Already configured in `TransLinka/Info.plist`:
- `NFCReaderUsageDescription`
- `NSCameraUsageDescription`

## Build Settings

- **iOS Deployment Target**: 15.0+
- **Swift Version**: 5.7+
- **SwiftUI**: Enabled

## Dependencies (Optional)

For blockchain integration, add via Swift Package Manager:

- Web3.swift (Ethereum)
- Solana Swift SDK

## Project Structure

```
TransLinka/
├── Models/
├── Views/
├── ViewModels/
├── Services/
├── Utilities/
└── TransLinkaApp.swift
```


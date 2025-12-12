# TransLinka - Swift iOS Mobile App

A comprehensive bus ticketing and travel system built with SwiftUI, featuring blockchain-backed ticketing, AR navigation, QR/NFC validation, and AI chatbot support.

## Features

### User Features
- **Authentication**: Secure sign up, sign in with email/password or Google
- **Route Search**: Search and filter bus routes by origin, destination, and date
- **Seat Selection**: Interactive seat map for choosing preferred seats
- **Booking Management**: View and manage all bookings with QR codes
- **Ticket Validation**: QR code and NFC support for contactless validation
- **AR Navigation**: Augmented reality guidance to boarding gates
- **AI Chatbot**: 24/7 AI-powered customer support
- **Profile Management**: User profile, payment methods, and settings

### Admin Features
- **Dashboard**: Analytics with total bookings, users, routes, and revenue
- **Route Management**: Add, edit, and delete bus routes
- **Bus Management**: Manage bus fleet with status tracking
- **Booking Management**: View and manage all customer bookings

## Technology Stack

- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **Core Data / UserDefaults**: Local data persistence
- **CoreImage**: QR code generation
- **CoreNFC**: NFC ticket validation
- **ARKit**: Augmented reality navigation
- **Blockchain Integration**: Secure ticket transactions

## Project Structure

```
TransLinka/
├── Models/              # Data models
├── Views/              # SwiftUI views
│   ├── Authentication/
│   ├── Main/
│   ├── Booking/
│   ├── Tickets/
│   ├── Profile/
│   ├── Chat/
│   └── Admin/
├── ViewModels/          # View models for MVVM
├── Services/            # Business logic services
├── Utilities/           # Theme, animations, helpers
└── TransLinkaApp.swift  # App entry point
```

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

1. Clone the repository
2. Open `TransLinka.xcodeproj` in Xcode
3. Build and run on simulator or device

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures (User, Route, Booking, Bus, etc.)
- **Views**: SwiftUI views for UI presentation
- **ViewModels**: Business logic and state management
- **Services**: API calls, data persistence, blockchain integration

## Key Features Implementation

### Blockchain Integration
- Simulated blockchain hash generation for ticket security
- Ready for integration with Ethereum, Solana, or other blockchains

### QR Code Generation
- CoreImage-based QR code generation
- Unique ticket identifiers

### NFC Support
- CoreNFC framework integration
- Contactless ticket validation

### AR Navigation
- ARKit integration for terminal navigation
- Placeholder for full AR implementation

### AI Chatbot
- Keyword-based response system
- Ready for ML/AI integration

## Contributing

This is a professional project built for a global competition. All code follows Swift best practices and iOS design guidelines.

## License

Copyright © 2024 TransLinka. All rights reserved.


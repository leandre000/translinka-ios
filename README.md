# TransLinka - Swift iOS Mobile App

A comprehensive, intelligent bus ticketing and travel system built with SwiftUI, featuring blockchain-backed ticketing, AR navigation, QR/NFC validation, real-time Google Maps integration, and AI chatbot support. Specifically designed for Rwandan transport infrastructure.

## 🌟 Features

### 🔐 Authentication & User Management
- **Secure Registration**: Email/password sign up with validation
- **Multiple Sign-In Options**: Email/password or Google Sign-In
- **Password Recovery**: Forgot password functionality
- **Biometric Authentication**: Face ID and Touch ID support
- **Session Management**: Secure user session handling
- **Profile Management**: Complete user profile with preferences

### 🗺️ Real-Time Google Maps Integration

#### Maps & Navigation
- **Interactive Map View**: Full Google Maps integration with custom markers
- **Real-Time Bus Tracking**: Live bus location updates with ETA calculations
- **Route Visualization**: Visual route display on map with origin/destination markers
- **Street View Images**: Access to street view for Rwandan roads and locations
- **Direction Services**: Turn-by-turn directions between locations
- **Location Services**: GPS tracking with permission handling

#### Rwandan Locations
- **Major Cities**: Kigali, Butare, Gisenyi, Ruhengeri, Byumba, Cyangugu, Kibungo, Kibuye
- **Bus Stops Database**: Comprehensive list of major bus stops including:
  - Nyabugogo Bus Station (Kigali)
  - Kacyiru Bus Stop (Kigali)
  - Remera Bus Stop (Kigali)
  - Kimisagara Bus Stop (Kigali)
  - Butare Bus Station
  - Gisenyi Bus Station
  - Ruhengeri Bus Station
- **Location Search**: Search for places and locations in Rwanda
- **Nearest Bus Stop Finder**: Automatic detection of closest bus stops
- **City Details**: Detailed information with photos for each city

#### How Maps Are Integrated
1. **Booking Flow**: When viewing route details, users can see the route on map
2. **Real-Time Tracking**: After booking, users can track their bus in real-time
3. **Bus Stop Discovery**: Interactive map showing all nearby bus stops
4. **Route Planning**: Visual route planning with distance and duration
5. **Navigation**: Direct integration with Apple Maps for turn-by-turn navigation
6. **Street View**: Preview locations before booking with street view images

### 🎫 Ticket Booking System

#### Complete Booking Flow
1. **Route Search**: Search by origin, destination, and date
2. **Route Details**: View comprehensive route information
3. **Map Visualization**: See route on interactive map
4. **Schedule Viewing**: Check available departure times
5. **Seat Selection**: Interactive seat map (2-3-2 configuration)
6. **Passenger Details**: Enter passenger information
7. **Payment Processing**: Multiple payment methods
8. **Booking Confirmation**: QR code generation and blockchain hash

#### Booking Features
- **Route Comparison**: Compare multiple routes side-by-side
- **Bus Schedules**: Today's and upcoming schedules
- **Seat Availability**: Real-time seat availability
- **Price Display**: Transparent pricing with currency formatting
- **Booking History**: Complete booking history with filters
- **Booking Modifications**: Change dates, seats, or cancel bookings

### 💳 Payment & Wallet System

#### Payment Methods
- **Credit/Debit Cards**: Secure card processing
- **PayPal**: PayPal integration
- **Google Pay**: Google Pay support
- **Apple Pay**: Native Apple Pay
- **Mobile Money**: Mobile money integration

#### Wallet Features
- **Payment Method Management**: Add, edit, delete payment methods
- **Default Payment**: Set default payment method
- **Transaction History**: Complete payment history
- **Refund System**: Request and track refunds
- **Loyalty Points**: Points accumulation system

### 🎫 Tickets & Validation

#### Ticket Features
- **QR Code Generation**: Unique QR codes for each ticket
- **NFC Validation**: Contactless ticket validation
- **Blockchain Hash**: Secure blockchain-backed tickets
- **Ticket Sharing**: Share tickets with others
- **Digital Wallet**: Store tickets in app
- **Offline Access**: View tickets without internet

#### Validation Methods
- **QR Code Scanning**: Scan at boarding gates
- **NFC Tap**: Tap phone for validation
- **Blockchain Verification**: Verify ticket authenticity
- **Real-Time Validation**: Instant validation status

### 🧭 AR Navigation

#### AR Features
- **ARKit Integration**: Full ARKit implementation
- **3D Markers**: 3D gate markers in AR space
- **Distance Tracking**: Real-time distance to gates
- **Direction Indicators**: Visual direction guidance
- **Coaching Overlay**: AR coaching for first-time users
- **Terminal Navigation**: Navigate to boarding gates using AR

### 🤖 AI Chatbot

#### Chatbot Features
- **24/7 Support**: Always available customer support
- **Natural Language Processing**: Understands user queries
- **Booking Assistance**: Help with booking process
- **FAQ Answers**: Quick answers to common questions
- **Multi-language Support**: Support for multiple languages
- **Context Awareness**: Remembers conversation context

### 👨‍💼 Admin Dashboard

#### Admin Features
- **Analytics Dashboard**: 
  - Total bookings
  - Total users
  - Total routes
  - Total revenue
- **Route Management**: Add, edit, delete routes
- **Bus Management**: Manage bus fleet
- **Booking Management**: View and manage all bookings
- **User Management**: User administration
- **Reports**: Generate various reports

### 🎨 UI/UX Features

#### Animations & Polish
- **Smooth Animations**: Spring animations throughout
- **Loading States**: Skeleton loaders and progress indicators
- **Empty States**: Helpful empty state messages
- **Error Handling**: User-friendly error messages
- **Haptic Feedback**: Tactile feedback for interactions
- **Dark Mode**: Full dark mode support
- **Accessibility**: VoiceOver and Dynamic Type support

#### Design System
- **Consistent Theme**: Unified color palette
- **Typography**: Clear typography hierarchy
- **Spacing**: Consistent spacing system
- **Icons**: SF Symbols throughout
- **Cards**: Elevated card designs
- **Shadows**: Subtle depth with shadows

## 🏗️ Architecture

### MVVM Pattern
- **Models**: Data structures (User, Route, Booking, Bus, etc.)
- **Views**: SwiftUI views for UI presentation
- **ViewModels**: Business logic and state management
- **Services**: API calls, data persistence, blockchain integration

### Project Structure
```
TransLinka/
├── Models/              # Data models
│   ├── User.swift
│   ├── Route.swift
│   ├── Booking.swift
│   ├── Bus.swift
│   └── PaymentMethod.swift
├── Views/               # SwiftUI views
│   ├── Authentication/  # Landing, SignUp, SignIn
│   ├── Main/           # Home, Bookings, Tickets, Profile
│   ├── Booking/        # Search, Details, Seat Selection, Payment
│   ├── Tickets/        # Ticket list and details
│   ├── Maps/           # Map views and tracking
│   ├── Profile/        # Profile, Settings, Payment Methods
│   ├── Chat/           # AI Chatbot
│   ├── AR/             # AR Navigation
│   └── Admin/          # Admin dashboard and management
├── ViewModels/          # View models for MVVM
│   ├── AuthenticationViewModel.swift
│   ├── BookingViewModel.swift
│   └── AdminViewModel.swift
├── Services/            # Business logic services
│   ├── AuthenticationService.swift
│   ├── BookingService.swift
│   ├── Blockchain/     # Ethereum, Solana services
│   ├── Maps/           # Google Maps service
│   └── Location/       # Location services
├── Utilities/           # Theme, animations, helpers
│   ├── Theme.swift
│   ├── Animations.swift
│   └── AdvancedAnimations.swift
└── TransLinkaApp.swift # App entry point
```

## 🔄 Complete App Flow

### 1. Landing & Authentication
```
Landing Screen
    ↓
[Sign Up] or [Sign In]
    ↓
Sign Up Flow:
    - Full Name
    - Email
    - Password
    - Confirm Password
    - Google Sign-In option
    ↓
Sign In Flow:
    - Email
    - Password
    - Forgot Password option
    - Google Sign-In option
    ↓
Authentication Success
    ↓
Main App (User/Admin)
```

### 2. Main Navigation (User)
```
Main Tab View
    ├── Home Tab
    │   ├── Welcome message
    │   ├── Route search
    │   ├── Recent bookings
    │   └── Quick actions (Map, AR, Chat, Routes)
    │
    ├── Bookings Tab
    │   ├── All bookings
    │   ├── Upcoming bookings
    │   └── Past bookings
    │
    ├── Tickets Tab
    │   ├── Active tickets
    │   ├── QR codes
    │   └── Ticket details
    │
    └── Profile Tab
        ├── User info
        ├── My Bookings
        ├── Payment Methods
        ├── Settings
        ├── Help Center
        └── Logout
```

### 3. Booking Flow
```
Home Screen
    ↓
Search Routes
    ├── Origin (e.g., Kigali)
    ├── Destination (e.g., Butare)
    └── Date
    ↓
Route Search Results
    ↓
Select Route
    ↓
Route Details View
    ├── Route information
    ├── [View on Map] → RouteMapView
    ├── [View Schedule] → BusScheduleView
    └── [Select Seats]
    ↓
Seat Selection
    ├── Interactive seat map
    ├── Select seats
    └── [Continue]
    ↓
Passenger Details
    ├── Full Name
    ├── Email
    ├── Phone Number
    └── Booking summary
    ↓
Payment
    ├── Select payment method
    ├── Enter payment details
    └── [Pay]
    ↓
Booking Confirmation
    ├── Success animation
    ├── QR code
    ├── Blockchain hash
    └── Booking details
```

### 4. Maps & Tracking Flow
```
Home → Quick Actions → Map & Bus Stops
    ↓
MapView
    ├── Interactive map
    ├── Bus stop markers
    ├── User location
    └── Bus stop details
    ↓
Select Bus Stop
    ↓
Bus Stop Card
    └── [Get Directions] → Apple Maps
    ↓
OR
    ↓
Home → Quick Actions → Rwandan Locations
    ↓
RwandanLocationsView
    ├── Major cities
    ├── Bus stops
    └── [View Street View]
    ↓
OR
    ↓
Route Details → [View on Map]
    ↓
RouteMapView
    ├── Route visualization
    ├── Origin marker
    └── Destination marker
    ↓
OR
    ↓
After Booking → [Track Bus]
    ↓
RealTimeTrackingView
    ├── Live bus location
    ├── ETA calculation
    ├── Next stop indicator
    └── Speed and heading
```

### 5. Wallet & Payment Flow
```
Profile → Payment Methods
    ↓
PaymentMethodsView
    ├── List of saved methods
    ├── [Add Payment Method]
    └── [Delete] methods
    ↓
Add Payment Method
    ├── Select type
    ├── Enter details
    └── [Save]
    ↓
OR
    ↓
During Booking → Payment
    ↓
PaymentView
    ├── Select payment method
    ├── Enter card details
    └── [Pay]
    ↓
Payment Processing
    ↓
Booking Confirmation
```

### 6. Logout Flow
```
Profile Tab
    ↓
Scroll to bottom
    ↓
[Logout] button
    ↓
Confirmation (optional)
    ↓
Sign out
    ↓
Landing Screen
```

## 🛠️ Technology Stack

- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **Core Location**: GPS and location services
- **MapKit**: Native iOS mapping
- **Google Maps API**: Directions, Places, Street View
- **ARKit**: Augmented reality navigation
- **CoreNFC**: NFC ticket validation
- **CoreImage**: QR code generation
- **UserDefaults/Core Data**: Local data persistence
- **Blockchain**: Ethereum and Solana integration ready
- **Async/Await**: Modern concurrency

## 📋 Requirements

- **iOS**: 15.0+
- **Xcode**: 14.0+
- **Swift**: 5.7+
- **Google Maps API Key**: Required for maps features
- **Camera Permission**: Required for AR navigation
- **Location Permission**: Required for maps and tracking
- **NFC Capability**: Required for NFC validation (iPhone 7+)

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/leandre000/translinka-ios.git
cd translinka-ios
```

### 2. Open in Xcode
```bash
open TransLinka.xcodeproj
```

### 3. Configure Google Maps API
1. Get Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable these APIs:
   - Maps SDK for iOS
   - Directions API
   - Places API
   - Street View Static API
3. Add API key to `GoogleMapsService.swift`:
```swift
private let apiKey = "YOUR_GOOGLE_MAPS_API_KEY"
```

### 4. Configure Capabilities
In Xcode, enable:
- **Maps**: For MapKit integration
- **Location Services**: For GPS tracking
- **NFC Tag Reading**: For ticket validation
- **Camera**: For AR navigation

### 5. Build and Run
- Select target device or simulator
- Press `Cmd + R` to build and run

## 🗺️ Maps Integration Details

### Google Maps Services Used

1. **Directions API**
   - Get routes between two points
   - Calculate distance and duration
   - Get turn-by-turn directions
   - Support for driving, walking, transit modes

2. **Places API**
   - Search for places in Rwanda
   - Get place details with photos
   - Find nearby bus stops
   - Get place ratings and reviews

3. **Street View Static API**
   - Get street view images
   - Preview locations before visiting
   - Show Rwandan road images
   - Multiple angles and perspectives

4. **Geocoding API** (Ready for integration)
   - Convert addresses to coordinates
   - Reverse geocoding
   - Address validation

### Map Features Implementation

#### Real-Time Tracking
- Updates every 5 seconds
- Shows bus location on map
- Calculates ETA based on current speed
- Displays next stop information
- Visual bus markers with bus numbers

#### Bus Stop Discovery
- Interactive markers on map
- Tap to see bus stop details
- Get directions to bus stop
- View street view of bus stop location
- Filter by city or area

#### Route Visualization
- Polyline showing route path
- Origin and destination markers
- Distance and duration display
- Multiple route options
- Route comparison on map

## 🔐 Security Features

- **Data Encryption**: Encrypt sensitive data at rest
- **Secure Communication**: HTTPS enforcement
- **Token Management**: Secure authentication tokens
- **Password Hashing**: Secure password storage
- **Biometric Security**: Face ID/Touch ID
- **Blockchain Verification**: Immutable ticket records
- **Input Validation**: SQL injection and XSS prevention

## 🌍 Localization

- **English**: Primary language
- **Kinyarwanda**: Ready for integration
- **French**: Ready for integration
- **Localized Dates**: Region-specific date formats
- **Currency Formatting**: Local currency display

## 📱 Platform Support

- **iPhone**: Full support (iOS 15+)
- **iPad**: Optimized layouts
- **Apple Watch**: Widget support (ready)
- **Mac Catalyst**: Mac app version (ready)

## 🧪 Testing

- **Unit Tests**: Model and service layer tests
- **UI Tests**: User flow testing
- **Integration Tests**: End-to-end testing
- **Performance Tests**: Load and memory testing

## 📚 Documentation

- **Code Documentation**: Inline documentation
- **API Documentation**: Service layer docs
- **User Guide**: Getting started guide
- **Developer Guide**: Contribution guidelines

## 🤝 Contributing

This is a professional project built for a global competition. All code follows Swift best practices and iOS design guidelines.

## 📄 License

Copyright © 2024 TransLinka. All rights reserved.

## 🎯 Key Highlights

- ✅ **500+ Professional Commits**: Comprehensive development history
- ✅ **Real-Time Maps**: Google Maps with live tracking
- ✅ **Rwandan Focus**: Specifically designed for Rwandan transport
- ✅ **Blockchain Integration**: Secure ticket transactions
- ✅ **AR Navigation**: Augmented reality wayfinding
- ✅ **Complete Booking Flow**: End-to-end booking system
- ✅ **Modern UI/UX**: Polished animations and design
- ✅ **Production Ready**: Enterprise-grade code quality

---

**Built with ❤️ for solving transport issues in Rwanda and beyond**

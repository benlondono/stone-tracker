# Infinity Stone Tracker

An iOS app that allows up to 28 users to track their collection of infinity stones (inspired by Thanos from Marvel comics and movies) and view everyone's gauntlet in real-time.

## Features

- **Real-time Stone Tracking**: See all users and their collected stones instantly
- **Infinity Gauntlet Visualization**: Beautiful visual representation of each user's stone collection
- **Complete Gauntlet Celebration**: Special recognition for users who collect all 6 stones
- **User Profiles**: Personal profiles with statistics and rankings
- **Anonymous or Named Users**: Sign in anonymously or with your name
- **Cross-Device Sync**: All data syncs in real-time across all devices using Firebase

## The Six Infinity Stones

1. **Power Stone** (Purple) - Destructive Energy
2. **Space Stone** (Blue) - Spatial Manipulation  
3. **Reality Stone** (Red) - Reality Warping
4. **Soul Stone** (Orange) - Soul Manipulation
5. **Time Stone** (Green) - Time Manipulation
6. **Mind Stone** (Yellow) - Mental Manipulation

## Setup Instructions

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- Firebase project setup

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an iOS app to your project with bundle ID: `com.stonetracker.StoneTracker`
3. Download the `GoogleService-Info.plist` file
4. Replace the placeholder `google-services.json` in this project with your actual `GoogleService-Info.plist`
5. Enable the following Firebase services:
   - **Authentication** (Anonymous sign-in)
   - **Firestore Database** (Real-time database)

### Installation

1. Clone or download this project
2. Open `StoneTracker.xcodeproj` in Xcode
3. Replace the Firebase configuration file with your own
4. Build and run the project on your iOS device or simulator

### Firestore Rules

Use these security rules for your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read all user documents
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## App Structure

### Models
- `User.swift` - User data model with stone collection
- `InfinityStone.swift` - Stone definitions and properties

### Managers
- `AuthenticationManager.swift` - Handles user authentication and profiles
- `StoneManager.swift` - Manages stone collection and real-time updates

### Views
- `AuthenticationView.swift` - Login/signup screen
- `MyStonesView.swift` - Personal stone collection management
- `AllGauntletsView.swift` - View all users and their gauntlets
- `ProfileView.swift` - User profile and statistics
- `StoneCard.swift` - Individual stone display component
- `UserGauntletCard.swift` - User gauntlet preview component

## How It Works

1. **User Registration**: Users can sign in anonymously or with their name
2. **Stone Collection**: Users can add available stones to their collection
3. **Real-time Updates**: All changes sync instantly across all devices
4. **Gauntlet Visualization**: See everyone's progress in beautiful visual format
5. **Competition**: Track rankings and celebrate complete gauntlets

## Game Rules

- Multiple users can have the same stone - no exclusivity!
- Users can optionally track who they got each stone from
- Users can remove stones from their collection at any time
- Complete gauntlet (all 6 stones) gets special recognition
- Up to 28 users can participate in the hunt

## Technical Details

- **Framework**: SwiftUI for modern iOS development
- **Backend**: Firebase Firestore for real-time data
- **Authentication**: Firebase Auth with anonymous sign-in
- **Architecture**: MVVM with ObservableObject managers
- **Minimum iOS**: 17.0
- **Target Devices**: iPhone and iPad

## Contributing

This is a fun project inspired by the Marvel universe. Feel free to fork and add your own features!

## License

This project is for educational and entertainment purposes. Marvel characters and concepts are property of Marvel Entertainment.

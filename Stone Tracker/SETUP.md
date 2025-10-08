# Infinity Stone Tracker - Setup Guide

## Quick Start

### 1. Firebase Setup (Required)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project called "Infinity Stone Tracker"
3. Add an iOS app with bundle ID: `com.stonetracker.StoneTracker`
4. Download the `GoogleService-Info.plist` file
5. Replace the `google-services.json` file in this project with your `GoogleService-Info.plist`
6. Enable these Firebase services:
   - **Authentication** → Sign-in method → Anonymous
   - **Firestore Database** → Create database → Start in test mode

### 2. Firestore Security Rules

In Firebase Console → Firestore Database → Rules, use these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. Build and Run

1. Open `StoneTracker.xcodeproj` in Xcode
2. Select your iOS device or simulator
3. Build and run (⌘+R)

## Features Overview

### 🏆 Core Features
- **Real-time stone tracking** across all users
- **Beautiful gauntlet visualization** for each user
- **Complete gauntlet celebration** when someone gets all 6 stones
- **User rankings and statistics**
- **Anonymous or named user profiles**

### 💎 The Six Infinity Stones
1. **Power Stone** (Purple) - Destructive Energy
2. **Space Stone** (Blue) - Spatial Manipulation
3. **Reality Stone** (Red) - Reality Warping
4. **Soul Stone** (Orange) - Soul Manipulation
5. **Time Stone** (Green) - Time Manipulation
6. **Mind Stone** (Yellow) - Mental Manipulation

### 🎮 How to Play
1. Open the app and sign in (anonymously or with your name)
2. Go to "My Stones" tab to see your collection
3. Tap "+" to add available stones to your gauntlet
4. Optionally enter who you got each stone from
5. Go to "All Gauntlets" to see everyone's progress
6. Collect all 6 stones to complete your gauntlet and achieve ultimate power!

### 📱 App Structure
- **My Stones**: Manage your personal stone collection
- **All Gauntlets**: View all users and their progress
- **Profile**: Your stats and account management

## Troubleshooting

### Common Issues

**App won't build:**
- Make sure you replaced `google-services.json` with your actual `GoogleService-Info.plist`
- Ensure Firebase dependencies are properly installed
- Check that iOS deployment target is 17.0+

**Can't sign in:**
- Verify Anonymous authentication is enabled in Firebase Console
- Check your internet connection
- Ensure Firestore database is created

**No real-time updates:**
- Verify Firestore security rules are set correctly
- Check that the database is in test mode or has proper rules
- Ensure all users are properly authenticated

**Stones not saving:**
- Check Firebase Console for any error messages
- Verify user has write permissions in Firestore rules
- Ensure the user document exists in the database

## Development Notes

- The app supports up to 28 users simultaneously
- Multiple users can have the same stone - no exclusivity!
- Users can optionally track who they got each stone from
- Users can remove stones from their collection at any time
- All data syncs in real-time using Firebase Firestore
- The app works offline and syncs when connection is restored

## Customization

You can easily customize:
- Stone colors and names in `InfinityStone.swift`
- User limit by modifying validation logic
- UI colors and styling throughout the SwiftUI views
- Firestore rules for different permission models

## Support

If you encounter any issues:
1. Check the Firebase Console for error logs
2. Verify all setup steps are completed
3. Ensure your iOS device/simulator meets requirements
4. Check that Firebase project is properly configured

Happy stone hunting! 🚀

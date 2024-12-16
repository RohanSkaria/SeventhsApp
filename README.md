# Pickleball Rankings App

## Overview
A mobile application for tracking Pickleball player ratings, match history, and rankings built with Flutter and Firebase.

## Features
- User authentication
- DUPR rating import
- Rating history tracking
- Match and ranking management

## Technologies
- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Backend Services

## Setup
1. Clone the repository
2. Install Flutter SDK
3. Configure Firebase project
4. Run `flutter pub get`
5. Launch app with `flutter run`

## Key Components
- `HomePage`: Main app interface with profile, rankings, and matches tabs
- `RatingInitScreen`: Initial rating import screen
- `RatingService`: Handles rating updates and history management

## Rating System
- Supports singles and doubles ratings
- Rating range: 1.0 - 7.0
- Tracks rating changes over time

## Firebase Collections
- `users`: User profile data
- `users/[userId]/ratingHistory`: Individual rating change records

## Authentication
- Firebase Authentication
- Email/password login
- Logout functionality

## Development Status
- Profile and rating initialization complete
- Rankings and matches tabs pending implementation

## Future Roadmap
- Match result tracking
- Comprehensive leaderboard
- Social features
- Advanced rating calculations

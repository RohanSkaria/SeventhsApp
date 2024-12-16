// lib/services/user_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserProfile> createUserProfile(User user, String displayName) async {
    final userProfile = UserProfile(
      uid: user.uid,
      displayName: displayName,
      photoURL: user.photoURL,
    );

    // TODO: Add Firestore implementation
    return userProfile;
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // For testing, return mock data
    return UserProfile(
      uid: user.uid,
      displayName: user.displayName ?? 'Pickleball Player',
      photoURL: user.photoURL,
      rating: 0,
      rank: 42,
      matchesPlayed: 10,
      matchesWon: 7,
    );
  }
}

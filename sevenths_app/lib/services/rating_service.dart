// lib/services/rating_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stores a new rating update with history
  Future<void> updateRating({
    required String userId,
    required double newRating,
    required double ratingChange,
    required String matchId,
    required bool isDoubles,
  }) async {
    final batch = _firestore.batch();

    // Update current rating
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'currentRating': newRating,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // Add rating history entry
    final historyRef = userRef.collection('ratingHistory').doc();
    batch.set(historyRef, {
      'rating': newRating,
      'change': ratingChange,
      'matchId': matchId,
      'timestamp': FieldValue.serverTimestamp(),
      'isDoubles': isDoubles,
    });

    await batch.commit();
  }

  // Get rating history for a user
  Stream<QuerySnapshot> getRatingHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('ratingHistory')
        .orderBy('timestamp', descending: true)
        .limit(50) // Last 50 rating changes
        .snapshots();
  }

  // Get current rating
  Future<double> getCurrentRating(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    return (doc.data()?['currentRating'] ?? 1000) as double;
  }

  Future<void> initializeRating({
    required String userId,
    required double initialRating,
    required bool isDoubles,
    required String source,
  }) async {
    final batch = _firestore.batch();

    // Update user document
    final userRef = _firestore.collection('users').doc(userId);
    batch.set(
        userRef,
        {
          'currentRating': initialRating,
          'lastUpdated': FieldValue.serverTimestamp(),
          'ratingType': isDoubles ? 'doubles' : 'singles',
        },
        SetOptions(merge: true));

    // Add initial rating history entry
    final historyRef = userRef.collection('ratingHistory').doc();
    batch.set(historyRef, {
      'rating': initialRating,
      'change': 0,
      'source': source,
      'timestamp': FieldValue.serverTimestamp(),
      'isDoubles': isDoubles,
    });

    await batch.commit();
  }
}

// lib/models/user_profile.dart

class UserProfile {
  final String uid;
  final String displayName;
  String? photoURL;
  double rating;
  int rank;
  int matchesPlayed;
  int matchesWon;

  UserProfile({
    required this.uid,
    required this.displayName,
    this.photoURL,
    this.rating = 1000, // Starting ELO rating
    this.rank = 0,
    this.matchesPlayed = 0,
    this.matchesWon = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoURL': photoURL,
      'rating': rating,
      'rank': rank,
      'matchesPlayed': matchesPlayed,
      'matchesWon': matchesWon,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
      rating: map['rating']?.toDouble() ?? 1000,
      rank: map['rank']?.toInt() ?? 0,
      matchesPlayed: map['matchesPlayed']?.toInt() ?? 0,
      matchesWon: map['matchesWon']?.toInt() ?? 0,
    );
  }
}

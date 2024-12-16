// lib/pages/home_page.dart
import 'package:flutter/material.dart';

import '../services/user_service.dart';
import '../models/user_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/rating_history_chart.dart';
import '../services/rating_service.dart';
import '../screens/rating_init_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserService _userService = UserService();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await _userService.getCurrentUserProfile();

    // Check if the profile has a valid rating
    if (profile == null || profile.rating == null || profile.rating == 0) {
      // Navigate to RatingInitScreen if no rating is set
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RatingInitScreen(),
            fullscreenDialog: true,
          ),
        );
      });
    }

    setState(() => _userProfile = profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickleball Rankings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.leaderboard), text: 'Rankings'),
            Tab(icon: Icon(Icons.sports_tennis), text: 'Matches'),
          ],
        ),
      ),
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildRankingsTab(),
                _buildMatchesTab(),
              ],
            ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Existing avatar and name widgets...
          _buildStatsCard(),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  RatingHistoryChart(
                    userId: _userProfile!.uid,
                    ratingService: RatingService(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.stars),
              title: const Text('Rating'),
              trailing: Text('${_userProfile?.rating ?? 0}'),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Rank'),
              trailing: Text('#${_userProfile?.rank ?? 0}'),
            ),
            ListTile(
              leading: const Icon(Icons.sports_tennis),
              title: const Text('Match Record'),
              trailing: Text(
                '${_userProfile?.matchesWon ?? 0}/${_userProfile?.matchesPlayed ?? 0}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Implement Rankings and Matches tabs next
  Widget _buildRankingsTab() =>
      const Center(child: Text('Rankings Coming Soon'));
  Widget _buildMatchesTab() => const Center(child: Text('Matches Coming Soon'));
}

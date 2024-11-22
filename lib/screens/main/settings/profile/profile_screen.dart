import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  // final String email;
  final int watchedAnime;
  final int watchlist;

  const ProfileScreen({
    super.key,
    required this.name,
    // required this.email,
    this.watchedAnime = 0,
    this.watchlist = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.navigate_before,
            size: 35,
          ),
        ),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
        ),
        forceMaterialTransparency: true,
      ),
      body: ListView(
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('lib/assets/images/profile/user.png')),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: theme.textTheme.titleLarge,
                ),
                // const SizedBox(height: 4),
                // Text(
                //   email,
                //   style: theme.textTheme.bodyMedium,
                // ),
              ],
            ),
          ),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(context, 'Watched', watchedAnime),
                    _buildVerticalDivider(),
                    _buildStat(context, 'Watchlist', watchlist),
                    // _buildVerticalDivider(),
                    // _buildStat(context, 'Reviews', 0),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Menu Items
          _buildMenuItem(
            context,
            Icons.bookmark,
            'My Watchlist',
            'Track your upcoming shows',
          ),
          _buildMenuItem(
            context,
            Icons.history,
            'Watch History',
            'Shows you have completed',
          ),
          // _buildMenuItem(
          //   context,
          //   Icons.star,
          //   'Reviews',
          //   'Your thoughts on anime',
          // ),
          // _buildMenuItem(
          //   context,
          //   Icons.notifications,
          //   'Notifications',
          //   'Manage your alerts',
          // ),
          // _buildMenuItem(
          //   context,
          //   Icons.person,
          //   'Account Settings',
          //   'Manage your profile',
          // ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, int value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value.toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to respective screens
      },
    );
  }
}

// Usage
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      name: 'AnimeUser123',
      // email: 'user@example.com',
      watchedAnime: 42,
      watchlist: 15,
    );
  }
}

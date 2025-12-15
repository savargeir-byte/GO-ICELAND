import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../monetization/premium_gate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: CustomScrollView(
        slivers: [
          // Aurora gradient header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Aurora gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00E5FF),
                          Color(0xFF6A5CFF),
                          Color(0xFF050B14),
                        ],
                      ),
                    ),
                  ),
                  // Blur overlay
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  // Profile info
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF6A5CFF)],
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1A1A2E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF00E5FF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Iceland Explorer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          PremiumManager.hasPremium
                              ? '👑 Premium'
                              : 'Free User',
                          style: TextStyle(
                            color: PremiumManager.hasPremium
                                ? const Color(0xFF00E5FF)
                                : Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Premium card
                  if (!PremiumManager.hasPremium) ...[
                    GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      opacity: 0.15,
                      child: InkWell(
                        onTap: () => _showPremiumSheet(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00E5FF),
                                      Color(0xFF6A5CFF)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.workspace_premium,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upgrade to Premium',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Unlock all features',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF00E5FF),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Stats
                  _buildStatsCard(),
                  const SizedBox(height: 16),

                  // Settings sections
                  _buildSettingTile(
                    icon: Icons.bookmark,
                    title: 'Saved Places',
                    subtitle: 'View your bookmarks',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.cloud_download,
                    title: 'Offline Maps',
                    subtitle: 'Download for offline use',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage alerts',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get assistance',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'View our policy',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'v1.0.0',
                    onTap: () {},
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(16),
      opacity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Places', '23', Icons.place),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.2),
            ),
            _buildStatItem('Trails', '8', Icons.hiking),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.2),
            ),
            _buildStatItem('Distance', '145km', Icons.route),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00E5FF), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(16),
      opacity: 0.1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00E5FF)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PremiumUpgradeSheet(),
    );
  }
}

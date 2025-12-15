import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Global premium status - use PremiumManager for access
bool _hasPremium = false;

/// Manages premium subscription status
class PremiumManager {
  static const String _boxName = 'user_prefs';
  static const String _premiumKey = 'has_premium';

  /// Get current premium status
  static bool get hasPremium => _hasPremium;

  /// Initialize from local storage
  static Future<void> init() async {
    final box = Hive.box(_boxName);
    _hasPremium = box.get(_premiumKey, defaultValue: false);
  }

  /// Update premium status (call after purchase verification)
  static Future<void> setPremium(bool value) async {
    _hasPremium = value;
    final box = Hive.box(_boxName);
    await box.put(_premiumKey, value);
  }

  /// Check if feature is available
  static bool canAccess(PremiumFeature feature) {
    if (_hasPremium) return true;

    switch (feature) {
      case PremiumFeature.expertTrails:
        return false;
      case PremiumFeature.offlineMaps:
        return false;
      case PremiumFeature.noAds:
        return false;
      case PremiumFeature.allPlaces:
        return true; // Basic places are free
      case PremiumFeature.basicTrails:
        return true; // Easy/medium trails are free
    }
  }
}

/// Premium features enum
enum PremiumFeature {
  expertTrails,
  offlineMaps,
  noAds,
  allPlaces,
  basicTrails,
}

/// Widget to gate premium content
class PremiumGate extends StatelessWidget {
  final Widget child;
  final PremiumFeature feature;
  final Widget? lockedWidget;

  const PremiumGate({
    super.key,
    required this.child,
    required this.feature,
    this.lockedWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (PremiumManager.canAccess(feature)) {
      return child;
    }

    return lockedWidget ?? const PremiumLockedCard();
  }
}

/// Default locked content widget
class PremiumLockedCard extends StatelessWidget {
  final String? message;
  final VoidCallback? onUpgrade;

  const PremiumLockedCard({
    super.key,
    this.message,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E).withOpacity(0.9),
              const Color(0xFF0F0F1E).withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF6A5CFF).withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A5CFF).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF6A5CFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Premium Feature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Upgrade to unlock this feature',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onUpgrade ?? () => _showUpgradeDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Upgrade to Premium',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PremiumUpgradeSheet(),
    );
  }
}

/// Premium upgrade bottom sheet
class PremiumUpgradeSheet extends StatelessWidget {
  const PremiumUpgradeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'GO ICELAND Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock the full Iceland experience',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 24),
          _featureRow(Icons.terrain, 'Expert trails & hidden gems'),
          _featureRow(Icons.cloud_off, 'Offline maps for remote areas'),
          _featureRow(Icons.block, 'Ad-free experience'),
          _featureRow(Icons.star, 'Early access to new features'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement in_app_purchase
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Premium - \$9.99/year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe later',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF00E5FF), size: 20),
          ),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

/// Banner ad placeholder widget
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (PremiumManager.hasPremium) {
      return const SizedBox.shrink();
    }

    // TODO: Replace with actual AdWidget from google_mobile_ads
    return Container(
      height: 50,
      color: Colors.black54,
      child: const Center(
        child: Text(
          'Ad Space',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

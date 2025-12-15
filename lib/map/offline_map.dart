import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/glass_container.dart';

class OfflineMap extends StatefulWidget {
  final List<Marker>? markers;
  final LatLng? initialCenter;
  final double? initialZoom;
  final Widget? overlayChild;

  const OfflineMap({
    super.key,
    this.markers,
    this.initialCenter,
    this.initialZoom,
    this.overlayChild,
  });

  @override
  State<OfflineMap> createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  bool _isOffline = false;
  bool _isCaching = false;
  double _cacheProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter:
                widget.initialCenter ?? const LatLng(64.9631, -19.0208),
            initialZoom: widget.initialZoom ?? 6,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'go.iceland.app',
            ),
            if (widget.markers != null) MarkerLayer(markers: widget.markers!),
          ],
        ),

        // Overlay widget (search, cards, etc.)
        if (widget.overlayChild != null) widget.overlayChild!,

        // Offline indicator
        Positioned(
          top: 100,
          left: 16,
          child: SafeArea(
            child: GlassContainer(
              borderRadius: BorderRadius.circular(20),
              opacity: 0.2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isOffline ? Icons.cloud_off : Icons.cloud_done,
                      size: 16,
                      color: _isOffline ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isOffline ? 'Offline' : 'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOffline ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Cache progress
        if (_isCaching)
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: SafeArea(
              child: GlassContainer(
                borderRadius: BorderRadius.circular(16),
                opacity: 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Downloading map tiles...',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _cacheProgress,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF00E5FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_cacheProgress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Utility class for managing offline tile cache
class OfflineTileManager {
  static const String storeName = 'iceland';

  /// Initialize the tile store
  static Future<void> init() async {
    await FMTCObjectBoxBackend().initialise();
    await FMTCStore(storeName).manage.create();
  }

  /// Pre-cache Iceland tiles for offline use
  /// Call this once (e.g., in settings or on first launch)
  static Future<void> downloadIcelandTiles({
    Function(double progress)? onProgress,
  }) async {
    final store = FMTCStore(storeName);

    // Iceland bounding box
    final region = RectangleRegion(
      LatLngBounds(
        const LatLng(63.0, -25.0), // Southwest
        const LatLng(67.5, -12.0), // Northeast
      ),
    );

    // Download tiles for zoom levels 5-12
    await store.download.startForeground(
      region: region.toDownloadable(
        minZoom: 5,
        maxZoom: 12,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'go.iceland.app',
        ),
      ),
    );
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    final store = FMTCStore(storeName);
    final stats = await store.stats;
    final size = await stats.size;

    return {
      'tileCount': await stats.length,
      'size': size,
      'sizeFormatted': _formatBytes(size.toInt()),
    };
  }

  /// Clear tile cache
  static Future<void> clearCache() async {
    final store = FMTCStore(storeName);
    await store.manage.delete();
    await store.manage.create();
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

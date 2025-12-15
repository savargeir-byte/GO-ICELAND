import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';
import '../widgets/glass_container.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  Future<Place?> _getPlace() async {
    final doc = await FirebaseFirestore.instance
        .collection('places')
        .doc(placeId)
        .get();

    if (!doc.exists) return null;
    return Place.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: FutureBuilder<Place?>(
        future: _getPlace(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00E5FF),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color(0xFF050B14),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text("Error"),
              ),
              body: const Center(
                child: Text(
                  "Place not found",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          final place = snapshot.data!;

          return Stack(
            children: [
              // Hero Image
              Hero(
                tag: 'place_${place.id}',
                child: Container(
                  height: 360,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        place.imageUrl ??
                            "https://source.unsplash.com/800x600/?${place.category},iceland",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF050B14).withOpacity(0.8),
                          const Color(0xFF050B14),
                        ],
                        stops: const [0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    opacity: 0.2,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              // Content
              DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return GlassContainer(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    opacity: 0.15,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag handle
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Title
                            Text(
                              place.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 12),

                            // Rating & Category chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildChip(
                                  _capitalize(place.category),
                                  _getCategoryIcon(place.category),
                                ),
                                if (place.rating != null)
                                  _buildChip(
                                    '${place.rating!.toStringAsFixed(1)} (${place.reviews ?? 0})',
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                if (place.difficulty != null)
                                  _buildChip(
                                    place.difficulty!,
                                    Icons.hiking,
                                    color:
                                        _getDifficultyColor(place.difficulty!),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Description
                            if (place.description != null) ...[
                              const Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                place.description!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Services
                            const Text(
                              "Services",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildServiceChip(
                                    'Parking', Icons.local_parking),
                                _buildServiceChip('WC', Icons.wc),
                                _buildServiceChip(
                                    'Viewpoint', Icons.visibility),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Location
                            GlassContainer(
                              borderRadius: BorderRadius.circular(16),
                              opacity: 0.1,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF00E5FF),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Location',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${place.lat.toStringAsFixed(4)}, ${place.lng.toStringAsFixed(4)}',
                                            style: const TextStyle(
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.navigation,
                                      color: Color(0xFF00E5FF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2744),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? const Color(0xFF00E5FF)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'waterfall':
        return Icons.water;
      case 'trail':
      case 'hiking':
        return Icons.hiking;
      case 'beach':
        return Icons.beach_access;
      case 'hot_spring':
        return Icons.hot_tub;
      case 'restaurant':
        return Icons.restaurant;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.place;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
      case 'medium':
        return Colors.orange;
      case 'hard':
      case 'difficult':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';
import 'place_detail_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  Stream<List<Place>> _topPlaces() {
    return FirebaseFirestore.instance
        .collection('places')
        .orderBy('popularity', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              return Place.fromFirestore(data, d.id);
            }).toList());
  }

  Stream<List<Place>> _featuredPlaces() {
    return FirebaseFirestore.instance
        .collection('places')
        .where('featured', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              return Place.fromFirestore(data, d.id);
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Iceland"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "🔥 Top Places",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Place>>(
            stream: _topPlaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              final places = snapshot.data ?? [];

              if (places.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No places yet. Add data to Firestore!'),
                  ),
                );
              }

              return Column(
                children: places.map((p) => _ExploreCard(place: p)).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "⭐ Featured",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Place>>(
            stream: _featuredPlaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }

              final featured = snapshot.data ?? [];
              if (featured.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: featured
                    .map((p) => _ExploreCard(place: p, isFeatured: true))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final Place place;
  final bool isFeatured;

  const _ExploreCard({required this.place, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(placeId: place.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isFeatured ? Border.all(color: Colors.amber, width: 2) : null,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withValues(alpha: 0.06),
            )
          ],
        ),
        child: Row(
          children: [
            // IMAGE
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(18)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    place.imageUrl ?? _getDefaultImage(place.category),
                  ),
                ),
              ),
            ),

            // TEXT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isFeatured)
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _capitalize(place.category),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          place.rating?.toStringAsFixed(1) ?? "—",
                        ),
                        if (place.reviews != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            "(${place.reviews})",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getDefaultImage(String category) {
    switch (category.toLowerCase()) {
      case 'waterfall':
        return "https://source.unsplash.com/400x400/?waterfall,iceland";
      case 'trail':
      case 'hiking':
        return "https://source.unsplash.com/400x400/?hiking,iceland";
      case 'beach':
        return "https://source.unsplash.com/400x400/?beach,iceland";
      case 'hot_spring':
        return "https://source.unsplash.com/400x400/?hot+spring,iceland";
      case 'restaurant':
        return "https://source.unsplash.com/400x400/?food,iceland";
      default:
        return "https://source.unsplash.com/400x400/?iceland,nature";
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';
import '../services/firestore_service.dart';
import 'place_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual user ID from Firebase Auth
    const userId = "demoUser";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Places"),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('saved_places')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final savedDocs = snapshot.data?.docs ?? [];

          if (savedDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No saved places yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore Iceland and save your favorites!",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return FutureBuilder<List<Place>>(
            future: _fetchSavedPlaces(savedDocs.map((d) => d.id).toList()),
            builder: (context, placesSnapshot) {
              if (placesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!placesSnapshot.hasData || placesSnapshot.data!.isEmpty) {
                return const Center(child: Text("Could not load saved places"));
              }

              final places = placesSnapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return _SavedPlaceCard(place: place);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Place>> _fetchSavedPlaces(List<String> placeIds) async {
    if (placeIds.isEmpty) return [];

    final places = <Place>[];

    // Firestore 'in' queries are limited to 10 items
    for (var i = 0; i < placeIds.length; i += 10) {
      final batch = placeIds.skip(i).take(10).toList();

      final snapshot = await FirebaseFirestore.instance
          .collection('places')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      places.addAll(
        snapshot.docs.map((d) => Place.fromFirestore(d.data(), d.id)),
      );
    }

    return places;
  }
}

class _SavedPlaceCard extends StatelessWidget {
  final Place place;

  const _SavedPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDetailScreen(placeId: place.id),
            ),
          );
        },
        child: Row(
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    place.imageUrl ??
                        "https://source.unsplash.com/400x400/?${place.category},iceland",
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _capitalize(place.category),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    if (place.rating != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            place.rating!.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (place.reviews != null)
                            Text(
                              " (${place.reviews})",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.favorite, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }
}

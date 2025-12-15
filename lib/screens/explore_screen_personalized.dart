import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/explore_service.dart';
import '../models/place.dart';
import '../utils/distance.dart';
import 'place_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<List<Place>>? _placesFuture;
  Position? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final position = await getCurrentLocation();
      setState(() {
        _userLocation = position;
      });

      if (position != null) {
        // Personalized feed
        setState(() {
          _placesFuture = ExploreService().personalized("demoUser", position);
        });
      } else {
        // Fallback to top places
        setState(() {
          _placesFuture = ExploreService().topPlaces();
        });
      }
    } catch (e) {
      // Fallback to top places
      setState(() {
        _placesFuture = ExploreService().topPlaces();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userLocation != null ? "For You" : "Explore Iceland"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlaces,
          ),
        ],
      ),
      body: FutureBuilder<List<Place>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Finding the best places for you..."),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPlaces,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final places = snapshot.data ?? [];

          if (places.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.explore_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("No places found"),
                  const SizedBox(height: 8),
                  Text(
                    "Add places to Firestore to get started!",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await _loadPlaces();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_userLocation != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        "Personalized for your location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                const Text(
                  "🔥 Recommended",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...places.map((place) {
                  final distance = _userLocation != null
                      ? distanceKm(
                          _userLocation!.latitude,
                          _userLocation!.longitude,
                          place.lat,
                          place.lng,
                        )
                      : null;
                  return _ExploreCard(place: place, distance: distance);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final Place place;
  final double? distance;

  const _ExploreCard({required this.place, this.distance});

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
                    Text(
                      place.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _capitalize(place.category),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (distance != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            "${distance?.toStringAsFixed(1) ?? '0.0'} km away",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/firestore_service.dart';
import '../models/place.dart';
import '../widgets/glass_container.dart';

class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Place>>(
        stream: FirestoreService().streamPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  const Text('Make sure Firebase is configured'),
                ],
              ),
            );
          }

          final places = snapshot.data ?? [];

          return Stack(
            children: [
              // MAP (hero)
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(64.9631, -19.0208),
                  initialZoom: 6,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.goiceland.app',
                  ),
                  MarkerLayer(
                    markers: places.map((place) {
                      return Marker(
                        point: LatLng(place.lat, place.lng),
                        width: 40,
                        height: 40,
                        child: Icon(
                          _getIconForCategory(place.category),
                          color: _getColorForCategory(place.category),
                          size: 36,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // TOP SEARCH (CRYSTAL)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(28),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      child: Row(
                        children: const [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Search waterfalls, trails, food…",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // BOTTOM CRYSTAL CARDS
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 190,
                  child: places.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: GlassContainer(
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'No places yet. Add data to Firestore!',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          itemCount: places.length > 10 ? 10 : places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            return CrystalPlaceCard(
                              place: place,
                            );
                          },
                        ),
                ),
              ),

              // Place Count Badge
              Positioned(
                top: 100,
                right: 16,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.place, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${places.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getIconForCategory(String category) {
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

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'waterfall':
        return Colors.blue;
      case 'trail':
      case 'hiking':
        return Colors.green;
      case 'beach':
        return Colors.brown;
      case 'hot_spring':
        return Colors.orange;
      case 'restaurant':
        return Colors.red;
      case 'hotel':
        return Colors.purple;
      default:
        return Colors.red;
    }
  }
}

class CrystalPlaceCard extends StatelessWidget {
  final Place place;

  const CrystalPlaceCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = _capitalize(place.category);
    if (place.difficulty != null) {
      subtitle = '$subtitle • ${place.difficulty}';
    }

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(place.rating?.toStringAsFixed(1) ?? "—"),
                  const Spacer(),
                  const Icon(Icons.arrow_forward),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }
}

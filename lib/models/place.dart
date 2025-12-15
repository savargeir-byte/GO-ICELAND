class Place {
  final String id;
  final String name;
  final String category;
  final double lat;
  final double lng;
  final String? difficulty;
  final double? rating;
  final int? reviews;
  final int? popularity;
  final bool? featured;
  final String? imageUrl;
  final String? description;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.lat,
    required this.lng,
    this.difficulty,
    this.rating,
    this.reviews,
    this.popularity,
    this.featured,
    this.imageUrl,
    this.description,
  });

  factory Place.fromFirestore(Map<String, dynamic> data, String id) {
    return Place(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
      difficulty: data['difficulty'],
      rating:
          data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      reviews: data['reviews'],
      popularity: data['popularity'],
      featured: data['featured'],
      imageUrl: data['imageUrl'],
      description: data['description'],
    );
  }
}

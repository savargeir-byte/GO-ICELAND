class PlaceModel {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String category;
  final double rating;
  final String? difficulty;
  final int? reviews;
  final int? popularity;
  final bool? featured;
  final String? imageUrl;
  final String? description;

  PlaceModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.category,
    required this.rating,
    this.difficulty,
    this.reviews,
    this.popularity,
    this.featured,
    this.imageUrl,
    this.description,
  });

  factory PlaceModel.fromJson(String id, Map<String, dynamic> json) {
    return PlaceModel(
      id: id,
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      difficulty: json['difficulty'],
      reviews: json['reviews'],
      popularity: json['popularity'],
      featured: json['featured'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'category': category,
        'rating': rating,
        'difficulty': difficulty,
        'reviews': reviews,
        'popularity': popularity,
        'featured': featured,
        'imageUrl': imageUrl,
        'description': description,
      };

  // Convert from legacy Place model
  factory PlaceModel.fromPlace(dynamic place) {
    return PlaceModel(
      id: place.id,
      name: place.name,
      lat: place.lat,
      lng: place.lng,
      category: place.category,
      rating: place.rating ?? 0.0,
      difficulty: place.difficulty,
      reviews: place.reviews,
      popularity: place.popularity,
      featured: place.featured,
      imageUrl: place.imageUrl,
      description: place.description,
    );
  }
}

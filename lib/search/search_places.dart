import '../data/place_model.dart';

/// Search places by name, category, or description
List<PlaceModel> searchPlaces(List<PlaceModel> all, String query) {
  if (query.isEmpty) return all;

  final q = query.toLowerCase().trim();

  return all.where((p) {
    // Match name
    if (p.name.toLowerCase().contains(q)) return true;

    // Match category
    if (p.category.toLowerCase().contains(q)) return true;

    // Match description if available
    if (p.description?.toLowerCase().contains(q) ?? false) return true;

    return false;
  }).toList();
}

/// Search with weighted scoring for better relevance
List<PlaceModel> searchPlacesRanked(List<PlaceModel> all, String query) {
  if (query.isEmpty) return all;

  final q = query.toLowerCase().trim();

  final scored = <MapEntry<PlaceModel, int>>[];

  for (final p in all) {
    int score = 0;

    // Exact name match (highest)
    if (p.name.toLowerCase() == q) {
      score += 100;
    }
    // Name starts with query
    else if (p.name.toLowerCase().startsWith(q)) {
      score += 50;
    }
    // Name contains query
    else if (p.name.toLowerCase().contains(q)) {
      score += 30;
    }

    // Category match
    if (p.category.toLowerCase().contains(q)) {
      score += 20;
    }

    // Description match
    if (p.description?.toLowerCase().contains(q) ?? false) {
      score += 10;
    }

    // Boost by rating
    score += (p.rating * 2).toInt();

    // Boost by popularity
    if (p.popularity != null) {
      score += (p.popularity! ~/ 100);
    }

    if (score > 0) {
      scored.add(MapEntry(p, score));
    }
  }

  // Sort by score descending
  scored.sort((a, b) => b.value.compareTo(a.value));

  return scored.map((e) => e.key).toList();
}

/// Get search suggestions based on partial input
List<String> getSearchSuggestions(List<PlaceModel> all, String query) {
  if (query.isEmpty) return [];

  final q = query.toLowerCase();
  final suggestions = <String>{};

  for (final p in all) {
    // Add matching place names
    if (p.name.toLowerCase().contains(q)) {
      suggestions.add(p.name);
    }

    // Add matching categories
    if (p.category.toLowerCase().contains(q)) {
      suggestions.add(p.category);
    }
  }

  return suggestions.take(10).toList();
}

/// Filter places by multiple criteria
List<PlaceModel> filterPlaces({
  required List<PlaceModel> all,
  String? category,
  double? minRating,
  String? difficulty,
  bool? featuredOnly,
}) {
  return all.where((p) {
    if (category != null && category.isNotEmpty) {
      if (p.category.toLowerCase() != category.toLowerCase()) return false;
    }

    if (minRating != null) {
      if (p.rating < minRating) return false;
    }

    if (difficulty != null && difficulty.isNotEmpty) {
      if (p.difficulty?.toLowerCase() != difficulty.toLowerCase()) return false;
    }

    if (featuredOnly == true) {
      if (p.featured != true) return false;
    }

    return true;
  }).toList();
}

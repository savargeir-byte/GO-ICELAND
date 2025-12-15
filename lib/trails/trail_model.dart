class Trail {
  final String id;
  final String name;
  final List<List<double>> polyline;
  final double lengthKm;
  final String difficulty;
  final List<double> elevation;
  final String? description;
  final String? imageUrl;
  final int? estimatedMinutes;

  Trail({
    required this.id,
    required this.name,
    required this.polyline,
    required this.lengthKm,
    required this.difficulty,
    required this.elevation,
    this.description,
    this.imageUrl,
    this.estimatedMinutes,
  });

  factory Trail.fromJson(String id, Map<String, dynamic> json) {
    return Trail(
      id: id,
      name: json['name'] ?? '',
      polyline: (json['polyline'] as List<dynamic>?)
              ?.map((p) => List<double>.from(p))
              .toList() ??
          [],
      lengthKm: (json['length_km'] ?? 0).toDouble(),
      difficulty: json['difficulty'] ?? 'easy',
      elevation: List<double>.from(json['elevation'] ?? []),
      description: json['description'],
      imageUrl: json['imageUrl'],
      estimatedMinutes: json['estimated_minutes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'polyline': polyline,
        'length_km': lengthKm,
        'difficulty': difficulty,
        'elevation': elevation,
        'description': description,
        'imageUrl': imageUrl,
        'estimated_minutes': estimatedMinutes,
      };

  /// Get start point of trail
  List<double>? get startPoint => polyline.isNotEmpty ? polyline.first : null;

  /// Get end point of trail
  List<double>? get endPoint => polyline.isNotEmpty ? polyline.last : null;

  /// Get elevation gain (total ascent)
  double get elevationGain {
    if (elevation.length < 2) return 0;
    double gain = 0;
    for (int i = 1; i < elevation.length; i++) {
      final diff = elevation[i] - elevation[i - 1];
      if (diff > 0) gain += diff;
    }
    return gain;
  }

  /// Get elevation loss (total descent)
  double get elevationLoss {
    if (elevation.length < 2) return 0;
    double loss = 0;
    for (int i = 1; i < elevation.length; i++) {
      final diff = elevation[i] - elevation[i - 1];
      if (diff < 0) loss += diff.abs();
    }
    return loss;
  }

  /// Get max elevation
  double get maxElevation =>
      elevation.isNotEmpty ? elevation.reduce((a, b) => a > b ? a : b) : 0;

  /// Get min elevation
  double get minElevation =>
      elevation.isNotEmpty ? elevation.reduce((a, b) => a < b ? a : b) : 0;

  /// Is this an expert trail (premium only)
  bool get isExpert => difficulty == 'expert';
}

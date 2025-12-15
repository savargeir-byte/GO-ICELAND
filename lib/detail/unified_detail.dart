import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/glass_container.dart';
import '../map/map_legend.dart';

class UnifiedDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const UnifiedDetail({super.key, required this.data});

  @override
  State<UnifiedDetail> createState() => _UnifiedDetailState();
}

class _UnifiedDetailState extends State<UnifiedDetail> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(widget.data['category'] ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: CustomScrollView(
        slivers: [
          // Hero image with gradient overlay
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(12),
                opacity: 0.3,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  opacity: 0.3,
                  child: IconButton(
                    icon: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: _isSaved ? const Color(0xFF00E5FF) : Colors.white,
                    ),
                    onPressed: () => setState(() => _isSaved = !_isSaved),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  opacity: 0.3,
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Hero(
                    tag: widget.data['id'] ?? widget.data['name'],
                    child: widget.data['image'] != null
                        ? CachedNetworkImage(
                            imageUrl: widget.data['image'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF1A1A2E),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00E5FF),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF1A1A2E),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white38,
                                size: 64,
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF1A1A2E),
                            child: Icon(
                              getCategoryIcon(widget.data['category'] ?? ''),
                              color: categoryColor,
                              size: 80,
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          const Color(0xFF050B14).withValues(alpha: 0.9),
                        ],
                        stops: const [0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: categoryColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getCategoryIcon(widget.data['category'] ?? ''),
                            size: 16,
                            color: categoryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.data['category'] ?? 'Place',
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.data['name'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating & Distance
                  Row(
                    children: [
                      if (widget.data['rating'] != null) ...[
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          widget.data['rating'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.data['reviews'] != null) ...[
                          Text(
                            ' (${widget.data['reviews']})',
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ],
                        const SizedBox(width: 16),
                      ],
                      const Icon(Icons.place,
                          color: Color(0xFF00E5FF), size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        '12.5 km',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  if (widget.data['tags'] != null &&
                      (widget.data['tags'] as List).isNotEmpty)
                    _buildTags(widget.data['tags']),
                  const SizedBox(height: 24),

                  // Description
                  if (widget.data['description'] != null)
                    _buildSection('Description', widget.data['description']),

                  // Services
                  if (widget.data['services'] != null)
                    _buildServicesSection(widget.data['services']),

                  // Additional details based on category
                  if (widget.data['difficulty'] != null)
                    _buildDetailItem(
                      Icons.trending_up,
                      'Difficulty',
                      widget.data['difficulty'],
                    ),

                  if (widget.data['length_km'] != null)
                    _buildDetailItem(
                      Icons.straighten,
                      'Length',
                      '${widget.data['length_km']} km',
                    ),

                  if (widget.data['duration'] != null)
                    _buildDetailItem(
                      Icons.access_time,
                      'Duration',
                      widget.data['duration'],
                    ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      if (widget.data['booking'] != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.book_online),
                            label: const Text('Book Now'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF00E5FF),
                              side: const BorderSide(color: Color(0xFF00E5FF)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTags(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map<Widget>((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(
            tag.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesSection(List services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: services.map<Widget>((service) {
            return _buildServiceChip(service.toString());
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildServiceChip(String service) {
    IconData icon;
    if (service.toLowerCase().contains('parking')) {
      icon = Icons.local_parking;
    } else if (service.toLowerCase().contains('wc') ||
        service.toLowerCase().contains('toilet')) {
      icon = Icons.wc;
    } else if (service.toLowerCase().contains('wifi')) {
      icon = Icons.wifi;
    } else if (service.toLowerCase().contains('restaurant')) {
      icon = Icons.restaurant;
    } else {
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 16),
          const SizedBox(width: 6),
          Text(
            service,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

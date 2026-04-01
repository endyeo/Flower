import 'package:flutter/material.dart';
import '../models/flower_location.dart';

/// Returns the marker color for a given [FlowerType].
Color flowerColor(FlowerType type) {
  switch (type) {
    case FlowerType.cherryBlossom:
      return const Color(0xFFFF9EBC); // pink
    case FlowerType.forsythia:
      return const Color(0xFFFFD600); // yellow
    case FlowerType.azalea:
      return const Color(0xFFE91E63); // deep pink
    case FlowerType.wisteria:
      return const Color(0xFF9C27B0); // purple
    case FlowerType.magnolia:
      return const Color(0xFFBDBDBD); // white-grey
    case FlowerType.rapeseed:
      return const Color(0xFFFFEB3B); // bright yellow
    case FlowerType.cosmos:
      return const Color(0xFFFF7043); // orange-pink
    case FlowerType.sunflower:
      return const Color(0xFFFFC107); // amber
    case FlowerType.unknown:
      return const Color(0xFF4CAF50); // green
  }
}

/// Compact chip used to toggle a flower type filter.
class FlowerFilterChip extends StatelessWidget {
  const FlowerFilterChip({
    super.key,
    required this.flowerType,
    required this.selected,
    required this.onToggle,
  });

  final FlowerType flowerType;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = flowerColor(flowerType);
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          '${flowerType.emoji} ${flowerType.koreanName}',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet showing details of a tapped flower location.
class FlowerDetailSheet extends StatelessWidget {
  const FlowerDetailSheet({super.key, required this.location});

  final FlowerLocation location;

  @override
  Widget build(BuildContext context) {
    final color = flowerColor(location.flowerType);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 24,
                  child: Text(
                    location.flowerType.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        location.flowerType.koreanName,
                        style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: location.address,
                  iconColor: Colors.red,
                ),
                if (location.region != null) ...[
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.map_outlined,
                    text: location.region!,
                    iconColor: Colors.blue,
                  ),
                ],
                // Bloom months
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: _bloomMonthsText(location.flowerType.bloomMonths),
                  iconColor: Colors.orange,
                ),
                // Description
                if (location.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    location.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _bloomMonthsText(List<int> months) {
    if (months.isEmpty) return '개화 시기 정보 없음';
    final monthNames = months.map((m) => '${m}월').join(' ~ ');
    return '개화 시기: $monthNames';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

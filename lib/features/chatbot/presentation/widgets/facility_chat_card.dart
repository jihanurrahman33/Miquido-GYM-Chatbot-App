import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gym_facility_entity.dart';

class FacilityChatCard extends StatelessWidget {
  final GymFacilityEntity facility;
  final VoidCallback onTap;

  const FacilityChatCard({
    super.key,
    required this.facility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD6E8FE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              facility.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${facility.formattedDistance}  •  ${facility.priceInfo}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.bodyText,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: facility.amenities.map((amenity) {
                return _buildAmenityBadge(amenity);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityBadge(String label) {
    IconData icon;
    final lower = label.toLowerCase();
    if (lower.contains('gym') || lower.contains('fitness')) {
      icon = Icons.fitness_center_rounded;
    } else if (lower.contains('spa') || lower.contains('sauna')) {
      icon = Icons.spa_outlined;
    } else if (lower.contains('pool')) {
      icon = Icons.pool_rounded;
    } else {
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E8FE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.bodyText,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            icon,
            size: 14,
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }
}

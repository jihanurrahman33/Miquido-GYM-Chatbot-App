import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';

class GymCard extends StatelessWidget {
  final GymFacilityEntity gym;
  final VoidCallback? onTap;

  const GymCard({
    super.key,
    required this.gym,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gym.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 15, color: AppTheme.mutedText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    gym.openingHours,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.bodyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.near_me_outlined, size: 15, color: AppTheme.mutedText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    gym.formattedDistance,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.bodyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, size: 15, color: AppTheme.starYellow),
                const SizedBox(width: 6),
                Text(
                  gym.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.bodyText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

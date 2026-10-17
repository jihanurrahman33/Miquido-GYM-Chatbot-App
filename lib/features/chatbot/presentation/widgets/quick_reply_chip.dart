import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QuickReplyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const QuickReplyChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightBlueBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.facilityCardBorderSoft,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
      ),
    );
  }
}

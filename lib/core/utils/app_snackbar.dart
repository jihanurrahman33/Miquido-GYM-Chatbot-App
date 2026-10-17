import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(
    String title,
    String message, {
    SnackPosition position = SnackPosition.TOP,
    Widget? mainButton,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppTheme.bgWhite,
      colorText: AppTheme.darkText,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: AppTheme.successLightBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: AppTheme.successGreen,
          size: 20,
        ),
      ),
      borderColor: AppTheme.successBorder,
      borderWidth: 1.2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: AppTheme.radiusMedium,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
      mainButton: mainButton as TextButton?,
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }

  static void error(
    String title,
    String message, {
    VoidCallback? onRetry,
    String? retryLabel,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppTheme.bgWhite,
      colorText: AppTheme.darkText,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: AppTheme.errorLightBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.error_outline_rounded,
          color: AppTheme.errorRed,
          size: 20,
        ),
      ),
      borderColor: AppTheme.errorBorder,
      borderWidth: 1.2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: AppTheme.radiusMedium,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
      mainButton: onRetry != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onRetry();
              },
              child: Text(
                retryLabel ?? 'RETRY',
                style: const TextStyle(
                  color: AppTheme.errorRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            )
          : null,
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }

  static void warning(
    String title,
    String message, {
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppTheme.bgWhite,
      colorText: AppTheme.darkText,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: AppTheme.warningLightBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: AppTheme.warningAmber,
          size: 20,
        ),
      ),
      borderColor: AppTheme.warningAmber.withValues(alpha: 0.4),
      borderWidth: 1.2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: AppTheme.radiusMedium,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }

  static void info(
    String title,
    String message, {
    SnackPosition position = SnackPosition.BOTTOM,
    Widget? mainButton,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppTheme.navBarDark,
      colorText: AppTheme.bgWhite,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: AppTheme.radiusMedium,
      mainButton: mainButton as TextButton?,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppTheme.cardGray,
        ),
      ),
    );
  }
}

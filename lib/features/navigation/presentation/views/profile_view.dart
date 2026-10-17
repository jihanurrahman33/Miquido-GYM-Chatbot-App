import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightBlueBg,
                  border: Border.all(color: AppTheme.primaryBlue, width: 2),
                ),
                child: const Icon(Icons.person_rounded, size: 48, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 14),
              const Text(
                'Alex Morgan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Miquido Fitness Member • Premium',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.mutedText,
                ),
              ),

              const SizedBox(height: 28),

              // Account Options
              _buildProfileOption(
                icon: Icons.track_changes_rounded,
                title: 'Daily Health Targets',
                subtitle: 'Adjust sleep, calories & step goals',
                onTap: () => controller.openEditGoalsSheet(context),
              ),
              _buildProfileOption(
                icon: Icons.confirmation_number_outlined,
                title: 'My Gym Bookings',
                subtitle: 'Active turnstile passes & reservations',
                onTap: () => Get.toNamed(AppRoutes.bookings),
              ),
              _buildProfileOption(
                icon: Icons.timer_outlined,
                title: 'Active Workout Tracker',
                subtitle: 'Interval session timer & exercise guide',
                onTap: () => Get.toNamed(AppRoutes.workoutTracker),
              ),
              _buildProfileOption(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'FitBot AI Assistant',
                subtitle: 'Personal gym concierge & chat recommendations',
                onTap: () => Get.toNamed(AppRoutes.chatbot),
              ),
              _buildProfileOption(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications & Alerts',
                subtitle: 'Training alarms & pass confirmations',
                onTap: () => Get.toNamed(AppRoutes.notifications),
              ),
              _buildProfileOption(
                icon: Icons.delete_sweep_outlined,
                title: 'Reset Local Cache',
                subtitle: 'Clear stored data & reload Figma defaults',
                onTap: () {
                  Get.defaultDialog(
                    title: 'Reset Storage?',
                    middleText: 'This will reset your conversation and mock bookings back to default.',
                    textConfirm: 'Reset',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back();
                      controller.clearCache();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppTheme.borderLight),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.mutedText,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.mutedText),
        ),
      ),
    );
  }
}

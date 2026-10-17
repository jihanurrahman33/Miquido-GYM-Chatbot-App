import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';

class ProfileView extends StatelessWidget {
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

              const SizedBox(height: 32),

              // Account Items
              _buildProfileOption(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'FitBot AI Assistant',
                subtitle: 'Personal gym concierge & booking',
                onTap: () => Get.toNamed(AppRoutes.chatbot),
              ),
              _buildProfileOption(
                icon: Icons.bookmark_border_rounded,
                title: 'My Gym Bookings',
                subtitle: 'View passes and reservation history',
                onTap: () {
                  Get.snackbar('Bookings', 'All bookings saved locally via GetStorage');
                },
              ),
              _buildProfileOption(
                icon: Icons.notifications_none_rounded,
                title: 'Workout Reminders',
                subtitle: 'Daily notifications & target alarms',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy & Storage',
                subtitle: 'Manage local data cache',
                onTap: () {},
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

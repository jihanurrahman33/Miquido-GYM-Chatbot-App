import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/workout_card.dart';
import '../widgets/gym_card.dart';
import '../widgets/activities_chart.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingSkeleton();
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.loadDashboardData,
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar Icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircleIconButton(
                        icon: Icons.grid_view_rounded,
                        onTap: () => _showQuickActionsSheet(context),
                      ),
                      Row(
                        children: [
                          _buildCircleIconButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            onTap: () => Get.toNamed(AppRoutes.chatbot),
                          ),
                          const SizedBox(width: 12),
                          _buildCircleIconButton(
                            icon: Icons.notifications_none_rounded,
                            onTap: () => Get.toNamed(AppRoutes.notifications),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Large Title: Home
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Section: Upcoming
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Workout Cards Carousel
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = controller.workouts[index];
                      return WorkoutCard(
                        workout: workout,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.workoutDetail,
                            arguments: workout,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Section: Gyms near you
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gyms near you',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 16, color: AppTheme.mutedText),
                          SizedBox(width: 4),
                          Text(
                            'Starowiślna 12',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Gyms horizontal list
                SizedBox(
                  height: 155,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.nearbyGyms.length,
                    itemBuilder: (context, index) {
                      final gym = controller.nearbyGyms[index];
                      return GymCard(
                        gym: gym,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.facilityDetail,
                            arguments: gym,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Section: Activities
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Activities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showPeriodPicker(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlueBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                controller.selectedPeriod.value,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppTheme.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Activities Curve Chart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ActivitiesChart(
                    points: controller.weeklyActivities,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppTheme.borderLight, width: 1.2),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppTheme.darkText,
        ),
      ),
    );
  }

  void _showPeriodPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Activity View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Weekly Overview'),
              trailing: controller.selectedPeriod.value == 'Weekly'
                  ? const Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                Get.back();
                controller.changePeriod('Weekly');
              },
            ),
            ListTile(
              title: const Text('Monthly Overview'),
              trailing: controller.selectedPeriod.value == 'Monthly'
                  ? const Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                Get.back();
                controller.changePeriod('Monthly');
              },
            ),
            ListTile(
              title: const Text('Yearly Overview'),
              trailing: controller.selectedPeriod.value == 'Yearly'
                  ? const Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                Get.back();
                controller.changePeriod('Yearly');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionsSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined, color: AppTheme.primaryBlue),
              title: const Text('Start Workout Session'),
              subtitle: const Text('Launch live interval countdown timer'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.workoutTracker);
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number_outlined, color: AppTheme.primaryBlue),
              title: const Text('My Booked Passes'),
              subtitle: const Text('View and scan turnstile tickets'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.bookings);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerLoading(width: 140, height: 32),
          SizedBox(height: 24),
          ShimmerLoading(width: double.infinity, height: 180, borderRadius: 24),
          SizedBox(height: 32),
          ShimmerLoading(width: 180, height: 24),
          SizedBox(height: 16),
          ShimmerLoading(width: double.infinity, height: 140, borderRadius: 20),
          SizedBox(height: 32),
          ShimmerLoading(width: double.infinity, height: 200, borderRadius: 24),
        ],
      ),
    );
  }
}

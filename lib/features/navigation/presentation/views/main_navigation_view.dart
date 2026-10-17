import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/floating_nav_bar.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../statistics/presentation/views/statistics_view.dart';
import 'search_explore_view.dart';
import 'profile_view.dart';

class MainNavigationView extends GetView<NavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const SearchExploreView(),
      const StatisticsView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: Stack(
        children: [
          // Current active page
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              )),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => FloatingNavBar(
                currentIndex: controller.currentIndex.value,
                onTabSelected: controller.changePage,
              ),
            ),
          ),
        ],
      ),
      // Central floating FitBot AI assistant launcher button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 74),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.chatbot),
          backgroundColor: AppTheme.primaryBlue,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

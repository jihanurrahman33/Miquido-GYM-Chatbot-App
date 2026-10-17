import 'package:get/get.dart';
import '../features/navigation/presentation/views/main_navigation_view.dart';
import '../features/navigation/presentation/bindings/navigation_binding.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/home/presentation/views/workout_detail_view.dart';
import '../features/statistics/presentation/views/statistics_view.dart';
import '../features/chatbot/presentation/views/chatbot_view.dart';
import '../features/chatbot/presentation/views/bookings_view.dart';
import '../features/facilities/presentation/views/facility_detail_view.dart';
import '../features/home/presentation/views/workout_tracker_view.dart';
import '../features/notifications/presentation/views/notifications_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const MainNavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.statistics,
      page: () => const StatisticsView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.chatbot,
      page: () => const ChatbotView(),
      binding: NavigationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.facilityDetail,
      page: () => const FacilityDetailView(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.workoutDetail,
      page: () => const WorkoutDetailView(),
      binding: NavigationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bookings,
      page: () => const BookingsView(),
      binding: NavigationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.workoutTracker,
      page: () => const WorkoutTrackerView(),
      binding: NavigationBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NavigationBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

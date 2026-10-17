import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../home/data/datasources/home_local_datasource.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/i_home_repository.dart';
import '../../../home/domain/usecases/get_home_data_usecase.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../home/presentation/controllers/workout_tracker_controller.dart';
import '../../../statistics/data/datasources/statistics_local_datasource.dart';
import '../../../statistics/data/repositories/statistics_repository_impl.dart';
import '../../../statistics/domain/repositories/i_statistics_repository.dart';
import '../../../statistics/domain/usecases/get_user_metrics_usecase.dart';
import '../../../statistics/presentation/controllers/statistics_controller.dart';
import '../../../chatbot/data/datasources/chatbot_local_datasource.dart';
import '../../../chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../../chatbot/domain/repositories/i_chatbot_repository.dart';
import '../../../chatbot/domain/usecases/booking_usecases.dart';
import '../../../chatbot/domain/usecases/chat_usecases.dart';
import '../../../chatbot/presentation/controllers/chatbot_controller.dart';
import '../../../chatbot/presentation/controllers/bookings_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/search_explore_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    final storageService = Get.find<IStorageService>();

    // Navigation & Global Feature Controllers
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<ProfileController>(() => ProfileController(storageService));

    // Home Layer (DIP: Bind interface to implementation)
    Get.lazyPut<IHomeLocalDataSource>(() => HomeLocalDataSource(storageService));
    Get.lazyPut<IHomeRepository>(() => HomeRepositoryImpl(Get.find<IHomeLocalDataSource>()));
    Get.lazyPut<GetHomeDataUseCase>(() => GetHomeDataUseCase(Get.find<IHomeRepository>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<GetHomeDataUseCase>()));
    Get.lazyPut<WorkoutTrackerController>(() => WorkoutTrackerController());

    // Statistics Layer (DIP: Bind interface to implementation)
    Get.lazyPut<IStatisticsLocalDataSource>(() => StatisticsLocalDataSource(storageService));
    Get.lazyPut<IStatisticsRepository>(() => StatisticsRepositoryImpl(Get.find<IStatisticsLocalDataSource>()));
    Get.lazyPut<GetUserMetricsUseCase>(() => GetUserMetricsUseCase(Get.find<IStatisticsRepository>()));
    Get.lazyPut<StatisticsController>(() => StatisticsController(Get.find<GetUserMetricsUseCase>()));

    // Chatbot & Booking Layer (DIP: Bind interface to implementation)
    Get.lazyPut<IChatbotLocalDataSource>(() => ChatbotLocalDataSource(storageService));
    Get.lazyPut<IChatbotRepository>(() => ChatbotRepositoryImpl(Get.find<IChatbotLocalDataSource>()));
    Get.lazyPut<GetChatHistoryUseCase>(() => GetChatHistoryUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<SendChatMessageUseCase>(() => SendChatMessageUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<BookGymFacilityUseCase>(() => BookGymFacilityUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<GetUserBookingsUseCase>(() => GetUserBookingsUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<CancelBookingUseCase>(() => CancelBookingUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<CreateGymBookingUseCase>(() => CreateGymBookingUseCase(Get.find<IChatbotRepository>()));
    Get.lazyPut<SearchExploreController>(() => SearchExploreController(Get.find<IChatbotRepository>()));

    Get.lazyPut<ChatbotController>(() => ChatbotController(
          getChatHistoryUseCase: Get.find<GetChatHistoryUseCase>(),
          sendChatMessageUseCase: Get.find<SendChatMessageUseCase>(),
          bookGymFacilityUseCase: Get.find<BookGymFacilityUseCase>(),
        ));

    Get.lazyPut<BookingsController>(() => BookingsController(
          getUserBookingsUseCase: Get.find<GetUserBookingsUseCase>(),
          cancelBookingUseCase: Get.find<CancelBookingUseCase>(),
        ));
  }
}

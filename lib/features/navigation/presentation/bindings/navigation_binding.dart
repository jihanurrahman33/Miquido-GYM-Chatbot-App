import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../home/data/datasources/home_local_datasource.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/usecases/get_home_data_usecase.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../statistics/data/datasources/statistics_local_datasource.dart';
import '../../../statistics/data/repositories/statistics_repository_impl.dart';
import '../../../statistics/domain/usecases/get_user_metrics_usecase.dart';
import '../../../statistics/presentation/controllers/statistics_controller.dart';
import '../../../chatbot/data/datasources/chatbot_local_datasource.dart';
import '../../../chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../../chatbot/domain/usecases/chat_usecases.dart';
import '../../../chatbot/presentation/controllers/chatbot_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    final storageService = Get.find<IStorageService>();

    // Navigation
    Get.lazyPut<NavigationController>(() => NavigationController());

    // Home dependencies
    Get.lazyPut<IHomeLocalDataSource>(() => HomeLocalDataSource(storageService));
    Get.lazyPut<HomeRepositoryImpl>(() => HomeRepositoryImpl(Get.find<IHomeLocalDataSource>()));
    Get.lazyPut<GetHomeDataUseCase>(() => GetHomeDataUseCase(Get.find<HomeRepositoryImpl>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<GetHomeDataUseCase>()));

    // Statistics dependencies
    Get.lazyPut<IStatisticsLocalDataSource>(() => StatisticsLocalDataSource(storageService));
    Get.lazyPut<StatisticsRepositoryImpl>(() => StatisticsRepositoryImpl(Get.find<IStatisticsLocalDataSource>()));
    Get.lazyPut<GetUserMetricsUseCase>(() => GetUserMetricsUseCase(Get.find<StatisticsRepositoryImpl>()));
    Get.lazyPut<StatisticsController>(() => StatisticsController(Get.find<GetUserMetricsUseCase>()));

    // Chatbot dependencies
    Get.lazyPut<IChatbotLocalDataSource>(() => ChatbotLocalDataSource(storageService));
    Get.lazyPut<ChatbotRepositoryImpl>(() => ChatbotRepositoryImpl(Get.find<IChatbotLocalDataSource>()));
    Get.lazyPut<GetChatHistoryUseCase>(() => GetChatHistoryUseCase(Get.find<ChatbotRepositoryImpl>()));
    Get.lazyPut<SendChatMessageUseCase>(() => SendChatMessageUseCase(Get.find<ChatbotRepositoryImpl>()));
    Get.lazyPut<BookGymFacilityUseCase>(() => BookGymFacilityUseCase(Get.find<ChatbotRepositoryImpl>()));
    Get.lazyPut<ChatbotController>(() => ChatbotController(
          getChatHistoryUseCase: Get.find<GetChatHistoryUseCase>(),
          sendChatMessageUseCase: Get.find<SendChatMessageUseCase>(),
          bookGymFacilityUseCase: Get.find<BookGymFacilityUseCase>(),
        ));
  }
}

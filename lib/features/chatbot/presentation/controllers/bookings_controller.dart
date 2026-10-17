import 'package:get/get.dart';
import '../../domain/entities/gym_booking_entity.dart';
import '../../domain/usecases/booking_usecases.dart';

class BookingsController extends GetxController {
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingsController({
    required this.getUserBookingsUseCase,
    required this.cancelBookingUseCase,
  });

  final RxBool isLoading = true.obs;
  final RxList<GymBookingEntity> bookings = <GymBookingEntity>[].obs;
  final RxString selectedTab = 'Active'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      isLoading.value = true;
      final result = await getUserBookingsUseCase.execute();
      result.when(
        success: (list) {
          bookings.assignAll(list);
        },
        failure: (_) {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<GymBookingEntity> get filteredBookings {
    if (selectedTab.value == 'Active') {
      return bookings.where((b) => b.isConfirmed).toList();
    } else {
      return bookings.where((b) => !b.isConfirmed).toList();
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final result = await cancelBookingUseCase.execute(bookingId);
    result.when(
      success: (_) {
        Get.snackbar(
          'Pass Cancelled',
          'The reservation was cancelled.',
          snackPosition: SnackPosition.TOP,
        );
        loadBookings();
      },
      failure: (fail) {
        Get.snackbar('Error', fail.message);
      },
    );
  }
}

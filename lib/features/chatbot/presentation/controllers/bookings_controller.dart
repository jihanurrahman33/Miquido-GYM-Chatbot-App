import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_snackbar.dart';
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

  // Lazy loading pagination
  final ScrollController scrollController = ScrollController();
  final RxInt displayedCount = 4.obs;
  final RxBool isPageLoading = false.obs;
  final RxBool hasMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.hasClients &&
        scrollController.position.pixels >= scrollController.position.maxScrollExtent - 80) {
      loadMoreBookings();
    }
  }

  Future<void> loadBookings() async {
    try {
      isLoading.value = true;
      displayedCount.value = 4;
      final result = await getUserBookingsUseCase.execute();
      result.when(
        success: (list) {
          bookings.assignAll(list);
          _updateHasMore();
        },
        failure: (_) {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateHasMore() {
    final total = filteredBookings.length;
    hasMore.value = displayedCount.value < total;
  }

  List<GymBookingEntity> get filteredBookings {
    if (selectedTab.value == 'Active') {
      return bookings.where((b) => b.isConfirmed).toList();
    } else {
      return bookings.where((b) => !b.isConfirmed).toList();
    }
  }

  List<GymBookingEntity> get pagedBookings {
    final list = filteredBookings;
    return list.take(displayedCount.value).toList();
  }

  Future<void> loadMoreBookings() async {
    if (isPageLoading.value || !hasMore.value) return;

    isPageLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    displayedCount.value += 3;
    _updateHasMore();
    isPageLoading.value = false;
  }

  void switchTab(String tab) {
    selectedTab.value = tab;
    displayedCount.value = 4;
    _updateHasMore();
  }

  Future<void> cancelBooking(String bookingId) async {
    final result = await cancelBookingUseCase.execute(bookingId);
    result.when(
      success: (_) {
        AppSnackbar.info(
          'Pass Cancelled',
          'The reservation was cancelled.',
        );
        loadBookings();
      },
      failure: (fail) {
        AppSnackbar.error('Error', fail.message);
      },
    );
  }
}

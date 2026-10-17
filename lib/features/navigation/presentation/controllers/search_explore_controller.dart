import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../../chatbot/domain/repositories/i_chatbot_repository.dart';

class SearchExploreController extends GetxController {
  final IChatbotRepository _repository;

  SearchExploreController(this._repository);

  final RxList<GymFacilityEntity> allFacilities = <GymFacilityEntity>[].obs;
  final RxList<GymFacilityEntity> filteredFacilities = <GymFacilityEntity>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  // Lazy loading & pagination
  final ScrollController scrollController = ScrollController();
  final RxInt displayedCount = 4.obs;
  final RxBool isPageLoading = false.obs;
  final RxBool hasMore = false.obs;

  final List<String> categories = ['All', 'Gym', 'SPA', 'Pool', 'CrossFit'];

  @override
  void onInit() {
    super.onInit();
    loadFacilities();
    scrollController.addListener(_onScroll);
    // GetX Debounce Worker on search input
    debounce(searchQuery, (_) => applyFilter(), time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.hasClients &&
        scrollController.position.pixels >= scrollController.position.maxScrollExtent - 80) {
      loadMoreFacilities();
    }
  }

  Future<void> loadFacilities() async {
    try {
      isLoading.value = true;
      final result = await _repository.getRecommendedFacilities();
      result.when(
        success: (list) {
          allFacilities.assignAll(list);
          applyFilter();
        },
        failure: (_) {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    applyFilter();
  }

  void applyFilter() {
    final query = searchQuery.value.trim().toLowerCase();
    final cat = selectedCategory.value;

    final matched = allFacilities.where((f) {
      final matchesQuery = query.isEmpty ||
          f.name.toLowerCase().contains(query) ||
          f.address.toLowerCase().contains(query);

      final matchesCategory = cat == 'All' ||
          f.amenities.any((a) => a.toLowerCase() == cat.toLowerCase());

      return matchesQuery && matchesCategory;
    }).toList();

    filteredFacilities.assignAll(matched);
    displayedCount.value = 4;
    hasMore.value = displayedCount.value < filteredFacilities.length;
  }

  List<GymFacilityEntity> get pagedFacilities {
    return filteredFacilities.take(displayedCount.value).toList();
  }

  Future<void> loadMoreFacilities() async {
    if (isPageLoading.value || !hasMore.value) return;

    isPageLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    displayedCount.value += 4;
    hasMore.value = displayedCount.value < filteredFacilities.length;
    isPageLoading.value = false;
  }
}

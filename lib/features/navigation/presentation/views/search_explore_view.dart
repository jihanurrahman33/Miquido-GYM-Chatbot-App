import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/search_explore_controller.dart';

class SearchExploreView extends GetView<SearchExploreController> {
  const SearchExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore Facilities',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar Input
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.cardGray,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppTheme.mutedText),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: controller.onSearchChanged,
                            decoration: const InputDecoration(
                              hintText: 'Search gyms, pools, studios...',
                              hintStyle: TextStyle(color: AppTheme.mutedText, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Filter Chips
                  SizedBox(
                    height: 38,
                    child: Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: controller.categories.map((cat) {
                            final isSelected = controller.selectedCategory.value == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryBlue,
                                backgroundColor: AppTheme.cardGray,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.darkText,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 13,
                                ),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                onSelected: (_) => controller.selectCategory(cat),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Facilities List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
                }

                if (controller.filteredFacilities.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off_rounded,
                    title: 'No Facilities Found',
                    subtitle: 'Try adjusting your search query or switching categories.',
                    buttonText: 'Reset Filters',
                    onAction: () {
                      controller.onSearchChanged('');
                      controller.selectCategory('All');
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.filteredFacilities.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final gym = controller.filteredFacilities[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.facilityDetail, arguments: gym),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppTheme.lightBlueBg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.fitness_center_rounded, color: AppTheme.primaryBlue, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gym.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppTheme.darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${gym.address} • ${gym.formattedDistance}',
                                    style: const TextStyle(
                                      color: AppTheme.mutedText,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    children: gym.amenities.take(3).map((a) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppTheme.lightBlueBg,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          a,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.mutedText),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

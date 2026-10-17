import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../../chatbot/presentation/controllers/chatbot_controller.dart';

class FacilityDetailView extends StatelessWidget {
  const FacilityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final GymFacilityEntity facility = (Get.arguments is GymFacilityEntity)
        ? (Get.arguments as GymFacilityEntity)
        : const GymFacilityEntity(
            id: 'gym_1',
            name: 'Energym Fitness Club',
            address: 'Wrocławska 20, Kraków',
            distanceMeters: 450,
            rating: 4.9,
            amenities: ['Gym', 'SPA', 'Pool', 'Sauna', 'Personal Trainer'],
            priceInfo: '35 PLN',
            openingHours: '06:00 - 23:00',
          );

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.lightBlueBg,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppTheme.darkText, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.lightBlueBg,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: AppTheme.primaryBlue,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        facility.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance & Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlueBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.near_me_outlined, size: 14, color: AppTheme.primaryBlue),
                            const SizedBox(width: 4),
                            Text(
                              facility.formattedDistance,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLightBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppTheme.starYellow),
                            const SizedBox(width: 4),
                            Text(
                              '${facility.rating}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.warningDarkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Pricing & Opening Hours Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.cardGray,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined, color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                facility.priceInfo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Opening Hours: ${facility.openingHours}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.bodyText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                facility.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.bodyText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  const Text(
                    'About this facility',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    facility.description.isNotEmpty
                        ? facility.description
                        : 'Equipped with cutting-edge fitness gear, experienced personal trainers, and clean shower amenities.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme.bodyText,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Amenities Section
                  const Text(
                    'Included Amenities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: facility.amenities.map((amenity) {
                      return Chip(
                        label: Text(amenity),
                        backgroundColor: AppTheme.lightBlueBg,
                        labelStyle: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // Book Pass Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Get.isRegistered<ChatbotController>()) {
                          Get.find<ChatbotController>().bookFacility(facility);
                          Get.back();
                        } else {
                          Get.toNamed(AppRoutes.chatbot);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Book a Visit with FitBot',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

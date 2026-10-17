import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
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
        title: const Text(
          'My Gym Bookings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.darkText),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Obx(
              () => Row(
                children: [
                  _buildTab('Active Passes', 'Active'),
                  const SizedBox(width: 12),
                  _buildTab('History', 'Past'),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
              }

              final items = controller.pagedBookings;
              final isPageLoading = controller.isPageLoading.value;

              if (items.isEmpty) {
                return EmptyStateView(
                  icon: Icons.confirmation_number_outlined,
                  title: 'No Passes Found',
                  subtitle: controller.selectedTab.value == 'Active'
                      ? 'You have no active gym passes booked. Ask FitBot or explore clubs to reserve one!'
                      : 'No past booking history yet.',
                  buttonText: controller.selectedTab.value == 'Active' ? 'Book with FitBot' : null,
                  onAction: () => Get.toNamed(AppRoutes.chatbot),
                );
              }

              final totalItemCount = items.length + (isPageLoading ? 1 : 0);

              return ListView.separated(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: totalItemCount,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue),
                      ),
                    );
                  }

                  final b = items[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              b.facilityName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkText,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: b.isConfirmed ? AppTheme.successLightBg : AppTheme.cardGray,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                b.isConfirmed ? 'CONFIRMED' : 'CANCELLED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: b.isConfirmed ? AppTheme.successGreen : AppTheme.mutedText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b.facilityAddress,
                          style: const TextStyle(fontSize: 13, color: AppTheme.mutedText),
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              b.slotTime,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.bodyText),
                            ),
                            const Spacer(),
                            Text(
                              b.price,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // QR Pass container
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlueBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.qr_code_2_rounded, size: 36, color: AppTheme.primaryBlue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Turnstile Scan Code', style: TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                                    Text(
                                      b.qrCodeData,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              if (b.isConfirmed)
                                TextButton(
                                  onPressed: () => controller.cancelBooking(b.id),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 13)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String key) {
    final isSelected = controller.selectedTab.value == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.switchTab(key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.navBarDark : AppTheme.cardGray,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.bodyText,
            ),
          ),
        ),
      ),
    );
  }
}

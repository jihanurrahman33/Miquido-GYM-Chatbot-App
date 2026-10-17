import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/statistics_controller.dart';
import '../widgets/week_calendar_strip.dart';
import '../widgets/overview_stat_card.dart';
import '../widgets/concentric_rings_painter.dart';
import '../widgets/metric_legend_item.dart';
import '../widgets/calories_bar_chart.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerLoading(width: 160, height: 32),
                  SizedBox(height: 12),
                  ShimmerLoading(width: 100, height: 20),
                  SizedBox(height: 24),
                  ShimmerLoading(width: double.infinity, height: 50, borderRadius: 14),
                  SizedBox(height: 32),
                  ShimmerLoading(width: 140, height: 24),
                  SizedBox(height: 16),
                  ShimmerLoading(width: double.infinity, height: 130, borderRadius: 20),
                  SizedBox(height: 32),
                  ShimmerLoading(width: double.infinity, height: 180, borderRadius: 24),
                ],
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.loadStatistics,
            );
          }

          final metrics = controller.metrics.value;
          if (metrics == null) {
            return const Center(child: Text('No metrics data available'));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Large Title: Statistics
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Month Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    metrics.formattedMonthYear,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.bodyText,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Week Calendar Strip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: WeekCalendarStrip(
                    days: controller.weekDays,
                    selectedIndex: controller.selectedDayIndex.value,
                    onSelectDay: controller.selectDay,
                  ),
                ),

                const SizedBox(height: 32),

                // Section: Overview
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Overview Stat Cards Carousel
                SizedBox(
                  height: 140,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      OverviewStatCard(
                        icon: Icons.local_fire_department_outlined,
                        value: metrics.calBurnt,
                        label: 'Cal Burnt',
                      ),
                      OverviewStatCard(
                        icon: Icons.access_time_rounded,
                        value: metrics.totalTime,
                        label: 'Total Time',
                      ),
                      OverviewStatCard(
                        icon: Icons.fitness_center_rounded,
                        value: '${metrics.exercises}',
                        label: 'Exercises',
                      ),
                      OverviewStatCard(
                        icon: Icons.pause_circle_outline_rounded,
                        value: '${metrics.breaks}',
                        label: 'Breaks',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section: Daily progress
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Daily progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Concentric Rings & Legend Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.borderLight, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Concentric Progress Rings
                        ConcentricProgressRings(
                          sleepProgress: metrics.sleepProgress,
                          caloriesProgress: metrics.caloriesProgress,
                          stepsProgress: metrics.stepsProgress,
                          size: 155,
                        ),
                        const SizedBox(width: 24),
                        // Legend Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MetricLegendItem(
                                dotColor: AppTheme.ringSleep,
                                title: 'Sleep',
                                valueText: metrics.sleepDisplayText,
                              ),
                              const SizedBox(height: 18),
                              MetricLegendItem(
                                dotColor: AppTheme.ringCalories,
                                title: 'Calories',
                                valueText: metrics.caloriesDisplayText,
                              ),
                              const SizedBox(height: 18),
                              MetricLegendItem(
                                dotColor: AppTheme.ringSteps,
                                title: 'Steps',
                                valueText: metrics.stepsDisplayText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Motivational banner from Figma 403:2897
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.successGreen,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You are the best of the best! 🎉',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Weekly Calories Bar Chart
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CaloriesBarChart(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

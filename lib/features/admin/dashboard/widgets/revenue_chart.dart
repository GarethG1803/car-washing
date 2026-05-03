import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/admin_finance_provider.dart';

class RevenueChart extends ConsumerWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(adminFinanceChartProvider);

    return chartAsync.when(
      loading: () => _buildContainer(
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildContainer(
        child: Center(
          child: Text(
            'Could not load chart',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
      data: (data) {
        if (data.isEmpty) {
          return _buildContainer(
            child: Center(
              child: Text(
                'No revenue data yet',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        // Find non-zero earnings for better display
        final hasData = data.any((d) => (d['revenue'] as num).toDouble() > 0);
        if (!hasData) {
          return _buildContainer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'Revenue will appear here\nafter completed orders',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final spots = data
            .asMap()
            .entries
            .map((entry) => FlSpot(
                  entry.key.toDouble(),
                  (entry.value['revenue'] as num).toDouble(),
                ))
            .toList();

        final maxY = spots
            .map((s) => s.y)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1.0, double.infinity) * 1.15;

        // Calculate total revenue for the period
        final totalRevenue = spots.fold(0.0, (sum, spot) => sum + spot.y);

        return _buildContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total revenue header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${NumberFormat('#,###').format(totalRevenue.toInt())}',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'last 30 days',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chart
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY > 0 ? (maxY / 4).ceilToDouble().clamp(1, double.infinity) : 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.divider.withValues(alpha: 0.5),
                        strokeWidth: 0.5,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: maxY > 0 ? (maxY / 4).ceilToDouble().clamp(1, double.infinity) : 1,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.min || value == meta.max) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                NumberFormat.compactCurrency(symbol: '').format(value),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 7, // Show every 7 days
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                            // Only show first, every 7th, and last
                            if (idx != 0 && idx % 7 != 0 && idx != data.length - 1) {
                              return const SizedBox.shrink();
                            }
                            try {
                              final date = DateTime.parse(data[idx]['date']);
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            } catch (_) {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.x.toInt();
                            String dateStr = '';
                            if (idx >= 0 && idx < data.length) {
                              try {
                                final d = DateTime.parse(data[idx]['date']);
                                dateStr = DateFormat('MMM d').format(d);
                              } catch (_) {
                                dateStr = 'Day ${idx + 1}';
                              }
                            }
                            return LineTooltipItem(
                              '$dateStr\nRp ${NumberFormat('#,###').format(spot.y.toInt())}',
                              AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: AppColors.primary,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.2),
                              AppColors.primary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                    minY: 0,
                    maxY: maxY,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 260,
        child: child,
      ),
    );
  }
}
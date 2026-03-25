import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_analytics.dart';
import 'package:gap/gap.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Analytics'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Customer Growth', style: AppTypography.titleMedium),
          const Gap(12),
          Container(
            height: 200, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: LineChart(LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                  final data = MockAnalytics.customerGrowth;
                  if (v.toInt() >= 0 && v.toInt() < data.length) return Text(data[v.toInt()]['month'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10));
                  return const SizedBox.shrink();
                })),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [LineChartBarData(
                spots: List.generate(MockAnalytics.customerGrowth.length, (i) => FlSpot(i.toDouble(), (MockAnalytics.customerGrowth[i]['customers'] as int).toDouble())),
                isCurved: true, color: AppColors.success, barWidth: 3, dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: AppColors.success.withOpacity(0.1)),
              )],
            )),
          ),
          const Gap(24),
          Text('Service Breakdown', style: AppTypography.titleMedium),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: Column(children: [
              SizedBox(height: 180, child: PieChart(PieChartData(
                sections: MockAnalytics.serviceBreakdown.map((s) => PieChartSectionData(
                  value: s['percentage'] as double, title: '${(s['percentage'] as double).toStringAsFixed(0)}%',
                  color: Color(s['color'] as int), radius: 60, titleStyle: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                )).toList(),
                sectionsSpace: 2, centerSpaceRadius: 30,
              ))),
              const Gap(16),
              ...MockAnalytics.serviceBreakdown.map((s) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: Color(s['color'] as int), borderRadius: BorderRadius.circular(3))),
                const Gap(8),
                Expanded(child: Text(s['service'] as String, style: AppTypography.bodyMedium)),
                Text('${(s['percentage'] as double).toStringAsFixed(0)}%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ]))),
            ]),
          ),
          const Gap(24),
          Text('Conversion Funnel', style: AppTypography.titleMedium),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: Column(children: [
              _funnelRow('App Visits', '5,240', 1.0),
              _funnelRow('Service Viewed', '3,180', 0.61),
              _funnelRow('Booking Started', '1,560', 0.30),
              _funnelRow('Booking Completed', '1,247', 0.24),
              _funnelRow('Repeat Customer', '680', 0.13),
            ]),
          ),
          const Gap(32),
        ]),
      ),
    );
  }

  Widget _funnelRow(String label, String value, double pct) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTypography.bodyMedium), Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600))]),
      const Gap(6),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: AppColors.divider, valueColor: AlwaysStoppedAnimation(AppColors.primary.withOpacity(0.3 + pct * 0.7)))),
    ]));
  }
}

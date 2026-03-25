import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class FinanceOverviewScreen extends StatelessWidget {
  const FinanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [TextButton(onPressed: () => context.push('/admin/finance/invoices'), child: const Text('Invoices'))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _summaryCard('Revenue', 'Rp 785.100.000', Icons.trending_up, AppColors.success),
            const Gap(12),
            _summaryCard('Expenses', 'Rp 273.600.000', Icons.trending_down, AppColors.error),
          ]),
          const Gap(12),
          Row(children: [
            _summaryCard('Profit', 'Rp 511.500.000', Icons.account_balance, AppColors.primary),
            const Gap(12),
            _summaryCard('Pending', 'Rp 67.800.000', Icons.hourglass_empty, AppColors.warning),
          ]),
          const Gap(24),
          Text('Revenue vs Expenses', style: AppTypography.titleMedium),
          const Gap(12),
          Container(
            height: 220, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: BarChart(BarChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5000, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (v.toInt() >= 0 && v.toInt() < months.length) return Text(months[v.toInt()], style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10));
                  return const SizedBox.shrink();
                })),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(6, (i) => BarChartGroupData(x: i, barsSpace: 4, barRods: [
                BarChartRodData(toY: [12500, 14200, 13800, 16500, 18200, 21000][i].toDouble(), color: AppColors.primary, width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                BarChartRodData(toY: [4200, 5100, 4800, 5500, 6200, 7000][i].toDouble(), color: AppColors.error.withOpacity(0.5), width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
              ])),
            )),
          ),
          const Gap(24),
          Text('Recent Transactions', style: AppTypography.titleMedium),
          const Gap(12),
          ..._transactions().map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: (t['isIncome'] as bool ? AppColors.success : AppColors.error).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(t['isIncome'] as bool ? Icons.arrow_downward : Icons.arrow_upward, color: t['isIncome'] as bool ? AppColors.success : AppColors.error, size: 20)),
              const Gap(12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t['desc'] as String, style: AppTypography.bodyMedium), Text(t['date'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))])),
              Text(t['amount'] as String, style: AppTypography.titleMedium.copyWith(color: t['isIncome'] as bool ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 24),
        const Gap(8),
        Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
      ]),
    ));
  }

  List<Map<String, dynamic>> _transactions() => [
    {'desc': 'Booking #1247 - Standard Wash', 'date': 'Today, 10:30 AM', 'amount': '+Rp 150.000', 'isIncome': true},
    {'desc': 'Supply Reorder - Shampoo', 'date': 'Today, 9:15 AM', 'amount': '-Rp 350.000', 'isIncome': false},
    {'desc': 'Booking #1246 - Premium Detail', 'date': 'Yesterday', 'amount': '+Rp 500.000', 'isIncome': true},
    {'desc': 'Washer Payout - Marcus R.', 'date': 'Yesterday', 'amount': '-Rp 1.200.000', 'isIncome': false},
    {'desc': 'Booking #1245 - Quick Wash', 'date': 'Feb 15', 'amount': '+Rp 75.000', 'isIncome': true},
  ];
}

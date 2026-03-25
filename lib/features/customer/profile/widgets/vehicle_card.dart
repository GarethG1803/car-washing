import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/vehicle.dart';
import 'package:gap/gap.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Row(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12), image: vehicle.imageUrl != null ? DecorationImage(image: NetworkImage(vehicle.imageUrl!), fit: BoxFit.cover) : null), child: vehicle.imageUrl == null ? const Icon(Icons.directions_car, color: AppColors.primary, size: 28) : null),
        const Gap(16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('${vehicle.year} ${vehicle.make} ${vehicle.model}', style: AppTypography.titleMedium),
            if (vehicle.isDefault) ...[const Gap(8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(4)), child: Text('Default', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)))],
          ]),
          const Gap(4),
          Text('${vehicle.color} • ${vehicle.licensePlate} • ${vehicle.type.name}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ])),
        PopupMenuButton(icon: const Icon(Icons.more_vert, color: AppColors.textSecondary), itemBuilder: (c) => [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'default', child: Text('Set as Default')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ]),
      ]),
    );
  }
}

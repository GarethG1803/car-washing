import 'package:flutter/material.dart';
import 'package:clean_ride/data/models/service_package.dart';
import 'package:clean_ride/features/customer/services/widgets/service_package_card.dart';

class ServiceGrid extends StatelessWidget {
  final List<ServicePackage> services;

  const ServiceGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: services
          .map((service) => ServicePackageCard(service: service))
          .toList(),
    );
  }
}

import 'package:clean_ride/data/models/vehicle.dart';

class MockVehicles {
  static final List<Vehicle> vehicles = [
    const Vehicle(
      id: 'v1',
      userId: 'c1',
      make: 'Tesla',
      model: 'Model 3',
      year: 2021,
      color: 'White',
      licensePlate: 'ABC 1234',
      type: VehicleType.sedan,
      isDefault: true,
    ),
    const Vehicle(
      id: 'v2',
      userId: 'c1',
      make: 'BMW',
      model: 'X5',
      year: 2023,
      color: 'Black',
      licensePlate: 'XYZ 5678',
      type: VehicleType.suv,
    ),
    const Vehicle(
      id: 'v3',
      userId: 'c2',
      make: 'Ford',
      model: 'F-150',
      year: 2020,
      color: 'Blue',
      licensePlate: 'DEF 9012',
      type: VehicleType.truck,
    ),
    const Vehicle(
      id: 'v4',
      userId: 'c3',
      make: 'Honda',
      model: 'Civic',
      year: 2022,
      color: 'Silver',
      licensePlate: 'GHI 3456',
      type: VehicleType.hatchback,
    ),
  ];
}

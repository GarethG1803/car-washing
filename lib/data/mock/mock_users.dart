import 'package:clean_ride/data/models/user.dart';

class MockUsers {
  MockUsers._();

  static final DateTime _now = DateTime.now();

  static final User currentCustomer = User(
    id: 'c1',
    name: 'Alex Johnson',
    email: 'alex@email.com',
    phone: '+1 555-0101',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
    role: UserRole.customer,
    createdAt: _now.subtract(const Duration(days: 180)),
  );

  static final User currentWasher = User(
    id: 'w1',
    name: 'Marcus Rivera',
    email: 'marcus@cleanride.com',
    phone: '+1 555-0201',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop',
    role: UserRole.washer,
    createdAt: _now.subtract(const Duration(days: 365)),
  );

  static final User currentAdmin = User(
    id: 'a1',
    name: 'Sarah Chen',
    email: 'sarah@cleanride.com',
    phone: '+1 555-0301',
    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&fit=crop',
    role: UserRole.admin,
    createdAt: _now.subtract(const Duration(days: 730)),
  );

  static final List<User> customers = [
    currentCustomer,
    User(
      id: 'c2',
      name: 'Priya Patel',
      email: 'priya.patel@email.com',
      phone: '+1 555-0102',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 120)),
    ),
    User(
      id: 'c3',
      name: 'James O\'Brien',
      email: 'james.obrien@email.com',
      phone: '+1 555-0103',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 90)),
    ),
    User(
      id: 'c4',
      name: 'Maria Garcia',
      email: 'maria.garcia@email.com',
      phone: '+1 555-0104',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 60)),
    ),
    User(
      id: 'c5',
      name: 'David Kim',
      email: 'david.kim@email.com',
      phone: '+1 555-0105',
      avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 45)),
    ),
    User(
      id: 'c6',
      name: 'Fatima Al-Rashid',
      email: 'fatima.alrashid@email.com',
      phone: '+1 555-0106',
      avatarUrl: 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 30)),
    ),
    User(
      id: 'c7',
      name: 'Tyler Washington',
      email: 'tyler.wash@email.com',
      phone: '+1 555-0107',
      avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 15)),
    ),
    User(
      id: 'c8',
      name: 'Sophia Nguyen',
      email: 'sophia.nguyen@email.com',
      phone: '+1 555-0108',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&fit=crop',
      role: UserRole.customer,
      createdAt: _now.subtract(const Duration(days: 7)),
    ),
  ];

  static final List<User> washers = [
    currentWasher,
    User(
      id: 'w2',
      name: 'Elena Kowalski',
      email: 'elena@cleanride.com',
      phone: '+1 555-0202',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&fit=crop',
      role: UserRole.washer,
      createdAt: _now.subtract(const Duration(days: 300)),
    ),
    User(
      id: 'w3',
      name: 'Andre Thompson',
      email: 'andre@cleanride.com',
      phone: '+1 555-0203',
      avatarUrl: 'https://images.unsplash.com/photo-1506277886164-e25aa3f4ef7f?w=200&fit=crop',
      role: UserRole.washer,
      createdAt: _now.subtract(const Duration(days: 240)),
    ),
    User(
      id: 'w4',
      name: 'Raj Mehta',
      email: 'raj@cleanride.com',
      phone: '+1 555-0204',
      avatarUrl: 'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?w=200&fit=crop',
      role: UserRole.washer,
      createdAt: _now.subtract(const Duration(days: 150)),
    ),
    User(
      id: 'w5',
      name: 'Carlos Diaz',
      email: 'carlos@cleanride.com',
      phone: '+1 555-0205',
      avatarUrl: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=200&fit=crop',
      role: UserRole.washer,
      createdAt: _now.subtract(const Duration(days: 90)),
    ),
  ];
}

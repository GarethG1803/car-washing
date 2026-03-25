import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/data/models/user.dart';
import 'package:clean_ride/data/mock/mock_users.dart';

/// Holds the currently logged-in user (null when unauthenticated).
final currentUserProvider = StateProvider<User?>((ref) => null);

/// Convenience provider that derives auth state from [currentUserProvider].
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);

/// Tracks the role selected on the role-selection screen.
/// This is separate from the router-level [roleProvider] and can be used
/// in feature-level widgets that need role awareness.
final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);

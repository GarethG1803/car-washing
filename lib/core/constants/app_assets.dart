/// Centralized asset path constants for the CleanRide app.
///
/// All asset references should use these constants to avoid
/// hardcoded strings and enable easy refactoring.
abstract class AppAssets {
  AppAssets._();

  // ── Images ──────────────────────────────────────────────────────────────

  static const String logo = 'assets/images/logo.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String carWash = 'assets/images/car_wash.png';
  static const String emptyBookings = 'assets/images/empty_bookings.png';
  static const String emptyChat = 'assets/images/empty_chat.png';

  // ── Animations ──────────────────────────────────────────────────────────

  static const String successAnimation = 'assets/animations/success.json';
  static const String carAnimation = 'assets/animations/car_wash.json';

  // ── Icons ───────────────────────────────────────────────────────────────

  static const String mapPin = 'assets/icons/map_pin.svg';
  static const String sedan = 'assets/icons/sedan.svg';
  static const String suv = 'assets/icons/suv.svg';
  static const String truck = 'assets/icons/truck.svg';
}

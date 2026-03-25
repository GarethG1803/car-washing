/// Centralized string constants for the CleanRide app.
///
/// Organized by feature / section to keep things discoverable.
/// All user-facing text should be referenced from here to
/// simplify future localization efforts.
abstract class AppStrings {
  AppStrings._();

  // ── General / Branding ──────────────────────────────────────────────────

  static const String appName = 'CleanRide';
  static const String tagline = 'Premium Car Wash at Your Doorstep';

  // ── Onboarding ──────────────────────────────────────────────────────────

  static const String onboardingTitle1 = 'Book in Seconds';
  static const String onboardingSubtitle1 =
      'Choose your preferred car wash service and schedule a time that works for you.';

  static const String onboardingTitle2 = 'We Come to You';
  static const String onboardingSubtitle2 =
      'Our professional washers arrive at your location — home, office, or anywhere.';

  static const String onboardingTitle3 = 'Sparkling Results';
  static const String onboardingSubtitle3 =
      'Sit back and enjoy a spotless ride with our premium cleaning products.';

  // ── Authentication ──────────────────────────────────────────────────────

  static const String login = 'Log In';
  static const String register = 'Register';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String logout = 'Log Out';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String orContinueWith = 'Or continue with';
  static const String agreeToTerms = 'I agree to the Terms & Conditions';

  // ── Common Button Labels ────────────────────────────────────────────────

  static const String getStarted = 'Get Started';
  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String done = 'Done';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String submit = 'Submit';
  static const String apply = 'Apply';
  static const String retry = 'Retry';
  static const String continueText = 'Continue';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String seeAll = 'See All';
  static const String bookNow = 'Book Now';

  // ── Tab Labels — Customer ───────────────────────────────────────────────

  static const String home = 'Home';
  static const String bookings = 'Bookings';
  static const String chat = 'Chat';
  static const String profile = 'Profile';

  // ── Tab Labels — Washer ─────────────────────────────────────────────────

  static const String dashboard = 'Dashboard';
  static const String jobs = 'Jobs';
  static const String earnings = 'Earnings';
  static const String account = 'Account';

  // ── Tab Labels — Admin ──────────────────────────────────────────────────

  static const String overview = 'Overview';
  static const String users = 'Users';
  static const String services = 'Services';
  static const String reports = 'Reports';

  // ── Booking Status Labels ───────────────────────────────────────────────

  static const String statusPending = 'Pending';
  static const String statusConfirmed = 'Confirmed';
  static const String statusInProgress = 'In Progress';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';
  static const String statusNoShow = 'No Show';

  // ── Common Status / State Labels ────────────────────────────────────────

  static const String loading = 'Loading...';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String noResults = 'No Results';
  static const String noInternet = 'No Internet Connection';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';

  // ── Empty State Messages ────────────────────────────────────────────────

  static const String emptyBookingsTitle = 'No Bookings Yet';
  static const String emptyBookingsSubtitle =
      'Your upcoming and past bookings will appear here once you schedule a wash.';

  static const String emptyChatTitle = 'No Messages';
  static const String emptyChatSubtitle =
      'Start a conversation with your washer or support team.';

  static const String emptyNotificationsTitle = 'All Caught Up!';
  static const String emptyNotificationsSubtitle =
      'You have no new notifications at the moment.';

  static const String emptySearchTitle = 'No Results Found';
  static const String emptySearchSubtitle =
      'Try adjusting your search or filters to find what you\'re looking for.';

  static const String emptyJobsTitle = 'No Jobs Available';
  static const String emptyJobsSubtitle =
      'New jobs will appear here when customers book a wash near you.';
}

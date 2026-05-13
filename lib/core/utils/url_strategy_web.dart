import 'package:flutter_web_plugins/url_strategy.dart';

/// Switches Flutter web from the default hash URLs (`#/customer/home`) to
/// path-based URLs (`/customer/home`). Required so deep links like
/// Xendit's success_redirect_url `/customer/bookings/<id>` resolve to the
/// actual screen instead of bouncing to the welcome page.
void configurePathUrlStrategy() => usePathUrlStrategy();

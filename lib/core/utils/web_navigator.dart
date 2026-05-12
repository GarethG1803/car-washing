/// Navigates the current browser tab on web; no-op on other platforms.
///
/// Uses conditional imports to avoid pulling `dart:html` / `package:web`
/// into non-web builds. Bypasses url_launcher entirely so MissingPlugin
/// exceptions are impossible.
export 'web_navigator_stub.dart'
    if (dart.library.html) 'web_navigator_html.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation: replaces the current page with the given URL.
/// Pure browser API call — no MethodChannel, no plugin, no popup.
void navigateCurrentTab(String url) {
  html.window.location.href = url;
}

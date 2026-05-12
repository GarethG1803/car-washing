/// Stub implementation for non-web platforms — never called because
/// callers gate on kIsWeb, but this satisfies the conditional import.
void navigateCurrentTab(String url) {
  throw UnsupportedError('navigateCurrentTab is web-only');
}

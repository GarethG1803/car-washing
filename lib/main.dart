import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/app.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/core/network/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Pre-load token from storage so the router redirect on first frame
  // sees the actual auth state (not null) — prevents deep links being
  // bounced to /login while the async storage read is in flight.
  final initialToken = await TokenStorage.read();

  runApp(
    ProviderScope(
      overrides: [
        tokenProvider.overrideWith((ref) => TokenNotifier.withInitial(initialToken)),
      ],
      child: const CleanRideApp(),
    ),
  );
}

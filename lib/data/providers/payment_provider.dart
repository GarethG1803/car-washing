import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

// Fetch current payment status for a completed order
final paymentStatusProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, orderId) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  try {
    final response = await dio.get('/payments/$orderId');
    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    }
  } catch (_) {}
  return null;
});

// Notifier that creates/retrieves a Xendit invoice and returns the URL
class PaymentNotifier extends StateNotifier<AsyncValue<String?>> {
  PaymentNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<String?> createInvoice(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post('/payments/$orderId');
      if (response.data['success'] == true) {
        final url =
            (response.data['data'] as Map<String, dynamic>)['invoice_url']
                as String?;
        state = AsyncValue.data(url);
        _ref.invalidate(paymentStatusProvider(orderId));
        return url;
      }
      final msg = response.data['message']?.toString() ?? 'Payment failed';
      state = AsyncValue.error(msg, StackTrace.current);
      return null;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final paymentNotifierProvider =
    StateNotifierProvider.family<PaymentNotifier, AsyncValue<String?>, String>(
  (ref, orderId) => PaymentNotifier(ref),
);

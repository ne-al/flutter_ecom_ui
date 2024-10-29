import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Future<Map> createOrder(
  double amount,
  String receipt,
  bool partialPayment,
  int firstPaymentMinAmount,
  Map<String, dynamic>? notes, {
  String currency = "INR",
}) async {
  await dotenv.load();

  const String url = 'https://api.razorpay.com/v1/orders';

  final String apiKey = dotenv.env['RAZOR_API_KEY'] ?? '';
  final String apiSecret = dotenv.env['RAZOR_SECRET_KEY'] ?? '';

  String basicAuth = 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';

  Map<String, String> headers = {
    'content-type': 'application/json',
    'authorization': basicAuth,
  };

  Map<String, dynamic> body = {
    'amount': amount,
    'currency': currency,
    'receipt': receipt,
    'partial_payment': partialPayment,
    'first_payment_min_amount': firstPaymentMinAmount,
    'notes': notes,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      Logger().e('Failed to create order: ${response.statusCode}');
      Logger().e('Response: ${response.body}');
    }
  } catch (e) {
    Logger().e('Error: $e');
  }
  return {};
}

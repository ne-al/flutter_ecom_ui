import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentHandler extends StatefulWidget {
  final Map orderData;
  final double amount;
  const PaymentHandler({
    super.key,
    required this.orderData,
    required this.amount,
  });

  @override
  State<PaymentHandler> createState() => _PaymentHandlerState();
}

class _PaymentHandlerState extends State<PaymentHandler> {
  final Razorpay _razorpay = Razorpay();
  bool isPaymentSuccess = false;
  bool isProcessingPayment = true;
  late PaymentSuccessResponse paymentSuccessResponse;
  late PaymentFailureResponse paymentFailureResponse;
  late ExternalWalletResponse externalWalletResponse;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _makePayment();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Box cartBox = Hive.box('CART');
    cartBox.clear();

    setState(() {
      isProcessingPayment = false;
      paymentSuccessResponse = response;
      isPaymentSuccess = true;
    });
    // Navigator.of(context, rootNavigator: true).pop();
    Logger().d(response.data);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    setState(() {
      paymentFailureResponse = response;
      isProcessingPayment = false;
      isPaymentSuccess = false;
    });
    Logger().d(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    setState(() {
      externalWalletResponse = response;
      isProcessingPayment = false;
      isPaymentSuccess = false;
    });
    Logger().d(response.walletName);
  }

  void _makePayment() {
    var options = {
      'key': dotenv.env["RAZOR_API_KEY"],
      'amount': widget.amount,
      'name': 'Acme Corp.',
      'order_id': widget.orderData['id'], // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60 * 10, // in seconds
      'prefill': {
        'contact': '9000090000',
        'email': 'gaurav.kumar@example.com',
      },
    };

    _razorpay.open(options);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isProcessingPayment
              ? const CircularProgressIndicator()
              : isPaymentSuccess
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 26,
                              horizontal: 26,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  "assets/lottie/success_1.json",
                                  repeat: false,
                                  width: 150,
                                  height: 140,
                                ),
                                Text(
                                  "Your order has been placed successfully!",
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Have a great day!",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                const Gap(12),
                                Text(
                                  "Payment Id: ${paymentSuccessResponse.paymentId}",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(26),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Done",
                                        style: GoogleFonts.lato(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text("Payment Failed"),
        ),
      ),
    );
  }
}

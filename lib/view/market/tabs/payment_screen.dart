import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentStatus = "Idle";

  // YooKassa payments endpoint.
  static const String endpoint = "https://api.yookassa.ru/v3/payments";

  // Replace with your actual Shop ID and Secret Key.
  static const String shopId = "1068820";
  static const String secretKey = "test_*gSu8R0-VZXm6L4w5RHg1mw5hD8g6qJ1aL6KAapC8mri0";

  // Build Basic Auth header.
  String get _basicAuth {
    final credentials = '$shopId:$secretKey';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  /// Initiates a payment request to YooKassa using Basic Auth.
  Future<void> _startPayment() async {
    const String amount = "100.00";
    const String currency = "RUB";
    const String description = "Payment for Order #12345";
    // Replace with your actual return URL (web page or deep link).
    const String returnUrl = "https://your-website-or-app-url";

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          HttpHeaders.authorizationHeader: _basicAuth,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "amount": {
            "value": amount,
            "currency": currency,
          },
          "confirmation": {
            "type": "redirect",
            "return_url": returnUrl,
          },
          "capture": true,
          "description": description,
        }),
      );

      // Check for success (HTTP 200 or 201).
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final String? paymentUrl = data['confirmation']?['confirmation_url'];

        if (paymentUrl != null) {
          setState(() {
            _paymentStatus = "Redirecting to payment page...";
          });
          print("Redirecting to: $paymentUrl");
          // Attempt to launch the payment URL.
          if (await canLaunch(paymentUrl)) {
            await launch(paymentUrl);
          } else {
            setState(() {
              _paymentStatus = "Error: Could not launch payment URL.";
            });
            print("Error: Could not launch payment URL.");
          }
        } else {
          setState(() {
            _paymentStatus = "Error: No confirmation URL found in response.";
          });
          print("Error: No confirmation URL found in response. Response: ${response.body}");
        }
      } else {
        setState(() {
          _paymentStatus = "Error ${response.statusCode}: ${response.body}";
        });
        print("Error ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      setState(() {
        _paymentStatus = "Payment Failed: $error";
      });
      print("Payment Failed: $error");
    }
  }

  /// Builds a card widget displaying the current payment status.
  Widget _buildPaymentStatusCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          _paymentStatus,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Builds the main UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YooKassa Payment'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentStatusCard(),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _startPayment,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text("Pay Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



///

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
//
// /// Main screen that initiates the payment process.
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   String _paymentStatus = "Idle";
//
//   // Replace these with your real credentials.
//   static const String shopId = "1068820";
//   static const String secretKey = "test_*gSu8R0-VZXm6L4w5RHg1mw5hD8g6qJ1aL6KAapC8mri0";
//   static const String endpoint = "https://api.yookassa.ru/v3/payments";
//
//   Future<void> _startPayment() async {
//     const String amount = "100.00";
//     const String currency = "RUB";
//     const String description = "Payment for Order #12345";
//
//     try {
//       final String basicAuth =
//           'Basic ' + base64Encode(utf8.encode('$shopId:$secretKey'));
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           HttpHeaders.authorizationHeader: basicAuth,
//           HttpHeaders.contentTypeHeader: "application/json",
//         },
//         body: jsonEncode({
//           "amount": {
//             "value": amount,
//             "currency": currency,
//           },
//           "confirmation": {
//             "type": "redirect",
//             "return_url": "https://your-website-or-app-url-here"
//           },
//           "capture": true,
//           "description": description
//         }),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final String? paymentUrl = data['confirmation']?['confirmation_url'];
//         if (paymentUrl != null) {
//           setState(() {
//             _paymentStatus = "Redirecting to payment page...";
//           });
//           if (await canLaunch(paymentUrl)) {
//             await launch(paymentUrl);
//           } else {
//             setState(() {
//               _paymentStatus = "Could not launch payment URL";
//             });
//           }
//         } else {
//           setState(() {
//             _paymentStatus = "No confirmation URL found.";
//           });
//         }
//       } else {
//         setState(() {
//           _paymentStatus = "Error ${response.statusCode}: ${response.body}";
//         });
//       }
//     } catch (error) {
//       setState(() {
//         _paymentStatus = "Payment Failed: $error";
//       });
//     }
//   }
//
//   /// A card widget to display the current payment status.
//   Widget _buildPaymentStatusCard() {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       margin: EdgeInsets.symmetric(horizontal: 24.0),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           _paymentStatus,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YooKassa Payment'),
//         centerTitle: true,
//         elevation: 2,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade50, Colors.blue.shade200],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildPaymentStatusCard(),
//               SizedBox(height: 32.0),
//               ElevatedButton(
//                 onPressed: _startPayment,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24.0),
//                   ),
//                   textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 child: Text("Pay Now"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// ///
//
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// //
// // class PaymentScreen extends StatefulWidget {
// //   @override
// //   _PaymentScreenState createState() => _PaymentScreenState();
// // }
// //
// // class _PaymentScreenState extends State<PaymentScreen> {
// //   String _paymentStatus = "Idle";
// //
// //   static const String secretKey = "test_*gSu8R0-...";
// //   static const String shopId = "1068820";
// //   static const String endpoint = "https://api.yookassa.ru/v3/payments";
// //
// //   Future<void> _startPayment() async {
// //     const String amount = "100.00";
// //     const String currency = "RUB";
// //     const String description = "Payment for Order #12345";
// //
// //     try {
// //       // Construct Basic Auth. Must encode "<shopId>:<secretKey>" in base64.
// //       final String basicAuth =
// //           'Basic ' + base64Encode(utf8.encode('$shopId:$secretKey'));
// //
// //       final response = await http.post(
// //         Uri.parse(endpoint),
// //         headers: {
// //           HttpHeaders.authorizationHeader: basicAuth,
// //           HttpHeaders.contentTypeHeader: "application/json",
// //         },
// //         body: jsonEncode({
// //           "amount": {
// //             "value": amount,
// //             "currency": currency,
// //           },
// //           "confirmation": {
// //             "type": "redirect",
// //             "return_url": "https://your-website-or-app-url-here"
// //           },
// //           "capture": true,
// //           "description": description
// //         }),
// //       );
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final data = jsonDecode(response.body);
// //         final String? paymentUrl = data['confirmation']?['confirmation_url'];
// //         if (paymentUrl != null) {
// //           setState(() {
// //             _paymentStatus = "Opening $paymentUrl...";
// //           });
// //           // You would use url_launcher to open this URL so the user can confirm payment.
// //           // ...
// //         } else {
// //           setState(() {
// //             _paymentStatus = "No confirmation URL found in response.";
// //           });
// //         }
// //       } else {
// //         setState(() {
// //           _paymentStatus =
// //           "Error ${response.statusCode}: ${response.reasonPhrase}";
// //         });
// //       }
// //     } catch (error) {
// //       setState(() {
// //         _paymentStatus = "Payment Failed: $error";
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('YooKassa Payment'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text('Status: $_paymentStatus'),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               child: Text('Pay Now'),
// //               onPressed: _startPayment,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//

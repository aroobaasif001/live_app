// import 'package:flutter/material.dart';
// import 'dart:async'; // For Timer
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:sociopro/constant.dart';
//
// class RealTimeSoldeDisplay extends StatefulWidget {
//   final double fontSize; // Parameter for font size
//   final Color color;
//
//   RealTimeSoldeDisplay({required this.fontSize, required this.color});
//   @override
//   _RealTimeSoldeDisplayState createState() => _RealTimeSoldeDisplayState();
// }
//
// class _RealTimeSoldeDisplayState extends State<RealTimeSoldeDisplay> {
//   int? currentSolde;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAndUpdateSolde(); // Fetch solde when widget initializes
//
//     // Set up periodic refresh every 5 seconds
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       fetchAndUpdateSolde();
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }
//
//   Future<void> fetchAndUpdateSolde() async {
//     final solde = await fetchUserSolde();
//     if (solde != null) {
//       setState(() {
//         currentSolde = solde; // Update the state with the fetched solde
//       });
//     }
//   }
//
//   Future<int?> fetchUserSolde() async {
//     try {
//       final sharedPreferences = await SharedPreferences.getInstance();
//       final token = sharedPreferences.getString('access_token');
//
//       if (token == null) {
//         print("No access token found.");
//         return null;
//       }
//
//       final response = await http.get(
//         Uri.parse('https://doctizol.ma/api/get_user'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['data']['solde']; // Extract solde from response
//       } else {
//         print("Failed to fetch user solde. Status code: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("An error occurred while fetching solde: $e");
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "$currentSolde",
//       style: TextStyle(color: widget.color,fontSize: widget.fontSize  , fontWeight: FontWeight.bold),
//     );
//   }
// }

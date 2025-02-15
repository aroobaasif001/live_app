// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lottie/lottie.dart';
//
// class RecentGiftsWidget extends StatefulWidget {
//   final String roomId;
//
//   const RecentGiftsWidget({super.key, required this.roomId});
//
//   @override
//   RecentGiftsWidgetState createState() => RecentGiftsWidgetState();
// }
//
// class RecentGiftsWidgetState extends State<RecentGiftsWidget>
//     with SingleTickerProviderStateMixin {
//   AnimationController? _controller;
//   Animation<double>? _fadeAnimation;
//
//   final Map<String, List<Map<String, dynamic>>> giftTabs = {
//     "Lucky": [
//       {
//         "imageUrl": "assets/gifts/L1.json",
//         "name": "Gift 1",
//         "price": 900,
//         "code": "SP001",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L2.json",
//         "name": "Gift 2",
//         "price": 900,
//         "code": "SP002",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L3.json",
//         "name": "Gift 3",
//         "price": 900,
//         "code": "SP003",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L4.json",
//         "name": "Gift 4",
//         "price": 900,
//         "code": "SP004",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L5.json",
//         "name": "Gift 5",
//         "price": 900,
//         "code": "SP005",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L6.json",
//         "name": "Gift 6",
//         "price": 900,
//         "code": "SP006",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L7.json",
//         "name": "Gift 7",
//         "price": 900,
//         "code": "SP007",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L8.json",
//         "name": "Gift 8",
//         "price": 900,
//         "code": "SP008",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L9.json",
//         "name": "Gift 9",
//         "price": 900,
//         "code": "SP009",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L10.json",
//         "name": "Gift 10",
//         "price": 900,
//         "code": "SP0010",
//         "diamonds": 45,
//       },
//       {
//         "imageUrl": "assets/gifts/L11.json",
//         "name": "Gift 11",
//         "price": 900,
//         "code": "SP0011",
//         "diamonds": 45,
//       },
//
//     ],
//
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('livestreams')
//           .doc(widget.roomId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const SizedBox.shrink();
//         }
//
//         var roomData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//         var recentGifts = roomData['recentGifts'] as List<dynamic>? ?? [];
//
//         if (recentGifts.isEmpty) {
//           return const SizedBox.shrink(); // No recent gifts to display
//         }
//
//         String giftCode = recentGifts.last;
//
//         // Start the fade animation
//         _controller?.forward(from: 0.0);
//
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: FadeTransition(
//               opacity: _fadeAnimation!,
//               child: _buildGiftAnimation(giftCode),
//             ),
//           ),
//         );
//       },
//     );
//
//   }
//
//   Widget _buildGiftAnimation(String giftCode) {
//     for (String category in giftTabs.keys) {
//       List<Map<String, dynamic>> gifts = giftTabs[category]!;
//
//       for (Map<String, dynamic> gift in gifts) {
//         if (gift['code'] == giftCode) {
//           return Lottie.asset(
//             gift['imageUrl'],
//             onLoaded: (composition) {
//               print("Lottie loaded: ${composition.duration}");
//             },
//           );
//         }
//       }
//     }
//
//     // Enhanced debug information
//     print("Gift code not found: $giftCode. Available codes: ${giftTabs.values.expand((gifts) => gifts.map((gift) => gift['code'])).toList()}");
//     return const Icon(
//       Icons.card_giftcard,
//       size: 100,
//       color: Colors.green,
//     );
//   }
//
//
// }

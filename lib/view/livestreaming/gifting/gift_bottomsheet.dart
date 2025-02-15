// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:sociopro/constant.dart';
//
// import '../../ads/recharge_bottomsheet.dart';
// import '../widgets/current_solde.dart';
//
// class GiftsBottomSheet extends StatefulWidget {
//   final String roomId;
//   final bool isBattleSatrted;
//
//   GiftsBottomSheet({required this.roomId, required this.isBattleSatrted});
//
//   @override
//   _GiftsBottomSheetState createState() => _GiftsBottomSheetState();
// }
//
// class _GiftsBottomSheetState extends State<GiftsBottomSheet>
//     with SingleTickerProviderStateMixin {
//   int selectedQuantity = 1;
//   int selectedGiftIndex = -1;
//   String? selectedRecipientUid;
//   List<Map<String, dynamic>> recipients = [];
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 9, vsync: this);
//     fetchRecipients();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   final Map<String, List<Map<String, dynamic>>> giftTabs = {
//     "Initial": [
//       {
//         "imageUrl": "assets/gifts/L3.json",
//         "name": "Gift 17",
//         "price": 8000,
//         "code": "LX001",
//         "diamonds": 400
//       },
//       {
//         "imageUrl": "assets/gifts/L4.json",
//         "name": "Gift 18",
//         "price": 8500,
//         "code": "LX002",
//         "diamonds": 425
//       },
//     ],
//     "Junior": [
//       {
//         "imageUrl": "assets/gifts/L1.json",
//         "name": "Gift 1",
//         "price": 500,
//         "code": "J001",
//         "diamonds": 25
//       },
//       {
//         "imageUrl": "assets/gifts/L2.json",
//         "name": "Gift 2",
//         "price": 700,
//         "code": "J002",
//         "diamonds": 35
//       },
//     ],
//     "Middle": [
//       {
//         "imageUrl": "assets/gifts/L3.json",
//         "name": "Gift 3",
//         "price": 1000,
//         "code": "M001",
//         "diamonds": 50
//       },
//       {
//         "imageUrl": "assets/gifts/L4.json",
//         "name": "Gift 4",
//         "price": 1500,
//         "code": "M002",
//         "diamonds": 75
//       },
//     ],
//     "Mature": [
//       {
//         "imageUrl": "assets/gifts/L5.json",
//         "name": "Gift 5",
//         "price": 2000,
//         "code": "MT001",
//         "diamonds": 100
//       },
//       {
//         "imageUrl": "assets/gifts/L6.json",
//         "name": "Gift 6",
//         "price": 2500,
//         "code": "MT002",
//         "diamonds": 125
//       },
//     ],
//     "Strong": [
//       {
//         "imageUrl": "assets/gifts/L7.json",
//         "name": "Gift 7",
//         "price": 3000,
//         "code": "S001",
//         "diamonds": 150
//       },
//       {
//         "imageUrl": "assets/gifts/L8.json",
//         "name": "Gift 8",
//         "price": 3500,
//         "code": "S002",
//         "diamonds": 175
//       },
//     ],
//     "Versed": [
//       {
//         "imageUrl": "assets/gifts/L9.json",
//         "name": "Gift 9",
//         "price": 4000,
//         "code": "V001",
//         "diamonds": 200
//       },
//       {
//         "imageUrl": "assets/gifts/L1.json",
//         "name": "Gift 10",
//         "price": 4500,
//         "code": "V002",
//         "diamonds": 225
//       },
//     ],
//     "Genius": [
//       {
//         "imageUrl": "assets/gifts/L10.json",
//         "name": "Gift 11",
//         "price": 5000,
//         "code": "G001",
//         "diamonds": 250
//       },
//       {
//         "imageUrl": "assets/gifts/L5.json",
//         "name": "Gift 12",
//         "price": 5500,
//         "code": "G002",
//         "diamonds": 275
//       },
//     ],
//     "Premium": [
//       {
//         "imageUrl": "assets/gifts/L8.json",
//         "name": "Gift 13",
//         "price": 6000,
//         "code": "P001",
//         "diamonds": 300
//       },
//       {
//         "imageUrl": "assets/gifts/L4.json",
//         "name": "Gift 14",
//         "price": 6500,
//         "code": "P002",
//         "diamonds": 325
//       },
//     ],
//     "Diamond": [
//       {
//         "imageUrl": "assets/gifts/L7.json",
//         "name": "Gift 15",
//         "price": 7000,
//         "code": "D001",
//         "diamonds": 350
//       },
//       {
//         "imageUrl": "assets/gifts/L6.json",
//         "name": "Gift 16",
//         "price": 7500,
//         "code": "D002",
//         "diamonds": 375
//       },
//     ],
//   };
//
//   Future<void> fetchRecipients() async {
//     final liveStreamDoc =
//         FirebaseFirestore.instance.collection('livestreams').doc(widget.roomId);
//
//     try {
//       final List<Map<String, dynamic>> tempRecipients = [];
//
//       // Fetch admin details
//       final adminSnapshot = await liveStreamDoc.get();
//       if (adminSnapshot.exists) {
//         final adminData = adminSnapshot.data()!;
//         tempRecipients.add({
//           'uid': adminData['adminUid'].toString(), // Ensure uid is a String
//           'name': adminData['adminName'],
//           'photo': adminData['adminPhoto'],
//         });
//       }
//
//       // Fetch cohosts
//       final cohostsSnapshot = await liveStreamDoc.collection('cohosts').get();
//       for (var cohostDoc in cohostsSnapshot.docs) {
//         tempRecipients.add({
//           'uid': cohostDoc['uid'].toString(), // Ensure uid is a String
//           'name': cohostDoc['name'],
//           'photo': cohostDoc['photo'],
//         });
//       }
//
//       if (tempRecipients.isNotEmpty) {
//         setState(() {
//           recipients = tempRecipients;
//           selectedRecipientUid =
//               recipients[0]['uid']; // Default to the first recipient
//         });
//       }
//     } catch (e) {
//       print('Error fetching recipients: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.8),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       height: Get.height * 0.6,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Display Admin and Co-Hosts
//           if (recipients.isNotEmpty)
//             SizedBox(
//               height: 60,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: recipients.length,
//                 itemBuilder: (context, index) {
//                   final recipient = recipients[index];
//                   final isSelected = recipient['uid'] == selectedRecipientUid;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedRecipientUid = recipient['uid'];
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(recipient['photo']),
//                             radius: isSelected ? 22 : 18,
//                             backgroundColor: Colors.white.withOpacity(0.2),
//                           ),
//                           SizedBox(height: 5),
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? ColorPiker.IconColor
//                                   : Colors.transparent,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//           const SizedBox(height: 10),
//           Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
//           const SizedBox(height: 10),
//
//           // **TabBar Section with Glassmorphism Effect**
//           ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // More blur for depth
//               child: Container(
//                   alignment: Alignment.centerLeft, // Align it to the start
//
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.1),
//                       Colors.white.withOpacity(0.05),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.2),
//                     width: 1.5, // Slightly bolder border
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: ColorPiker.IconColor.withOpacity(0.3), // Subtle neon glow
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//                 child: TabBar(
//                   controller: _tabController,
//                   isScrollable: true,
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorPiker.IconColor.withOpacity(0.6),
//                         Colors.deepOrange.withOpacity(0.6),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: ColorPiker.IconColor.withOpacity(0.5),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.white70,
//                   labelStyle: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Poppins',
//                   ),
//                   tabs: giftTabs.keys.map((tab) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding
//                       child: Tab(
//                         text: tab,
//                       ),
//                     );
//                   }).toList(),
//                 )
//
//
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // **Gift Grid UI**
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: giftTabs.keys.map((tab) {
//                 var giftItems = giftTabs[tab]!;
//                 return GridView.builder(
//                   padding: const EdgeInsets.all(8),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 2,
//                     childAspectRatio: 0.75,
//                   ),
//                   itemCount: giftItems.length,
//                   itemBuilder: (context, index) {
//                     var gift = giftItems[index];
//                     final isSelected = selectedGiftIndex == index;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedGiftIndex = index;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: isSelected
//                                 ? ColorPiker.IconColor
//                                 : Colors.transparent,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                           color: Colors.white.withOpacity(0.1),
//                           boxShadow: isSelected
//                               ? [
//                                   BoxShadow(
//                                     color:
//                                         ColorPiker.IconColor.withOpacity(0.4),
//                                     blurRadius: 12,
//                                     spreadRadius: 2,
//                                   )
//                                 ]
//                               : [],
//                         ),
//                         padding: EdgeInsets.all(8),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Lottie.asset(
//                               gift['imageUrl'],
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.contain,
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               gift['name'],
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 0, horizontal: 6),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 '${gift['price']} coins',
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // **Bottom Bar**
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // **Real-Time Balance Display**
//               Row(
//                 children: [
//                   Image.asset(
//                     'assets/icons/live_recharge.png',
//                     height: 30.r,
//                   ),                  const SizedBox(width: 6),
//                   RealTimeSoldeDisplay(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//
//                 ],
//               ),
//
//               // **Send Button with Glassmorphism**
//               Row(
//                 children: [
//
//
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           backgroundColor: ColorPiker.IconColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                         ),
//                         onPressed: () async {
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             builder: (BuildContext context) {
//                               return const RechargeBottomSheet();
//                             },
//                           );
//                         },
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               'assets/icons/live_recharge.png',
//                               height: 20.r,
//                             ),
//                             SizedBox(
//                               width: 2,
//                             ),
//                             Text(
//                               'Recharge',
//                               style:                               const TextStyle(color: Colors.white, fontSize: 16),
//
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
// SizedBox(width: 10,),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           backgroundColor: ColorPiker.IconColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (selectedGiftIndex == -1 ||
//                               selectedRecipientUid == null) {
//                             Get.snackbar(
//                               "Error",
//                               "Please select a gift and a recipient.",
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                             return;
//                           }
//                           var currentTab = _tabController.index;
//                           var tabNames = ["Initial" , 'Junior' , 'Middle' , 'Mature' , 'Strong' , 'Versed' ,'Premium' , 'Diamond'];
//                           var selectedGift =
//                               giftTabs[tabNames[currentTab]]![selectedGiftIndex];
//                           int giftPrice = selectedGift['price'];
//                           String giftName = selectedGift['name'];
//                           String giftCode = selectedGift['code'];
//                           int diamonds =
//                               selectedGift['diamonds'] * selectedQuantity;
//                           final userSolde = await fetchUserSolde();
//                           if (userSolde == null) {
//                             Get.snackbar(
//                               "Error",
//                               "Unable to fetch user balance. Please try again.",
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                             return;
//                           }
//                           final totalCost = giftPrice * selectedQuantity;
//                           if (userSolde < totalCost) {
//                             Get.snackbar(
//                               "Low Balance",
//                               "You do not have enough balance to send this gift.",
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                             return;
//                           }
//                           final deductionSuccessful =
//                               await updateUserSolde(-totalCost);
//                           if (!deductionSuccessful) {
//                             Get.snackbar(
//                               "Error",
//                               "Failed to deduct solde. Please try again.",
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                             return;
//                           }
//                           Get.back();
//                           await FirebaseFirestore.instance
//                               .collection('livestreams')
//                               .doc(widget.roomId)
//                               .collection('gifts')
//                               .add({
//                             'giftName': giftName,
//                             'giftPrice': giftPrice,
//                             'quantity': selectedQuantity,
//                             'recipientUid': selectedRecipientUid,
//                             'diamonds': diamonds,
//                             'timestamp': FieldValue.serverTimestamp(),
//                           });
//                           if (widget.isBattleSatrted) {
//                             final battleDoc = FirebaseFirestore.instance
//                                 .collection('livestreams')
//                                 .doc(widget.roomId)
//                                 .collection('battles')
//                                 .doc('currentBattle');
//                             await FirebaseFirestore.instance
//                                 .runTransaction((transaction) async {
//                               final snapshot = await transaction.get(battleDoc);
//                               if (!snapshot.exists) return;
//                               final data = snapshot.data()!;
//                               if (selectedRecipientUid ==
//                                   data['participants'][0]['uid']) {
//                                 transaction.update(battleDoc, {
//                                   'adminScore': FieldValue.increment(diamonds)
//                                 });
//                               } else {
//                                 transaction.update(battleDoc, {
//                                   'cohostScore': FieldValue.increment(diamonds)
//                                 });
//                               }
//                             });
//                           }
//                           await FirebaseFirestore.instance
//                               .collection('livestreams')
//                               .doc(widget.roomId)
//                               .update({
//                             'recentGifts': FieldValue.arrayUnion([giftCode]),
//                           });
//                           Future.delayed(const Duration(seconds: 3), () async {
//                             await FirebaseFirestore.instance
//                                 .collection('livestreams')
//                                 .doc(widget.roomId)
//                                 .update({
//                               'recentGifts': FieldValue.arrayRemove([giftCode]),
//                             });
//                           });
//                         },
//                         child: Text(
//                           'send'.tr,
//                           style:
//                               const TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<int?> fetchUserSolde() async {
//     try {
//       // Fetch access token from SharedPreferences
//       final sharedPreferences = await SharedPreferences.getInstance();
//       final token = sharedPreferences.getString('access_token');
//
//       if (token == null) {
//         print("No access token found.");
//         return null;
//       }
//
//       // Send GET request to fetch user data
//       final response = await http.get(
//         Uri.parse('https://doctizol.ma/api/get_user'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print("Response status code: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         // Extract 'solde' from the 'data' key
//         if (data.containsKey('data') && data['data']['solde'] != null) {
//           return data['data']['solde'];
//         } else {
//           print(
//               "Solde not found in the nested 'data' object: ${response.body}");
//           return null;
//         }
//       } else {
//         print("Failed to fetch user data. Status code: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("An error occurred while fetching user solde: $e");
//       return null;
//     }
//   }
//
//   Future<bool> updateUserSolde(int soldeChange) async {
//     try {
//       final sharedPreferences = await SharedPreferences.getInstance();
//       final token = sharedPreferences.getString('access_token');
//
//       if (token == null) {
//         print("No access token found.");
//         return false;
//       }
//
//       final url = Uri.parse('https://doctizol.ma/api/add_solde');
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(
//             {'solde': soldeChange}), // Pass negative value for deduction
//       );
//
//       if (response.statusCode == 200) {
//         print("User solde updated successfully.");
//         return true;
//       } else {
//         print("Failed to update solde. Status code: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print("An error occurred while updating solde: $e");
//       return false;
//     }
//   }
// }

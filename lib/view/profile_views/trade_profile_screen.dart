import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/profile_views/edit_trade_profile.dart';
import '../../custom_widgets/custom_text.dart';

class TradeProfileScreen extends StatelessWidget {
  // List of options for bottom section
  final List<Map<String, dynamic>> bottomOptions = [
    {"icon": Icons.attach_money, "title": "Tips"},
    {"icon": Icons.local_shipping, "title": "Delivery"},
    {"icon": Icons.analytics, "title": "Analytics"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Matching background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Profile Section with Background Image
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(companyProfileBackgroundImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => EditTradeProfile());
                              },
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 24)),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 37.5,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.apple,
                                size: 40, color: Colors.black),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "usernickname",
                                fontFamily: "Gilroy-Bold",
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              CustomText(
                                text: "Name Surname",
                                fontFamily: "Gilroy-Bold",
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 5),
                              const CustomText(
                                text: "95K Subscribers  •  132 Subscriptions",
                                fontSize: 12,
                                color: Colors.white70,
                                fontFamily: "Gilroy-Bold",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Statistics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: profileStatBox('4.7', 'Rating')),
                    verticalDivider(),
                    Expanded(child: profileStatBox('33.8K', 'Reviews')),
                    verticalDivider(),
                    Expanded(child: profileStatBox('169.7K', 'Sold out')),
                    verticalDivider(),
                    Expanded(child: profileStatBox('+2d.', 'Delivery')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      actionBox(Icons.shopping_bag, 'Goods'),
                      const SizedBox(width: 10),
                      actionBox(Icons.stream, 'Streams'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      actionBox(Icons.account_balance_wallet, 'Wallet'),
                      const SizedBox(width: 10),
                      actionBox(Icons.list_alt, 'Orders', badgeCount: 1),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Invite Friends Section
            inviteFriendBox(),
            const SizedBox(height: 10),

            // Bottom ListTiles (Generated from list)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(bottomOptions.length, (index) {
                  return optionTile(bottomOptions[index]["icon"],
                      bottomOptions[index]["title"]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for profile statistics
  Widget profileStatBox(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: "Gilroy-Bold",
        ),
        const SizedBox(height: 2),
        CustomText(
          text: label,
          fontSize: 12,
          color: Colors.grey,
          fontFamily: "Gilroy-Bold",
        ),
      ],
    );
  }

  // Vertical Divider
  Widget verticalDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  // Action Buttons
  Widget actionBox(IconData icon, String title, {int badgeCount = 0}) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: Colors.black),
                  const SizedBox(height: 5),
                  CustomText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gilroy-Bold",
                  ),
                ],
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 10,
                right: 15,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: CustomText(
                    text: badgeCount.toString(),
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Invite Friend Box
  Widget inviteFriendBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Invite a friend and get up to 10,000 ₽',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Gilroy-Bold",
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: 'Balance: 0 ₽',
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: "Gilroy-Bold",
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // Option Tile
  Widget optionTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: CustomText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Gilroy-Bold",
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

///

// import 'package:flutter/material.dart';
// import 'package:live_app/utils/images_path.dart';
// import '../../custom_widgets/custom_text.dart';
//
// class TradeProfileScreen extends StatelessWidget {
//   // List for the bottom options
//   final List<String> bottomOptions = ["Tips", "Delivery", "Analytics"];
//   final List<IconData> bottomIcons = [
//     Icons.attach_money,
//     Icons.local_shipping,
//     Icons.analytics];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100], // Matching background color
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top Profile Section with Background Image
//             Stack(
//               children: [
//                 Container(
//                   height: 220,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(companyProfileBackgroundImage),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Icon(Icons.arrow_back, color: Colors.white, size: 24),
//                           Icon(Icons.edit, color: Colors.white, size: 24),
//                         ],
//                       ),
//                       const SizedBox(height: 50),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 37.5,
//                             backgroundColor: Colors.white,
//                             child: Icon(Icons.apple,
//                                 size: 40, color: Colors.black),
//                           ),
//                           const SizedBox(width: 12),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const CustomText(
//                                 text: "usernickname",
//                                 fontFamily: "Gilroy-Bold",
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                               CustomText(
//                                 text: "Name Surname",
//                                 fontFamily: "Gilroy-Bold",
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14,
//                                 color: Colors.grey.shade400,
//                               ),
//                               const SizedBox(height: 5),
//                               const CustomText(
//                                 text: "95K Subscribers  •  132 Subscriptions",
//                                 fontSize: 12,
//                                 color: Colors.white70,
//                                 fontFamily: "Gilroy-Bold",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Statistics Row
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(child: profileStatBox('4.7', 'Rating')),
//                     verticalDivider(),
//                     Expanded(child: profileStatBox('33.8K', 'Reviews')),
//                     verticalDivider(),
//                     Expanded(child: profileStatBox('169.7K', 'Sold out')),
//                     verticalDivider(),
//                     Expanded(child: profileStatBox('+2d.', 'Delivery')),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Action Buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       actionBox(Icons.shopping_bag, 'Goods'),
//                       const SizedBox(width: 10),
//                       actionBox(Icons.stream, 'Streams'),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       actionBox(Icons.account_balance_wallet, 'Wallet'),
//                       const SizedBox(width: 10),
//                       actionBox(Icons.list_alt, 'Orders', badgeCount: 1),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Invite Friends Section
//             inviteFriendBox(),
//             const SizedBox(height: 10),
//
//             // Bottom ListTiles (Generated from a list)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   optionTile(bottomIcons[0], bottomOptions[0]),
//                   optionTile(bottomIcons[1], bottomOptions[1]),
//                   optionTile(bottomIcons[2], bottomOptions[2]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for profile statistics
//   Widget profileStatBox(String value, String label) {
//     return Column(
//       children: [
//         CustomText(
//           text: value,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           fontFamily: "Gilroy-Bold",
//         ),
//         const SizedBox(height: 2),
//         CustomText(
//           text: label,
//           fontSize: 12,
//           color: Colors.grey,
//           fontFamily: "Gilroy-Bold",
//         ),
//       ],
//     );
//   }
//
//   // Vertical Divider
//   Widget verticalDivider() {
//     return Container(
//       width: 1,
//       height: 30,
//       color: Colors.grey.shade300,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
//
//   // Action Buttons
//   Widget actionBox(IconData icon, String title, {int badgeCount = 0}) {
//     return Expanded(
//       child: Container(
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(color: Colors.black12, blurRadius: 5),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: 28, color: Colors.black),
//                   const SizedBox(height: 5),
//                   CustomText(
//                     text: title,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Gilroy-Bold",
//                   ),
//                 ],
//               ),
//             ),
//             if (badgeCount > 0)
//               Positioned(
//                 top: 10,
//                 right: 15,
//                 child: Container(
//                   width: 16,
//                   height: 16,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                   child: CustomText(
//                     text: badgeCount.toString(),
//                     fontSize: 10,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Invite Friend Box
//   Widget inviteFriendBox() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(color: Colors.black12, blurRadius: 5),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: 'Invite a friend and get up to 10,000 ₽',
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: "Gilroy-Bold",
//                 ),
//                 const SizedBox(height: 4),
//                 CustomText(
//                   text: 'Balance: 0 ₽',
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontFamily: "Gilroy-Bold",
//                 ),
//               ],
//             ),
//             const Icon(Icons.chevron_right, color: Colors.black),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Option Tile
//   Widget optionTile(IconData icon, String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.black),
//         title: CustomText(
//           text: title,
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           fontFamily: "Gilroy-Bold",
//         ),
//         trailing: const Icon(Icons.chevron_right, color: Colors.black),
//         tileColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }

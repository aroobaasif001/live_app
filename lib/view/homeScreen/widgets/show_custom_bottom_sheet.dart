import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/liveShoppingScreens/supportSellerScreen/support_seller_screen.dart';
import 'package:live_app/view/homeScreen/paymentMethodScreen/reward_screen.dart';
import 'package:live_app/view/homeScreen/widgets/show_payment_bottom_sheet.dart';

void showCustomBottomSheet(BuildContext context,
    {required String companyName,
    required double rating,
    required IconData profileIcon,
    required List<Map<String, dynamic>> actions}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),

            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(profileIcon, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(companyName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.black, size: 16),
                          SizedBox(width: 5),
                          Text(rating.toString(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 80,
                    height: 30,
                    child: CustomGradientButton(
                      text: 'Subscribe',
                      onPressed: () {
                        Get.back();
                        showPaymentBottomSheet(context);
                      },
                      fontSize: 12,
                    ))
              ],
            ),

            SizedBox(height: 20),
            Divider(),

            // Dynamic List of Menu Items
            ...actions.map((action) {
              return _buildMenuItem(
                icon: action["icon"],
                text: action["text"],
                onTap: action["onTap"], // Passing onTap dynamically
              );
            }).toList(),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

// **Reusable Menu Item with onTap Support**
Widget _buildMenuItem({
  required String icon,
  required String text,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Image.asset(icon, width: 24, height: 24),
    title: Text(text, style: TextStyle(fontSize: 16)),
    onTap: onTap, // Assign the callback to onTap event
  );
}

void showSendRewardBottomSheet(BuildContext context) {
  bool isNoteEnabled = false;
  TextEditingController noteController = TextEditingController();
  int? selectedAmount;

  List<Map<String, dynamic>> rewards = [
    {"emoji": "👋", "amount": 50},
    {"emoji": "😊", "amount": 100},
    {"emoji": "😀", "amount": 200},
    {"emoji": "🥰", "amount": 500},
    {"emoji": "😎", "amount": 1000},
    {"emoji": "🤑", "amount": 5000},
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        CustomText(
                          text: 'Send reward',
                          fontFamily: 'Gilroy-Bold',
                          fontSize: 16,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, size: screenWidth * 0.06),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Image.asset('assets/icons/money.png'),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select reward amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045),
                      ),
                    ),

                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "The recipient will receive 100% of these tips.",
                        style: TextStyle(
                            fontSize: screenWidth * 0.035, color: Colors.grey),
                      ),
                    ),

                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = screenWidth > 600
                            ? 4
                            : 3; // Adjust grid for large screens
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: rewards.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAmount = rewards[index]["amount"];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedAmount ==
                                              rewards[index]["amount"]
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(rewards[index]["emoji"],
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.05)),
                                      Text("${rewards[index]["amount"]} ₽",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 15),

                    // Add a Thank You Note Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add a thank you note",
                            style: TextStyle(fontSize: screenWidth * 0.04)),
                        Switch(
                          value: isNoteEnabled,
                          onChanged: (value) {
                            setState(() {
                              isNoteEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),

                    // Thank You Note Input Field
                    if (isNoteEnabled)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: TextField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write something here...",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: CustomGradientButton(
                        text: "Continue",
                        onPressed: () {
                          Get.to(()=>SupportSellerScreen());
                         // _showSubscribeBottomSheet(context);

                        },
                        fontSize: screenWidth * 0.045,
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showSubscribeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/appleg.png', height: 50),
            SizedBox(height: 10),
            CustomText(
              text: "Subscribe to this seller!",
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.w900,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            CustomText(
                text:
                    "Did you like what you saw? Follow the news companies_name, to get notified when they go live!",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                textAlign: TextAlign.center,
                fontFamily: 'Gilroy-Bold'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Not now"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: CustomGradientButton(
                    text: 'Subscribe',
                    onPressed: () {
                      _showAuctionWinnerBottomSheet(context);
                      Get.to(() => RewardsScreen());
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _showAuctionWinnerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/icons/profilewin.png'),
              radius: 40,
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'user nick name',
              fontWeight: FontWeight.w900,
              fontSize: 24,
              fontFamily: 'SF Pro Rounded',
            ),
            SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: "won the",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff60C0FF),
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w900),
                children: [
                  TextSpan(
                    text: " auction!",
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: <Color>[Color(0xff60C0FF), Color(0xffE356D7)],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(),
          ],
        ),
      );
    },
  );
}

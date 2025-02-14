import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/utils/images_path.dart';

import '../../../custom_widgets/custom_text.dart';
import 'show_custom_bottom_sheet.dart';

void showPaymentBottomSheet(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text("Add payment information",
                style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: "Card number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "MM / YY",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "CVC",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delivery address, postal code",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text("Russia, Moscow, st. Arbat, 1, 25, 109144",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomGradientButton(
                text: 'Save map',
                onPressed: () {
                  Get.back();
                  showWalletBottomSheet(context);
                }),
          ],
        ),
      );
    },
  );
}

void showWalletBottomSheet1(BuildContext context) {
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
            Text("Wallet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            SizedBox(height: 15),
            _buildWalletItem1(
              icon: Icons.local_shipping,
              text: "109155, Moscow, Ryazansky pr-kt, 58/2, 193",
              onEdit: () {},
            ),

            SizedBox(height: 10),
            _buildWalletItem1(
              icon: Icons.credit_card,
              text: "MIR **2882",
              onEdit: () {},
            ),

            SizedBox(height: 20),
            _buildPromoCodeField1(context),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _buildWalletItem1(
    {required IconData icon,
    required String text,
    required VoidCallback onEdit}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.black),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      IconButton(
        icon: Icon(Icons.edit, color: Colors.black),
        onPressed: onEdit,
      ),
    ],
  );
}

Widget _buildPromoCodeField1(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: "Promo code",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          showPaymentInfoBottomSheet(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Apply", style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}

void showWalletBottomSheet(BuildContext context) {
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

            // Title
            Text("Wallet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            SizedBox(height: 15),

            _buildWalletItem(
              icon: Icons.local_shipping,
              title: "Add delivery address",
              subtitle: "Used to send you your purchases by mail",
              buttonText: "Add",
              onButtonPressed: () {
                print("Button Pressed! Closing First Sheet...");

                Get.back(); // Close the first bottom sheet

                Future.delayed(Duration(milliseconds: 200), () {
                  print("Opening New Bottom Sheet :::::::::::::::");
                  showWalletBottomSheet1(context);
                });
              },
            ),

            SizedBox(height: 10),

            // Add a Map Section
            _buildWalletItem(
              icon: Icons.credit_card,
              title: "Add a map",
              subtitle: "Used to pay for your purchases",
              buttonText: "Add",
              onButtonPressed: () {},
            ),

            SizedBox(height: 20),

            _buildPromoCodeField(),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _buildWalletItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required String buttonText,
  required VoidCallback onButtonPressed,
}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.black),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      SizedBox(
          width: 80,
          height: 35,
          child: CustomGradientButton(
              text: buttonText, onPressed: onButtonPressed))
    ],
  );
}

Widget _buildPromoCodeField() {
  return Row(
    children: [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: "Promo code",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          // Handle apply button
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Apply", style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}

void showPaymentInfoBottomSheet(BuildContext context) {
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
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            CustomText(text:
              "To buy from lives, we need your payment and shipping information",
              textAlign: TextAlign.center,
             fontWeight: FontWeight.w900, fontSize: 18,
             fontFamily: 'SF Pro Rounded',
            ),
            SizedBox(height: 10),
            CustomText(text: 
              "Welcome to Grab! To participate in auctions, you must provide a payment method and delivery address. All bids and purchases are final.",
              textAlign: TextAlign.center,
              fontFamily: 'Gilroy-Bold',
             fontSize: 14, color: Colors.black87,
            ),
            SizedBox(height: 10),
            CustomText(text: 
              "You will not be charged until you purchase the item.",
              textAlign: TextAlign.center,
              
                  fontSize: 14,
                  color: Color(0xff815BFF),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy-Bold',
            ),
            SizedBox(height: 20),
            CustomGradientButton(
                text: 'Add Information',
                onPressed: () {
                
                  showInviteFriendBottomSheet(context);
                }),
            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

void showInviteFriendBottomSheet(BuildContext context) {
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
       
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),

            CustomText(text: 
            
              "Friends in live",
              fontFamily: 'Gilroy-Bold',
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400, fontSize: 16,
            ),

            SizedBox(height: 20),
           Image.asset('assets/icons/friend.png'),

            SizedBox(height: 10),
            CustomText(text: 
              "There's no one yet!",
             fontWeight: FontWeight.w900, fontSize: 20,
             fontFamily: 'SF Pro Rounded',
            ),

            SizedBox(height: 5),
            CustomText(text: 
              "None of your friends are on this air. When they join, you will see them here.",
              fontFamily: 'Gilroy-Bold',
              textAlign: TextAlign.center,
             fontSize: 14, color: Colors.black54,
            ),

            SizedBox(height: 20),
            CustomGradientButton(
                text: 'Invite Friends',
                onPressed: () {
                  showFriendsInLiveBottomSheet(
                    context,
                    friends: [
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "on_broadcast"
                      },
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "invite"
                      },
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "invite"
                      },
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "invite"
                      },
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "invite"
                      },
                      {
                        "name": "nickname25",
                        "image": applegImage,
                        "status": "disabled"
                      },
                    ],
                  );
                }),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

void showFriendsInLiveBottomSheet(BuildContext context,
    {required List<Map<String, String>> friends}) {
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

            // Title
            Text(
              "Friends in live",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            SizedBox(height: 10),

            // Friends List
            ListView.builder(
              
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: friends.length,
              
              itemBuilder: (context, index) {
                
                return _buildFriendItem(
                  name: friends[index]["name"]!,
                  image: friends[index]["image"]!,
                  status: friends[index]["status"]!,
                );
              },
            ),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _buildFriendItem(
    {required String name, required String image, required String status}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(image),
            ),
            if (status == "on_broadcast")
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.green,
                ),
              ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
                fontSize: 14,
                fontWeight:
                    status == "disabled" ? FontWeight.normal : FontWeight.bold,
                color: status == "disabled" ? Colors.grey : Colors.black),
          ),
        ),
        if (status == "on_broadcast")
          _buildStatusTag("On broadcast", Colors.grey.shade300),
        if (status == "invite") _buildInviteButton("Invite"),
        if (status == "disabled") _buildDisabledButton(),
      ],
    ),
  );
}

// **Reusable Invite Button**
Widget _buildInviteButton(String text) {
  return SizedBox(
    width: 80,
    height: 35,
    child: CustomGradientButton(text: 'Invite', onPressed: (){
      
    }));
}

// **Reusable Status Tag**
Widget _buildStatusTag(String text, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child:
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

// **Disabled Button Placeholder**
Widget _buildDisabledButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text("Invite", style: TextStyle(color: Colors.grey)),
  );
}

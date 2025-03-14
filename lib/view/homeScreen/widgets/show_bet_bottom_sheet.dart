import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../livestreaming/controller/livestreaming_controller.dart';

void showBetBottomSheet(BuildContext context, double minimumBid , String name , String photo , String channelId , String prodId , ) {
  final TextEditingController bidController = TextEditingController();
  double bidAmount = 0;

  // Assign default values to avoid non-nullable error


  final LiveStreamController _controller = Get.put(LiveStreamController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: 'Place your bet', fontSize: 24,
              fontWeight: FontWeight.w800,fontFamily: 'SF Pro Rounded',),

            SizedBox(height: 10),
            CustomText(text: 'You enter the maximum bet for participation (1 BOX) in the GREAT STREAM GAME 35.000 ₽ NINTENDO SWITCH, PLAYSTATION, XBOX) SWAP THE STACK. If you enter a maximum bid, we will automatically bid for you, up to that amount, when this auction goes live.', fontSize: 12,
              fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',
              color: Color(0xff2A2A2A),
              textAlign: TextAlign.center,),

            SizedBox(height: 10),
            CustomText(text: 'Someone else will win at the moment for 100 ₽', fontSize: 12,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',),

            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: 'Maximum bet', fontSize: 12,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',),
            ),

            SizedBox(height: 5),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a bet of at least $minimumBid ₽",
              ),
              onChanged: (value) {
                bidAmount = double.tryParse(value) ?? 0.0; // Ensure it's a valid double or 0
              },
              onSubmitted: (value) {
                // Handle logic when user finishes entering the bid
                if (bidAmount < minimumBid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('The bid must be at least $minimumBid ₽'),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 15),

            CustomGradientButton(
              text: 'Place a bid',
              onPressed: () async {
                // Validate the bid amount
                if (bidAmount < minimumBid || bidAmount == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('The bid must be at least $minimumBid ₽'),
                    ),
                  );
                } else {
                  // Get user information
                  _controller.sendBidMessage(name, photo, channelId , 'Set Bid of $bidAmount' , bidAmount, prodId, FirebaseAuth.instance.currentUser!.uid); // Send the data

                  Get.back();
                }
              },
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'Bids are final. You can increase them at any time, but you cannot decrease or cancel them.',
              fontSize: 12,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy-Bold',
            ),
            CustomText(
              text: 'How does the maximum bet work?',
              fontSize: 12,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy-Bold',
              color: Color(0xff815BFF),
            ),
          ],
        ),
      );
    },
  );
}


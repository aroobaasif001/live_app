import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';

void showUserAgreementBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome to the first stream!",
                style: TextStyle(
                  fontFamily: 'SFProRounded',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff2a2a2a),
                ),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Before you begin, please read the user agreement",
                style: GoogleFonts.montserratAlternates(fontSize: 14,fontWeight: FontWeight.w400)
              
              ),
            ),
            SizedBox(height: 15),
            _buildAgreementItem("Bets are binding and cannot be cancelled."),
            _buildAgreementItem("Always use a valid payment method to maintain your rating."),
            _buildAgreementItem("Grab it! provides protection if your purchase does not go as expected."),
            _buildAgreementItem(
              "You agree with ",
              extraText: "rules",
              extraColor: Color(0xff815bff),
              secondExtraText: "conditions of our community",
            ),

            SizedBox(height: 20),
            CustomGradientButton(text: 'Agree', onPressed: (){
             Get.back();
            }),

            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Back",
                style: TextStyle(fontSize: 14, color: Color(0xff815bff), fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _buildAgreementItem(String text, {String? extraText, Color? extraColor, String? secondExtraText}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: Colors.black, size: 22),
        SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400,
              fontFamily: 'SF Pro Rounded',
              ),
              children: [
                TextSpan(text: text),
                if (extraText != null)
                  TextSpan(text: extraText, style: TextStyle(color: extraColor ?? Colors.blue, fontWeight: FontWeight.bold)),
                if (secondExtraText != null)
                  TextSpan(text: "\n And ", style: TextStyle(color: Colors.black)),
                if (secondExtraText != null)
                  TextSpan(text: secondExtraText, style: TextStyle(color: Color(0xff815bff), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

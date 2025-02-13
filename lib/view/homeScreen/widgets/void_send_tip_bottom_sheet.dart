import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/icons_path.dart';

import 'show_refer_friend_bottom_sheet.dart';

void showSendTipBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      CustomText(
                        text: "Send a tip",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Gilroy-Bold',
                      ),
                        Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        alignment: Alignment.topRight,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Image.asset(money, height: 60),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            _buildTipDetailRow("Tip amount", "50 ₽",isBold: true),
            _buildPaymentOption(context),
            _buildTipDetailRow("Subtotal", "50 ₽"),
            _buildTipDetailRowWithInfo("Payment processing fee", "14 ₽"),
            _buildTipDetailRow("Total", "64 ₽", isBold: true),
            _buildTermsAndConditions(),
            _buildContinueButton(context),
          ],
        ),
      );
    },
  );
}

Widget _buildTipDetailRow(String title, String amount, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: 
          title,
          
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            fontFamily: 'Gilroy-Bold',
          
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTipDetailRowWithInfo(String title, String amount) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(width: 4),
            Icon(Icons.info_outline, size: 16, color: Colors.grey),
          ],
        ),
        Text(
          amount,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}

Widget _buildPaymentOption(BuildContext context) {
  return GestureDetector(
    onTap: () {
      
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Payment",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Row(
            children: [
              Text(
                "By card **2882",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTermsAndConditions() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Text(
          "Tips are non-refundable.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to tipping conditions
          },
          child: Text(
            "Tipping conditions",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}

Widget _buildContinueButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: CustomGradientButton(text: 'Continue',onPressed: (){
      showReferFriendBottomSheet(context);
    },)
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/utils/icons_path.dart';

import '../../../custom_widgets/custom_text.dart';

void showReferFriendBottomSheet(BuildContext context) {
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
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildBenefits(),
              _buildReferralLink(context),
              SizedBox(height: 10,),
             CustomGradientButton(text: 'Share inviation'),
              _buildFooter(),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      Image.asset(referfriendIcon, height: 80),
      SizedBox(height: 10),
      
      CustomText( text: 
        "Refer a friend, earn up to\n10,000 ₽",
        textAlign: TextAlign.center,
        fontFamily: 'SF Pro Rounded',
      fontSize: 22, fontWeight: FontWeight.w800,

      ),
      SizedBox(height: 10),
    ],
  );
}

Widget _buildBenefits() {
  return Column(
    children: [
      _buildBenefitItem("Invite friends", "Your friend receives a random amount between 100 ₽ and 2000 ₽"),
      _buildBenefitItem("Get rewards", "You will receive the corresponding amount if a friend makes their first purchase"),
      _buildBenefitItem("No restrictions", "The more friends you invite, the more you earn"),
      SizedBox(height: 10),
    ],
  );
}

Widget _buildBenefitItem(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child:ListTile(
      leading:Image.asset(wadeMoneyIcon) ,
      title:  CustomText(text:title, fontWeight: FontWeight.bold,fontFamily: 'Gilroy-Bold',fontSize: 16,),
      subtitle: CustomText(text:description, fontSize: 14, color: Colors.black54,fontFamily: 'Gilroy-Bold'),
    )
  );
}

Widget _buildReferralLink(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
          child: Text(
            "grabit.com/invite/754623",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: "grabit.com/invite/754623"));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to clipboard!")));
        },
        child: Text("Copy"),
      ),
    ],
  );
}



Widget _buildFooter() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text:"Earned: 300 ₽", fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to View Rules
          },
          child: CustomText(text: 
            "View rules",
            fontSize: 14, fontWeight:FontWeight.w400,fontFamily: 'Gilroy-Bold'
          ),
        ),
      ],
    ),
  );
}

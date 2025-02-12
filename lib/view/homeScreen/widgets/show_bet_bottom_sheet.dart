import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

void showBetBottomSheet(BuildContext context) {
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
              child:CustomText(text: 'Maximum bet', fontSize: 12,
             textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',) ,
              ),
            
            
            SizedBox(height: 5),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                
                border: OutlineInputBorder(
                  
                ),
                hintText: "Enter a bet of at least 200 ₽",
              ),
            ),
            SizedBox(height: 15),
      
          CustomGradientButton(text: 'Place a bid', onPressed: (){}),
            SizedBox(height: 10),
            CustomText(text: 'Bids are final. You can increase them at any time, but you cannot decrease or cancel them.', fontSize: 12,
             textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',),
            CustomText(text: 'How does the maximum bet work?', fontSize: 12,
             textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',
                color: Color(0xff815BFF),),
          
          ],
        ),
      );
    },
  );
}

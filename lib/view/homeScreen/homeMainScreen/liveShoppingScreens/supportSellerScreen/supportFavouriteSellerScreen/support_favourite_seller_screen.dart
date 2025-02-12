import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/icons_path.dart';

import '../../../../widgets/void_send_tip_bottom_sheet.dart';

class SupportFavouriteSellerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
       
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70, bottom: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/sellerbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: 
                    Center(child: Column(
                      children: [
                        Image.asset(money, height: 60),
                        SizedBox(height: 40,)
                      ],
                    )),
                   
                  
                
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomText(text: 'Support your favorite sellers with tips',
                    fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xff2a2a2a),
                    fontFamily: 'SF Pro Rounded',
                    ),
             SizedBox(height: 20,),
                    TipBenefitItem(icon: wadeMoneyIcon, text: 'Sellers keep 100% of the tip amount you choose'),
                    SizedBox(height: 10,),
                    TipBenefitItem(icon: HeartIcon, text: 'Tipping is never required, but it is a great way to show appreciation.'),
                     SizedBox(height: 10,),
                    TipBenefitItem(icon: mchatIcon, text: 'We\'ll let you know in chat every time you tip a seller.'),
                     SizedBox(height: 10,),
                    TipBenefitItem(icon: dollarIcon, text: 'The bank may charge a small fee per transaction.'),
                  ],
                ),
              ),
              Spacer(),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
               child: CustomGradientButton(text: 'Continue',onPressed: (){
                showSendTipBottomSheet(context);
               },),
             )
            ],
          ),
        ],
      ),
    );
  }
}

class TipBenefitItem extends StatelessWidget {
  final String icon;
  final String text;
  
  TipBenefitItem({required this.icon, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon,height: 24,width: 24,),
         
          SizedBox(width: 10),
          Expanded(
            child: 
            CustomText(text: text,fontSize: 14,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',)
          ),
        ],
      ),
    );
  }
}

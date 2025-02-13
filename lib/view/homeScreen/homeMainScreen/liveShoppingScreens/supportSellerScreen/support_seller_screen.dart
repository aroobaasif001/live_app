import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

import '../../../widgets/show_payment_method_bottomsheet.dart';

class SupportSellerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/sellerbg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset('assets/icons/money.png')),
                      SizedBox(height: 10),
                      CustomText(
                        text: 'Support the seller',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        text:
                            'To show your appreciation to the host, you can support him by promoting this stream or giving a tip.',
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Gilroy-Bold',
                        color: Colors.white,
                        fontSize: 14,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Image.asset('assets/icons/support.png'),
              title: CustomText(
                text: 'Community support',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy-Bold',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                text:
                    'Community support is currently unavailable for this broadcast.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy-Bold',
              ),
            ),
              SizedBox(height: 10,),
            Divider(
              color: Color(0xfff3f3f3),
            ),
            SizedBox(height: 10,),
             ListTile(
              leading: Image.asset('assets/icons/support.png'),
              title: CustomText(
                text: 'Send a tip',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy-Bold',
              ),
            ),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                text:
                    'Express your appreciation to the seller quickly and reliably.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy-Bold',
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                 Container(
                  
                  decoration: BoxDecoration(
                    color: Color(0xffEEEEEE),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    
                    padding: const EdgeInsets.all(16.0),
                    
                    child: CustomText(text: 'Find out more',fontFamily: 'Gilroy-Bold',),
                  ),
                 ),
                  SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width*0.5,
                  child: CustomGradientButton(text: 'Send a tip',onPressed: (){
                    showPaymentMethodBottomSheet(context);
                  },),
                )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 

}

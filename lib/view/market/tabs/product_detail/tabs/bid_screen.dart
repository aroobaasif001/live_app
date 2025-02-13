import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class BidScreen extends StatelessWidget {
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Place Your Bid',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Enter the maximum bid amount for participation (1 BOX) in the GRAND GAME STREAM 35,000 ₽ NINTENDO SWITCH, PLAYSTATION, XBOX). If you enter the maximum bid, we will automatically place bids for you up to this amount when the auction starts.',
                fontSize: 14,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              CustomText(
                text: 'Someone else is currently winning at 100 ₽',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 15),
              CustomText(
                text: 'Maximum Bid',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              CustomText(
                text: 'Enter at least 200 ₽',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: priceController,
                  hintText: '200 ₽',
                 keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              CustomGradientButton(
                text: 'Place Bid',
                onPressed: () {
                  _showSuccessDialog(context);
                  Future.delayed(Duration(milliseconds: 3000),() {
                    Get.back();
                  },);

                },
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'Bids are final. You can increase them at any time, but you cannot decrease or cancel them.',
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: CustomText(
                    text: 'How does the maximum bid work?',
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                height: 60,
                width: 60,
                image: DecorationImage(
                    image: AssetImage(checkWithCircleIcon),
                ),
              ),
              SizedBox(height: 10),
              CustomText(
                text: 'Bid 1000 ₽',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              GradientText(
                  'Successfully Placed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                  colors: [
                blueLiteColor, purpleLiteColor,deepPurpleColor
              ])
            ],
          ),
        );
      },
    );
  }
}
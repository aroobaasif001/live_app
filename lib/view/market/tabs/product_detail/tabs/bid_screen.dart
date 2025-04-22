import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class BidScreen extends StatefulWidget {
  @override
  State<BidScreen> createState() => _BidScreenState();
}

class _BidScreenState extends State<BidScreen> {
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: 'Place Your Bid',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: () {
                      Get.back();
                    }, icon: Icon(Icons.close,color: Colors.red,)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomText(
              text:
              'Enter the maximum bid amount for participation (1 BOX) in the GRAND GAME STREAM 35,000 ₽ NINTENDO SWITCH, PLAYSTATION, XBOX). If you enter the maximum bid, we will automatically place bids for you up to this amount when the auction starts.',
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
            // CustomText(
            //   text: 'Maximum Bid',
            //   fontSize: 16,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.black,
            // ),
            // CustomText(
            //   text: 'Enter at least 200 ₽',
            //   fontSize: 16,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.black,
            // ),
            // SizedBox(height: 10),
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
              },
            ),
            SizedBox(height: 20),
            CustomText(
              text:
              'Bids are final. You can increase them at any time, but you cannot decrease or cancel them.',
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              CustomText(
                                text: 'How Maximum Bid Works',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 10),

                              /// Description
                              CustomText(
                                text:
                                'When you set a maximum bid, the system will automatically place incremental bids on your behalf until your maximum is reached. You can increase the maximum at any time.',
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              const SizedBox(height: 20),

                              /// OK Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: CustomText(
                                    text: 'Got it',
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:Colors.white ,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close_outlined,
                    )),
              ),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              GradientText('Successfully Placed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  colors: [blueLiteColor, purpleLiteColor, deepPurpleColor]),
              SizedBox(height: 10),
              CustomText(
                text: "We'll send you a notification if you're outbid",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
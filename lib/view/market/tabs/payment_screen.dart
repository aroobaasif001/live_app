import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_pay_background.dart';
import 'package:live_app/custom_widgets/custom_radio_tile.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/icons_path.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedOption = "MIR **2882";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPayBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: CustomText(
                      text: 'to_pay'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: CustomText(
                      text: 'amount'.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomText(
                    text: 'delivery_address'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CustomContainer(
                        height: 40,
                        width: 40,
                        image: DecorationImage(image: AssetImage(deliveryIcon)),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomText(
                          text: 'address_details'.tr,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: 'payment_method'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  // Radio buttons with onChanged
                  CustomRadioTile(
                    imagePath: payIcon1,
                    title: 'mir_card'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon2,
                    title: 'sber_pay'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon3,
                    title: 'you_money'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon4,
                    title: 'sbp'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon5,
                    title: 't_pay'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon1,
                    title: 'new_card'.tr,
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Payment Button
                  CustomGradientButton(
                    text: 'pay'.tr,
                    onPressed: () {
                      // Implement payment action here
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

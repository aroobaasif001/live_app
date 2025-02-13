import 'package:flutter/material.dart';
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
                      text: 'To pay',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: CustomText(
                      text: '100,000 ₽',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomText(
                    text: 'Delivery address',
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
                          text: '109155, Moscow, Ryazansky Prospekt, 58/2, 193',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Payment method',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  // Radio buttons with onChanged
                  CustomRadioTile(
                    imagePath: payIcon1,
                    title: 'Mir **2882',
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon2,
                    title: 'Sber Pay',
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon3,
                    title: 'YouMoney',
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon4,
                    title: 'SBP',
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon5,
                    title: 'T-Pay',
                    selectedOption: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  CustomRadioTile(
                    imagePath: payIcon1,
                    title: 'New Card',
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
                    text: 'Pay',
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

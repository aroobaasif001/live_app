import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/auth/interests_screen.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Delivery Address',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Skip action
            },
            child: Row(
              children: [
                CustomText(
                  text: 'Skip',
                  fontSize: 16,
                  color: blackLiteColor,
                ),
                Icon(Icons.keyboard_double_arrow_right_rounded),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Country dropdown
              CustomTextField(
                hintText: 'Russia',
                suffixIcon: Icon(Icons.lock,color: greyLiteColor),
              ),
              SizedBox(height: 20),
              // City field
              CustomTextField(hintText: 'City'),
              SizedBox(height: 20),
              // Street field
              CustomTextField(hintText: 'Street'),
              SizedBox(height: 20),
              // House and Apartment fields
              Row(
                children: [
                  Expanded(child: CustomTextField(hintText: 'House')),
                  SizedBox(width: 10),
                  Expanded(child: CustomTextField(hintText: 'Apartment')),
                ],
              ),
              SizedBox(height: 20),
              // Entrance and Index fields
              Row(
                children: [
                  Expanded(child: CustomTextField(hintText: 'Entrance')),
                  SizedBox(width: 10),
                  Expanded(child: CustomTextField(hintText: 'Index')),
                ],
              ),
              SizedBox(height: 20),
              // Fill automatically
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Fill automatically action
                  },
                  icon: Icon(Icons.location_on, color: purpleColor1),
                  label: CustomText(
                    text: 'Fill automatically',
                    fontSize: 16,
                    color: purpleColor1,
                  ),
                ),
              ),
              Spacer(),
              // Continue button
              CustomGradientButton(
                text: 'Continue',
                onPressed: () {
                  Get.to(()=> InterestsScreen());
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 
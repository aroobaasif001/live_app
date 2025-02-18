import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/auth/interests_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final String? country;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? isSignUpWithGoogle;

  const DeliveryAddressScreen({
    super.key,
    this.gender,
    this.country,
    this.isSignUpWithGoogle,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
  });

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _countryController.text = widget.country ?? ''; // Pre-fill country
  }

  void _continueToNextScreen() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Get.to(() => InterestsScreen(
      country: widget.country,
      gender: widget.gender,
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      password: widget.password,
      city: _cityController.text.trim(),
      street: _streetController.text.trim(),
      house: _houseController.text.trim(),
      apartment: _apartmentController.text.trim(),
      entrance: _entranceController.text.trim(),
      index: _indexController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              _continueToNextScreen(); // Skip and continue
            },
            child: Row(
              children: [
                CustomText(
                  text: 'Skip',
                  fontSize: 16,
                  color: blackLiteColor,
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _countryController,
                          hintText: 'Country',
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your country' : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'City',
                          controller: _cityController,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your city' : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Street',
                          controller: _streetController,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your street' : null,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'House',
                                controller: _houseController,
                                validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Apartment',
                                controller: _apartmentController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Entrance',
                                controller: _entranceController,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Index',
                                controller: _indexController,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter your index' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              // Auto-fill logic here
                            },
                            icon: Icon(Icons.location_on, color: purpleColor1),
                            label: CustomText(
                              text: 'Fill automatically',
                              fontSize: 16,
                              color: purpleColor1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'Continue',
                  onPressed: _continueToNextScreen,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/custom_widgets/custom_textfield.dart';
// import 'package:live_app/utils/colors.dart';
// import 'package:live_app/view/auth/interests_screen.dart';
//
// class DeliveryAddressScreen extends StatefulWidget {
//   final String? country;
//   final String? gender;
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? password;
//
//   const DeliveryAddressScreen({
//     super.key,
//     this.gender,
//     this.country,
//     this.email,
//     this.firstName,
//     this.lastName,
//     this.password,
//   });
//
//   @override
//   State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
// }
//
// class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _streetController = TextEditingController();
//   final TextEditingController _houseController = TextEditingController();
//   final TextEditingController _apartmentController = TextEditingController();
//   final TextEditingController _entranceController = TextEditingController();
//   final TextEditingController _indexController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _countryController.text = widget.country ?? ''; // Pre-fill country
//   }
//
//   void _continueToNextScreen() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     Get.to(() => InterestsScreen(
//       country: widget.country,
//       gender: widget.gender,
//       firstName: widget.firstName,
//       lastName: widget.lastName,
//       email: widget.email,
//       password: widget.password,
//       city: _cityController.text.trim(),
//       street: _streetController.text.trim(),
//       house: _houseController.text.trim(),
//       apartment: _apartmentController.text.trim(),
//       entrance: _entranceController.text.trim(),
//       index: _indexController.text.trim(),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: CustomText(
//           text: 'Delivery Address',
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'SFProRounded',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _continueToNextScreen(); // Skip and continue
//             },
//             child: Row(
//               children: [
//                 CustomText(
//                   text: 'Skip',
//                   fontSize: 16,
//                   color: blackLiteColor,
//                 ),
//                 Icon(Icons.arrow_forward_ios),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                   CustomTextField(
//                     controller: _countryController,
//                     hintText: 'Country',
//                     validator: (value) =>
//                     value!.isEmpty ? 'Please enter your country' : null,
//                   ),
//                   SizedBox(height: 20),
//                   CustomTextField(
//                     hintText: 'City',
//                     controller: _cityController,
//                     validator: (value) =>
//                     value!.isEmpty ? 'Please enter your city' : null,
//                   ),
//                   SizedBox(height: 20),
//                   CustomTextField(
//                     hintText: 'Street',
//                     controller: _streetController,
//                     validator: (value) =>
//                     value!.isEmpty ? 'Please enter your street' : null,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           hintText: 'House',
//                           controller: _houseController,
//                           validator: (value) =>
//                           value!.isEmpty ? 'Required' : null,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: CustomTextField(
//                           hintText: 'Apartment',
//                           controller: _apartmentController,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           hintText: 'Entrance',
//                           controller: _entranceController,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: CustomTextField(
//                           hintText: 'Index',
//                           controller: _indexController,
//                           validator: (value) =>
//                           value!.isEmpty ? 'Please enter your index' : null,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: TextButton.icon(
//                       onPressed: () {
//                         // Auto-fill logic here
//                       },
//                       icon: Icon(Icons.location_on, color: purpleColor1),
//                       label: CustomText(
//                         text: 'Fill automatically',
//                         fontSize: 16,
//                         color: purpleColor1,
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   CustomGradientButton(
//                     text: 'Continue',
//                     onPressed: _continueToNextScreen,
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

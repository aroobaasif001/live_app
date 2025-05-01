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
      isSignUpWithGoogle:widget.isSignUpWithGoogle!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
           backgroundColor: Colors.grey[100],
        title: CustomText(
          text: 'delivery_address'.tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          TextButton(
            onPressed: () {
            //  _continueToNextScreen();
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
                isSignUpWithGoogle:widget.isSignUpWithGoogle!,
              ));
            },
            child: Row(
              children: [
                CustomText(
                  text: 'skip'.tr,
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
                          hintText: 'country'.tr,
                          readOnly: true,
                          validator: (value) =>

                              value!.isEmpty ? 'enter_country'.tr : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'city'.tr,
                          controller: _cityController,
                          validator: (value) =>
                              value!.isEmpty ? 'enter_city'.tr : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'street'.tr,
                          controller: _streetController,
                          validator: (value) =>
                              value!.isEmpty ? 'enter_street'.tr : null,
                        ),
                        SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: CustomTextField(
                        //         hintText: 'house'.tr,
                        //         controller: _houseController,
                        //         validator: (value) =>
                        //             value!.isEmpty ? 'required'.tr : null,
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     Expanded(
                        //       child: CustomTextField(
                        //         hintText: 'apartment'.tr,
                        //         controller: _apartmentController,
                        //          validator: (value) =>
                        //             value!.isEmpty ? 'required'.tr : null,
                           
                              
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: CustomTextField(
                        //         hintText: 'entrance'.tr,
                        //         controller: _entranceController,
                        //           validator: (value) =>
                        //             value!.isEmpty ? 'enter_index'.tr : null,
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     Expanded(
                        //       child: CustomTextField(
                        //         hintText: 'index'.tr,
                        //         controller: _indexController,
                        //         validator: (value) =>
                        //             value!.isEmpty ? 'enter_index'.tr : null,
                        //       ),
                        //     ),
                        //   ],
                        // ),

Row(
  crossAxisAlignment: CrossAxisAlignment.start, // 👈 ensures alignment at top
  children: [
    Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 8), // consistent spacing
        child: CustomTextField(
          hintText: 'house'.tr,
          controller: _houseController,
          validator: (value) =>
              value!.isEmpty ? 'enter_house'.tr : null,
        ),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: CustomTextField(
          hintText: 'apartment'.tr,
          controller: _apartmentController,
          // validator: (value) =>
          //     value!.isEmpty ? 'enter_apartment'.tr : null,
        ),
      ),
                            ),
  ],
),

SizedBox(height: 20),
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: CustomTextField(
          hintText: 'entrance'.tr,
          controller: _entranceController,
          // validator: (value) =>
          //     value!.isEmpty ? 'enter_entrance'.tr : null,
        ),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: CustomTextField(
          hintText: 'index'.tr,
          controller: _indexController,
          validator: (value) =>
              value!.isEmpty ? 'enter_index'.tr : null,
        ),
      ),
    ),
  ],
),

                        SizedBox(height: 20),
                        // Center(
                        //   child: TextButton.icon(
                        //     onPressed: () {
                        //       // Auto-fill logic here
                        //     },
                        //     icon: Icon(Icons.location_on, color: purpleColor1),
                        //     label: CustomText(
                        //       text: 'fill_automatically'.tr,
                        //       fontSize: 16,
                        //       color: purpleColor1,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'save'.tr,
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
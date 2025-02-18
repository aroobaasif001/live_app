import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? isSignUpWithGoogle;

  const RegistrationScreen({
    super.key,
    this.firstName,
    this.password,
    this.isSignUpWithGoogle,
    this.lastName,
    this.email,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String? country;
  String? gender;
  bool isAgreedToTerms = false;
  bool isAbove18 = false;
  late bool isSignUpWithGoogle;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.lastName ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    isSignUpWithGoogle = widget.isSignUpWithGoogle ?? false;
    _passwordController = TextEditingController(text: widget.password ?? '');
  }



  void _storeUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isAgreedToTerms || !isAbove18) {
      Get.snackbar("Error", "accept_terms_age".tr,snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.to(() => DeliveryAddressScreen(
            country: country,
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            gender: gender,
            password: _passwordController.text.trim(),
          ));
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'register'.tr,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Get.back(),
              tooltip: 'close'.tr,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'first_name'.tr,
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_first_name'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'last_name'.tr,
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_last_name'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'email'.tr,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_email'.tr;
                    }
                    if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value)) {
                      return 'invalid_email'.tr;
                    }
                    return null;
                  },
                ),
                isSignUpWithGoogle == false
                    ? SizedBox(height: 20)
                    : SizedBox(),
               isSignUpWithGoogle == false
                    ? CustomTextField(
                 hintText: 'password'.tr,
                        controller: _passwordController,
                        isPassword: true, // ✅ Enables visibility toggle
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter_password'.tr;
                          }
                          if (value.length < 6) {
                            return 'password_length'.tr;
                          }
                          return null;
                        },
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: InputDecoration(
                    hintText: 'select_gender'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: [
                    'male'.tr,
                    'female'.tr,
                    'other'.tr,
                  ].map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  )).toList(),
                  onChanged: (value) => setState(() => gender = value),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: country,
                  decoration: InputDecoration(
                    hintText: 'select_country'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: [
                    'russia'.tr,
                    'usa'.tr,
                    'india'.tr,
                  ].map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  )).toList(),
                  onChanged: (value) => setState(() => country = value),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAgreedToTerms,
                      onChanged: (value) => setState(() => isAgreedToTerms = value!),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'agree_terms'.tr,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isAbove18,
                      onChanged: (value) => setState(() => isAbove18 = value!),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'confirm_age'.tr,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'continue'.tr,
                  onPressed: _storeUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

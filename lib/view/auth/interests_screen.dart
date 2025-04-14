import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/interests_detail_screen.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../utils/colors.dart';
import '../../utils/store_services.dart';

class InterestsScreen extends StatefulWidget {
  final String? country;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? city;
  final String? street;
  final String? house;
  final String? apartment;
  final String? entrance;
  final String? index;
  final bool isSignUpWithGoogle; // non-nullable

  const InterestsScreen({
    super.key,
    this.country,
    this.gender,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.city,
    this.street,
    this.house,
    this.apartment,
    this.entrance,
    this.index,
    this.isSignUpWithGoogle = false,
  });

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  @override
  void initState() {
    super.initState();
    print("User signup with Google account: ${widget.isSignUpWithGoogle}");
  }

  final List<String> interestImages = [
    clothImage,
    shoesImage,
    hearPodImage,
    gymImage,
    manImage,
    lipstickImage,
    watchImage,
    darazImage,
    catImage,
    tireImage,
    gameImage,
    babyImage,
    booksImage,
    dagaImage
  ];

  final List<String> interestKeys = [
    'Clothes',
    'shoes',
    'electronics',
    'sport',
    'toys',
    'beauty',
    'accessories',
    'furniture',
    'pet_supplies',
    'automotive',
    'video_games',
    'for_children',
    'books',
    'hobby',
  ];

  final Set<int> selectedIndices = {};
  final List<String> selectedInterests = [];
  bool isLoading = false;

  void _toggleInterest(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
        selectedInterests.remove(interestKeys[index].tr);
      } else {
        selectedIndices.add(index);
        selectedInterests.add(interestKeys[index].tr);
      }
    });
  }

  void _registerUser() async {
    if (selectedInterests.isEmpty) {
      Get.snackbar(
        "error".tr,
        "select_interest".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purple,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isSignUpWithGoogle) {
        // Google registration: Use current Firebase user.
        String docId = FirebaseAuth.instance.currentUser!.uid;
        RegistrationEntity registrationEntity = RegistrationEntity(
          regId: docId,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          gender: widget.gender,
          country: widget.country,
          city: widget.city,
          street: widget.street,
          house: widget.house,
          apartment: widget.apartment,
          entrance: widget.entrance,
          index: widget.index,
          interests: selectedInterests,
          detailedInterests: [],
          image: null,
          coverImage: "",
          delivery: "",
          rating: "",
          reviews: "",
          sold: "",
          isBlocked: false,
          isUserNew: true,
        );

        await RegistrationEntity.doc(userId: docId).set(registrationEntity);

        Get.snackbar(
          "success".tr,
          "registration_success".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => InterestsDetailScreen(
          country: widget.country,
          gender: widget.gender,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          password: widget.password,
          city: widget.city,
          street: widget.street,
          house: widget.house,
          apartment: widget.apartment,
          entrance: widget.entrance,
          index: widget.index,
          interests: selectedInterests,
        ));
        await StorageService.setLoggedIn(true);
      } else {
        // Email registration: Create account.
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email!.trim(),
          password: widget.password!.trim(),
        );

        String docId = userCredential.user!.uid;
        RegistrationEntity registrationEntity = RegistrationEntity(
          regId: docId,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          gender: widget.gender,
          country: widget.country,
          city: widget.city,
          street: widget.street,
          house: widget.house,
          apartment: widget.apartment,
          entrance: widget.entrance,
          index: widget.index,
          interests: selectedInterests,
          detailedInterests: [],
          isBlocked: false,
          isUserNew: true,
        );

        await RegistrationEntity.doc(userId: docId).set(registrationEntity);

        Get.snackbar(
          "success".tr,
          "registration_success".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => InterestsDetailScreen(
          country: widget.country,
          gender: widget.gender,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          password: widget.password,
          city: widget.city,
          street: widget.street,
          house: widget.house,
          apartment: widget.apartment,
          entrance: widget.entrance,
          index: widget.index,
          interests: selectedInterests,
        ));
        await StorageService.setLoggedIn(true);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        "error".tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'back'.tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'interests_title'.tr,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'interests_subtitle'.tr,
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ResponsiveGridListBuilder(
                  minItemWidth: 1,
                  minItemsPerRow: 3,
                  maxItemsPerRow: 3,
                  horizontalGridSpacing: 12.h,
                  verticalGridSpacing: 12.h,
                  builder: (context, items) => ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    children: items,
                  ),
                  gridItems: List.generate(interestImages.length, (index) {
                    final isSelected = selectedIndices.contains(index);
                    return GestureDetector(
                      onTap: () => _toggleInterest(index),
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                          border: isSelected
                              ? Border.all(
                            width: 0.1,
                            color: Colors.transparent,
                          )
                              : Border.all(color: Colors.white, width: 2),
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [
                              blueLiteColor,
                              purpleLiteColor,
                              deepPurpleColor
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                        ),
                        child: Padding(
                          padding: isSelected
                              ? const EdgeInsets.all(1.5)
                              : EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: CustomText(
                                    text: interestKeys[index].tr,
                                    fontSize: 12.sp,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'SFProRounded',
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage(interestImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              CustomGradientButton(
                text: isLoading ? "registering".tr : "continue".tr,
                onPressed: isLoading ? null : _registerUser,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


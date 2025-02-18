import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/interests_detail_screen.dart';
import '../../utils/colors.dart';

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
  final bool? isSignUpWithGoogle;

  const InterestsScreen({
    super.key,
    this.country,
    this.isSignUpWithGoogle,
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
  });

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
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

  final List<String> interestNames = [
    'Cloth',
    'Shoes',
    'Electronics',
    'Bags',
    'Sport',
    'Toys',
    'Beauty',
    'Accessories',
    'Furniture',
    'Pet Supplies',
    'Automotive products',
    'Video Games',
    'For children',
    'Books',
    'Hobby',
  ];

  final Set<int> selectedIndices = {};
  final List<String> selectedInterests = [];

  bool isLoading = false;

  void _toggleInterest(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
        selectedInterests.remove(interestNames[index]);
      } else {
        selectedIndices.add(index);
        selectedInterests.add(interestNames[index]);
      }
    });
  }

  void _registerUser() async {
    if (selectedInterests.isEmpty) {
      Get.snackbar("Error", "Please select at least one interest.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      if(widget.isSignUpWithGoogle == true){
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
          image: "",
          coverImage: "",
          delivery: "",
          rating: "",
          reviews: "",
          sold: "",
        );

        await RegistrationEntity.doc(userId: docId).set(registrationEntity);

        Get.snackbar("Success", "Registration completed successfully!");
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
      }
      else{
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
        );

        await RegistrationEntity.doc(userId: docId).set(registrationEntity);

        Get.snackbar("Success", "Registration completed successfully!");
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
      }



    } catch (e) {
      Get.snackbar("Error", e.toString());
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
          text: 'Back',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'What are you interested in?',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Select a few to get started',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(interestImages.length, (index) {
                    final isSelected = selectedIndices.contains(index);
                    return GestureDetector(
                      onTap: () => _toggleInterest(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                            colors: [blueLiteColor, purpleLiteColor, deepPurpleColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                        ),
                        child: Padding(
                          padding: isSelected ? const EdgeInsets.all(2.5) : EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomText(
                                  text: interestNames[index],
                                  fontSize: 14,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomContainer(
                                  height: 50,
                                  width: 50,
                                  image: DecorationImage(
                                    image: AssetImage(interestImages[index]),
                                    fit: BoxFit.fill,
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
                text: isLoading ? "Registering..." : "Continue",
                onPressed: isLoading ? () {} : _registerUser, // ✅ FIXED
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


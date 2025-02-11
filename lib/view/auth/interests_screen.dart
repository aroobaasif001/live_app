import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/interests_detail_screen.dart';

import '../../utils/colors.dart';

class InterestsScreen extends StatefulWidget {
  InterestsScreen({super.key});

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
              /// Title
              CustomText(
                text: 'What are you interested in?',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              const SizedBox(height: 8),

              /// Subtitle
              CustomText(
                text: 'Select a few to get started',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              const SizedBox(height: 20),

              /// Interests Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(interestImages.length, (index) {
                    final isSelected = selectedIndices.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndices.remove(index);
                          } else {
                            selectedIndices.add(index);
                          }
                        });
                      },
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
                            color: Colors.transparent, // Transparent to use gradient
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
                          padding: isSelected ? const EdgeInsets.all(2.5) : EdgeInsets.zero, // ✅ Avoids cutting edges
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
                                    image: AssetImage(interestImages[index]),fit: BoxFit.fill
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

              /// Continue Button
              CustomGradientButton(
                text: 'Continue',
                onPressed: () {
                  Get.to(() => InterestsDetailScreen());
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

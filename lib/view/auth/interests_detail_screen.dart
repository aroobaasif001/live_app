import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';

class InterestsDetailScreen extends StatefulWidget {
  InterestsDetailScreen({super.key});

  @override
  _InterestsDetailScreenState createState() => _InterestsDetailScreenState();
}

class _InterestsDetailScreenState extends State<InterestsDetailScreen> {
  final Map<String, List<String>> interests = {
    'Shoes': ['Sneakers', 'Trainers', 'Boots', 'Sandals'],
    'Electronics': [
      'Smartphones',
      'Headphones',
      'Computers',
      'Tablets',
      'Cameras',
      'Speakers',
      'Monitors'
    ],
    'Beauty': [
      'Skincare',
      'Makeup',
      'Fragrances',
      'Haircare',
      'Nail Care',
      'Tools',
      'Accessories'
    ],
  };

  final Set<String> selectedItems = {};

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
        actions: [
          GestureDetector(
            onTap: () {
              // Skip action
            },
            child: Row(
              children: [
                CustomText(
                  text: 'Skip',
                  fontSize: 16,
                  color: Colors.black,
                ),
                Icon(Icons.keyboard_double_arrow_right_rounded),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              CustomText(
                text: 'Tell us a little more',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 8),
              // Subtitle
              CustomText(
                text: 'Choose what interests you',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              SizedBox(height: 20),
              // Interests list
              Expanded(
                child: ListView(
                  children: interests.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: entry.key,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.value.map((item) {
                            final isSelected = selectedItems.contains(item);
                            return ChoiceChip(
                              label: CustomText(
                                text: item,
                                fontSize: 14,
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedItems.add(item);
                                  } else {
                                    selectedItems.remove(item);
                                  }
                                });
                              },
                              selectedColor: Colors.blueAccent.withOpacity(0.2),
                              backgroundColor: Color(0xff000000).withOpacity(0.03),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // Continue button
              CustomGradientButton(
                text: 'Continue',
                onPressed: () {
                  // Continue action
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  final RxInt selectedIndex;
  final Function(int) onTap; // Callback for handling taps

  CustomBottomNavBar({required this.selectedIndex, required this.onTap});

  final List<String> imagePaths = [
    'assets/icons/home.png',
    'assets/icons/search.png',
    'assets/icons/menu.png',
    'assets/icons/fav.png',
    'assets/icons/profile.png',
  ];

  final List<String> labels = ["Home".tr, "Categories".tr, "Menu".tr, "Activity".tr, "Profile".tr];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
              () => Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            width: constraints.maxWidth, // Ensures it fits within the screen
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(imagePaths.length, (index) {
                bool isSelected = selectedIndex.value == index;
                return Expanded( // Distributes space evenly
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected
                            ? []
                            : [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FittedBox( // Ensures icons and text adjust properly
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Image.asset(
                              imagePaths[index],
                              height: 24,
                              width: 24,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                            if (isSelected)
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  labels[index],
                                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final RxInt selectedIndex = 0.obs; // Default selected index

//   // **List of image paths for the bottom navigation bar**
//   final List<String> imagePaths = [
//     'assets/icons/home.png',
//     'assets/icons/search.png',
//     'assets/icons/menu.png',
//     'assets/icons/fav.png',
//     'assets/icons/profile.png',
//   ];

//   final List<String> labels = ["Home", "search", "menu", "faviourite", "Profile"];

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(imagePaths.length, (index) {
//             bool isSelected = selectedIndex.value == index;
//             return GestureDetector(
//               onTap: () => selectedIndex.value = index,
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.white : Colors.black,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       imagePaths[index],
//                       height: 24,
//                       width: 24,
//                       color: isSelected ? Colors.black : Colors.white,
//                     ),
//                     if (isSelected && labels[index] != "")
//                       Padding(
//                         padding: EdgeInsets.only(left: 8),
//                         child: Text(
//                           labels[index],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;
  final List<String> imagePaths = [
    'assets/icons/home.png',
    'assets/icons/search.png',
    'assets/icons/menu.png',
    'assets/icons/fav.png',
    'assets/icons/profile.png',
  ];

  final List<String> labels = ["Home", "Search", "Menu", "Faviourite", "Profile"];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(imagePaths.length, (index) {
            bool isSelected = selectedIndex.value == index;
            return GestureDetector(
              onTap: () => selectedIndex.value = index,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
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
                child: Row(
                  children: [
                    Image.asset(
                      imagePaths[index],
                      height: 24,
                      width: 24,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    if (isSelected && labels[index] != "")
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


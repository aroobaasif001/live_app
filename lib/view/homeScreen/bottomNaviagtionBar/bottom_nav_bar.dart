import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';
import '../../profile_views/profile_screen.dart';
import '../../search_views/search_screen.dart';
import '../bottomNaviagtionBar/custom_bottom_bar.dart';

import '../widgets/category_tab.dart';


class BottomNavigationBarWidget extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomeMainScreen(),
    SearchScreen(),
    // MenuScreen(), 
    // FavScreen(),
    Text('Menu'),
    Text('Fav'),
    ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: selectedIndex.value,
            children: screens,
          )),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: selectedIndex),
    );
  }
}
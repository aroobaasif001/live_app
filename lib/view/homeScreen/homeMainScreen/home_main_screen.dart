// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../bottomNaviagtionBar/custom_bottom_bar.dart';
// import '../widgets/live_video_card.dart';
// import '../widgets/category_tab.dart';
// import 'liveShoppingScreens/live_shopping_screen.dart';

// class HomeMainScreen extends StatelessWidget {
//   final int notificationCount = 2;
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         prefixIcon: Padding(
//                           padding: EdgeInsets.all(12),
//                           child: Image.asset(
//                             'assets/icons/search.png',
//                             width: 20,
//                             height: 20,
//                           ),
//                         ),
//                         hintText: "Search by application",
//                         hintStyle: TextStyle(
//                             fontFamily: 'SFProRounded', color: Colors.grey),
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Stack(
//                     children: [
//                       Image.asset('assets/icons/notification.png'),
//                       if (notificationCount > 0)
//                         Positioned(
//                           right: -1,
//                           top: -3,
//                           child: Container(
//                             padding: EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: Color(0xff815BFF),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               '$notificationCount',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 8,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   SizedBox(width: 10),
//                   Image.asset('assets/icons/gift.png')
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0),
//               child: CategoryTabs(),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     double screenWidth = constraints.maxWidth;

//                     return GestureDetector(
//                       onTap: () {
//                         Get.to(() => LiveShoppingScreen());
//                       },
//                       child: GridView.builder(
//                         physics: BouncingScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: screenWidth > 600 ? 3 : 2,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                           childAspectRatio: 0.42,
//                         ),
//                         itemCount: 6,
//                         itemBuilder: (context, index) {
//                           return LiveVideoCard();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottomNaviagtionBar/custom_bottom_bar.dart';
import '../widgets/live_video_card.dart';
import '../widgets/category_tab.dart';
import 'liveShoppingScreens/live_shopping_screen.dart';

// Home Screen with dynamic content
class HomeMainScreen extends StatelessWidget {
  final int notificationCount = 2;
  final List<String> liveVideos = List.generate(6, (index) => "Live $index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CategoryTabs(),
            ),
            SizedBox(height: 10),
            Expanded(child: _buildLiveVideos(context, liveVideos)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  // Top Bar with dynamic search & notifications
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset('assets/icons/search.png', width: 20, height: 20),
                ),
                hintText: "Search by application",
                hintStyle: TextStyle(fontFamily: 'SFProRounded', color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          _buildNotificationIcon(notificationCount),
          SizedBox(width: 10),
          Image.asset('assets/icons/gift.png')
        ],
      ),
    );
  }

  // Notification Badge
  Widget _buildNotificationIcon(int count) {
    return Stack(
      children: [
        Image.asset('assets/icons/notification.png'),
        if (count > 0)
          Positioned(
            right: -1,
            top: -3,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Color(0xff815BFF), shape: BoxShape.circle),
              child: Text(
                '$count',
                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLiveVideos(BuildContext context, List<String> videos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return GestureDetector(
            onTap: () {
              Get.to(() => LiveShoppingScreen());
            },
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.42,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return LiveVideoCard();
              },
            ),
          );
        },
      ),
    );
  }
}


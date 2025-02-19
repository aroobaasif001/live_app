import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottomNaviagtionBar/custom_bottom_bar.dart';
import '../widgets/live_video_card.dart';
import '../widgets/category_tab.dart';
import 'liveShoppingScreens/live_shopping_screen.dart';
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
            Expanded(child: _buildLiveVideos(context,)),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
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

  // Widget _buildLiveVideos(BuildContext context, List<String> videos) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         double screenWidth = constraints.maxWidth;
  //
  //         return GestureDetector(
  //           onTap: () {
  //             Get.to(() => LiveShoppingScreen());
  //           },
  //           child: GridView.builder(
  //             physics: BouncingScrollPhysics(),
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: screenWidth > 600 ? 3 : 2,
  //               crossAxisSpacing: 10,
  //               mainAxisSpacing: 10,
  //               childAspectRatio: 0.42,
  //             ),
  //             itemCount: videos.length,
  //             itemBuilder: (context, index) {
  //               return LiveVideoCard();
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _buildLiveVideos(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('livestreams').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No livestreams available'));
        }

        final livestreamsData = snapshot.data!.docs;

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
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.42,
                  ),
                  itemCount: livestreamsData.length,
                  itemBuilder: (context, index) {
                    // Cast the document data to a Map
                    final data = livestreamsData[index].data() as Map<String, dynamic>;

                    // Extract fields with a fallback if necessary.
                    final adminName = data['adminName'] as String? ?? 'Unknown';
                    final adminImage = data['adminPhoto'] as String? ?? '';
                    final viewsCount = data['viewsCount'] as int? ?? 0;
                    final title = data['title'] as String? ?? '';

                    return LiveVideoCard(
                      adminName: adminName,
                      adminImage: adminImage,
                      viewsCount: viewsCount,
                      title: title,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}


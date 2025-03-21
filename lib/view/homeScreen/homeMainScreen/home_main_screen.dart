import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../livestreaming/livestreamingview_screen.dart';
import '../../search_views/search_by_application.dart';
import '../widgets/live_video_card.dart';
import '../widgets/category_tab.dart';

class HomeMainScreen extends StatelessWidget {
  final int notificationCount = 2;
  final List<String> liveVideos = List.generate(6, (index) => "Live $index");

  HomeMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            // Constrain the CategoryTabs height to avoid overflow
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                height: 60, // Adjust height as needed
                child: CategoryTabs(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildLiveVideos(context)),
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
            child: Container(
              //height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onTap: () {
                  // Opens "SearchByApplication" screen
                  Get.to(() => const SearchByProduct());
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search'.tr,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
                textAlignVertical: TextAlignVertical.center, // Vertically center the text
              ),
            ),
          ),

          const SizedBox(width: 10),
          _buildNotificationIcon(notificationCount),
          const SizedBox(width: 10),
          Image.asset('assets/icons/gift.png',
              semanticLabel: "${'gift_icon'.tr}"),
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
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xff815BFF),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLiveVideos(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      FirebaseFirestore.instance.collection('livestreams').snapshots(),
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
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 360,
                ),
                itemCount: livestreamsData.length,
                itemBuilder: (context, index) {
                  final data = livestreamsData[index].data()
                  as Map<String, dynamic>;
                  final adminName =
                      data['adminName'] as String? ?? 'Unknown';
                  final adminImage =
                      data['adminPhoto'] as String? ?? '';
                  final viewsCount = data['viewsCount'] as int? ?? 0;
                  final title = data['title'] as String? ?? '';
                  final description =
                      data['description'] as String? ?? '';
                  final channelName =
                      data['channelId'] as String? ?? '';
                  final liveImage =
                      data['liveImage'] as String? ?? '';
                  final category = data['category'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      joinLiveStreamingWithPrefs(channelName);
                    },
                    child: LiveVideoCard(
                      adminName: adminName,
                      adminImage: adminImage,
                      viewsCount: viewsCount,
                      title: title,
                      description: description, liveImage: liveImage, category: category,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> joinLiveStreamingWithPrefs(String channelId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final uid = 10000 + Random().nextInt(90000);
      final name = 'Guest';
      final photo =
          'https://www.shutterstock.com/image-photo/blond-hair-girl-taking-photo-260nw-2492842415.jpg';

      if (uid == 0) {
        print('[ERROR] UID is not available in SharedPreferences.');
        return;
      }

      await joinLiveStreaming(channelId, uid, name, photo);
    } catch (e) {
      print('[ERROR] Failed to retrieve data from SharedPreferences: $e');
    }
  }
}



/// ///


// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../livestreaming/livestreamingview_screen.dart';
// import '../../search_views/search_by_application.dart';
// import '../widgets/live_video_card.dart';
// import '../widgets/category_tab.dart';
//
// class HomeMainScreen extends StatelessWidget {
//   final int notificationCount = 2;
//   final List<String> liveVideos = List.generate(6, (index) => "Live $index");
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTopBar(context),
//             // Constrain the CategoryTabs height to avoid overflow
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0),
//               child: SizedBox(
//                 height: 60, // Adjust height as needed
//                 child: CategoryTabs(),
//               ),
//             ),
//             SizedBox(height: 10),
//             Expanded(child: _buildLiveVideos(context)),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: CustomBottomNavBar(),
//     );
//   }
//
//   Widget _buildTopBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: TextField(
//                 onTap: () {
//                   // Opens "SearchByApplication" screen
//                   Get.to(() => const SearchByApplication());
//                 },
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: 'search'.tr,
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           _buildNotificationIcon(notificationCount),
//           SizedBox(width: 10),
//           Image.asset('assets/icons/gift.png', semanticLabel: "${'gift_icon'.tr}"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotificationIcon(int count) {
//     return Stack(
//       children: [
//         Image.asset('assets/icons/notification.png'),
//         if (count > 0)
//           Positioned(
//             right: -1,
//             top: -3,
//             child: Container(
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Color(0xff815BFF),
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '$count',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 8,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildLiveVideos(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('livestreams').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No livestreams available'));
//         }
//
//         final livestreamsData = snapshot.data!.docs;
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               double screenWidth = constraints.maxWidth;
//               return GridView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: screenWidth > 600 ? 3 : 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   mainAxisExtent: 360,
//                 ),
//                 itemCount: livestreamsData.length,
//                 itemBuilder: (context, index) {
//                   final data = livestreamsData[index].data() as Map<String, dynamic>;
//                   final adminName = data['adminName'] as String? ?? 'Unknown';
//                   final adminImage = data['adminPhoto'] as String? ?? '';
//                   final viewsCount = data['viewsCount'] as int? ?? 0;
//                   final title = data['title'] as String? ?? '';
//                   final description = data['description'] as String? ?? '';
//                   final channelName = data['channelId'] as String? ?? '';
//
//                   return GestureDetector(
//                     onTap: () {
//                       joinLiveStreamingWithPrefs(channelName);
//                     },
//                     child: LiveVideoCard(
//                       description: description,
//                       adminName: adminName,
//                       adminImage: adminImage,
//                       viewsCount: viewsCount,
//                       title: title,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> joinLiveStreamingWithPrefs(String channelId) async {
//     try {
//       final sharedPreferences = await SharedPreferences.getInstance();
//       final uid = 10000 + Random().nextInt(90000);
//       final name = 'Guest';
//       final photo = 'https://www.shutterstock.com/image-photo/blond-hair-girl-taking-photo-260nw-2492842415.jpg';
//
//       if (uid == 0) {
//         print('[ERROR] UID is not available in SharedPreferences.');
//         return;
//       }
//
//       await joinLiveStreaming(channelId, uid, name, photo);
//     } catch (e) {
//       print('[ERROR] Failed to retrieve data from SharedPreferences: $e');
//     }
//   }
// }



///

// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../livestreaming/livestreamingview_screen.dart';
// import '../../search_views/search_by_application.dart';
// import '../widgets/live_video_card.dart';
// import '../widgets/category_tab.dart';
//
// class HomeMainScreen extends StatelessWidget {
//   final int notificationCount = 2;
//   final List<String> liveVideos = List.generate(6, (index) => "Live $index");
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTopBar(context),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0),
//               child: CategoryTabs(),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//                 child: _buildLiveVideos(context)),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: CustomBottomNavBar(),
//     );
//   }
//
//   Widget _buildTopBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           Expanded(
//             child:  Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: TextField(
//                 onTap: () {
//                   // Opens "SearchByApplication" screen
//                   Get.to(() => const SearchByApplication());
//                 },
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: 'search'.tr,
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           _buildNotificationIcon(notificationCount),
//           SizedBox(width: 10),
//           Image.asset('assets/icons/gift.png', semanticLabel: "${'gift_icon'.tr}"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotificationIcon(int count) {
//     return Stack(
//       children: [
//         Image.asset('assets/icons/notification.png'),
//         if (count > 0)
//           Positioned(
//             right: -1,
//             top: -3,
//             child: Container(
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                   color: Color(0xff815BFF), shape: BoxShape.circle),
//               child: Text(
//                 '$count',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 8,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildLiveVideos(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('livestreams').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No livestreams available'));
//         }
//
//         final livestreamsData = snapshot.data!.docs;
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               double screenWidth = constraints.maxWidth;
//               return GridView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: screenWidth > 600 ? 3 : 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   mainAxisExtent: 360
//                 ),
//                 itemCount: livestreamsData.length,
//                 itemBuilder: (context, index) {
//                   // Cast the document data to a Map
//                   final data = livestreamsData[index].data() as Map<String, dynamic>;
//
//                   // Extract fields with fallback values
//                   final adminName = data['adminName'] as String? ?? 'Unknown';
//                   final adminImage = data['adminPhoto'] as String? ?? '';
//                   final viewsCount = data['viewsCount'] as int? ?? 0;
//                   final title = data['title'] as String? ?? '';
//                   final channelName = data['channelId'] as String? ?? '';
//
//                   return GestureDetector(
//                     onTap: () {
//                       joinLiveStreamingWithPrefs(channelName);
//                     },
//                     child: LiveVideoCard(
//                       adminName: adminName,
//                       adminImage: adminImage,
//                       viewsCount: viewsCount,
//                       title: title,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> joinLiveStreamingWithPrefs(String channelId) async {
//     try {
//       // Retrieve data from SharedPreferences
//       final sharedPreferences = await SharedPreferences.getInstance();
//       final uid = 10000 + Random().nextInt(90000);
//       final name =  'Guest';
//       final photo = 'https://www.shutterstock.com/image-photo/blond-hair-girl-taking-photo-260nw-2492842415.jpg';
//
//       if (uid == 0) {
//         print('[ERROR] UID is not available in SharedPreferences.');
//         return;
//       }
//
//       await joinLiveStreaming(channelId, uid, name, photo);
//     } catch (e) {
//       print('[ERROR] Failed to retrieve data from SharedPreferences: $e');
//     }
//   }
// }

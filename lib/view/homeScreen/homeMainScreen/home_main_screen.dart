import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/gift_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../livestreaming/livestreamingview_screen.dart';
import '../widgets/live_video_card.dart';
import '../widgets/category_tab.dart';
import 'notification_screen1.dart';

class HomeMainScreen extends StatefulWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final int notificationCount = 2;

  final List<String> liveVideos = List.generate(6, (index) => "Live $index");
  String? _selectedCategory;

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
              child: SizedBox(
                height: 60,
                child: CategoryTabs(
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
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
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search'.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => NotificationScreen1());
            },
            child: _buildNotificationIcon(notificationCount),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => GiftScreen());
            },
            child: Image.asset('assets/icons/gift.png',
                semanticLabel: "${'gift_icon'.tr}"),
          ),
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
      stream: FirebaseFirestore.instance.collection('livestreams').where('isBlocked', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('no_livestreams'.tr));
        }
           final allData = snapshot.data!.docs;
final filtered = _searchQuery.isEmpty && _selectedCategory == null
    ? allData
    : allData.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final title = data['title']?.toString().toLowerCase() ?? '';
        final admin = data['adminName']?.toString().toLowerCase() ?? '';
        final category = data['category']?.toString().toLowerCase() ?? '';
        return (_searchQuery.isEmpty || title.contains(_searchQuery) || admin.contains(_searchQuery)) &&
               (_selectedCategory == null || category == _selectedCategory!.toLowerCase());
      }).toList();

        // final filtered = _searchQuery.isEmpty
        //     ? allData
        //     : allData.where((doc) {
        //         final data = doc.data() as Map<String, dynamic>;
        //         final title = data['title']?.toString().toLowerCase() ?? '';
        //         final admin = data['adminName']?.toString().toLowerCase() ?? '';
        //         return title.contains(_searchQuery) ||
        //             admin.contains(_searchQuery);
        //       }).toList();

        if (filtered.isEmpty) {
          return Center(child: Text('no_matching_results'.tr));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 360,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final data = filtered[index].data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      joinLiveStreamingWithPrefs(data['channelId'] ?? '');
                    },
                    child: LiveVideoCard(
                      adminName: data['adminName'] ?? '',
                      adminImage: data['adminPhoto'] ?? '',
                      viewsCount: data['viewsCount'] ?? 0,
                      title: data['title'] ?? '',
                      description: data['description'] ?? '',
                      liveImage: data['liveImage'] ?? '',
                      category: data['category'] ?? '',
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
      final photo = 'https://www.shutterstock.com/image-photo/blond-hair-girl-taking-photo-260nw-2492842415.jpg';
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

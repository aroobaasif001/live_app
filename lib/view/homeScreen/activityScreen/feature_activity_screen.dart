import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradiant_tab_button.dart';
import 'package:live_app/entities/product_entity.dart';
import '../../livestreaming/livestreamingview_screen.dart';
import '../widgets/live_video_card.dart';
import 'widget/build_action_card.dart';

class FeatureActivityScreen extends StatelessWidget {
  final List<String> categories = ["All", "Streams", "Goods", "Search"];
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildCategoryTabs(),
            const SizedBox(height: 16),
            Obx(() {
              switch (categories[selectedCategoryIndex.value]) {
                case "Streams":
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Streams"),
                      SizedBox(height: 200, child: _buildLiveVideos(context)),
                    ],
                  );
                case "Goods":
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Goods"),
                      _buildProductList(),
                    ],
                  );
                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Streams"),
                      SizedBox(height: 200, child: _buildLiveVideos(context)),
                      const SizedBox(height: 16),
                      _buildSectionTitle("Goods"),
                      _buildProductList(),
                    ],
                  );
              }
            }),
            const SizedBox(height: 16),
            _buildSectionTitle("Search"),
            _buildSearchFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Obx(() => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomGradiantTabButton(
                    text: categories[index],
                    isSelected: selectedCategoryIndex.value == index,
                    onPressed: () => selectedCategoryIndex.value = index,
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildLiveVideos(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
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

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: livestreamsData.length,
            itemBuilder: (context, index) {
              final data =
                  livestreamsData[index].data() as Map<String, dynamic>;
              final adminName = data['adminName'] ?? 'Unknown';
              final adminImage = data['adminPhoto'] ?? '';
              final viewsCount = data['viewsCount'] ?? 0;
              final title = data['title'] ?? '';
              final channelName = data['channelId'] ?? '';

              return SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    joinLiveStreamingWithPrefs(channelName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: LiveVideoCard(
                      adminName: adminName,
                      adminImage: adminImage,
                      viewsCount: viewsCount,
                      title: title,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 300,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          List<ProductEntity> products = snapshot.data!.docs
              .map((doc) =>
                  ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return buildAuctionCard(products[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      children: [
        _buildFilterChip("Electronics"),
        _buildFilterChip("iPhone"),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Text(label), const Icon(Icons.close)],
          ),
        ),
      ),
    );
  }
}


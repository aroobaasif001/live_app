// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_gradiant_tab_button.dart';
// import 'package:live_app/entities/product_entity.dart';
// import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
// import '../../livestreaming/livestreamingview_screen.dart';
// import '../../search_views/search_by_application.dart';
// import '../widgets/live_video_card.dart';
// import 'widget/build_action_card.dart';

// class FeatureActivityScreen extends StatelessWidget {
//   final List<String> categories = ["All", "Streams", "Goods", "Search"];
//   final RxInt selectedCategoryIndex = 0.obs;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 12),
//             _buildCategoryTabs(),
//             const SizedBox(height: 16),
//             Obx(() {
//               switch (categories[selectedCategoryIndex.value]) {
//                 case "Streams":
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Streams".tr),
//                       SizedBox(height: 350, child: _buildLiveVideos(context)),
//                     ],
//                   );
//                 case "Goods":
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Goods".tr),
//                       _buildProductList(),
//                     ],
//                   );
//                 default:
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Streams".tr),
//                       SizedBox(height: 360, child: _buildLiveVideos(context)),
//                       const SizedBox(height: 16),
//                       _buildSectionTitle("Goods".tr),
//                       _buildProductList(),
//                     ],
//                   );
//               }
//             }),
//             const SizedBox(height: 16),
//             // SizedBox(
//             //     height: Get.height * .4
//             //     ,
//             //     child: SearchByProduct()),
//            // _buildSectionTitle("Search"),
//           //  _buildSearchFilters(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTabs() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(categories.length, (index) {
//             return Obx(() => Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: CustomGradiantTabButton(
//                     text: categories[index].tr,
//                     isSelected: selectedCategoryIndex.value == index,
//                     onPressed: () => selectedCategoryIndex.value = index,
//                   ),
//                 ));
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//     );
//   }

//   Widget _buildLiveVideos(BuildContext context) {
//     return SizedBox(
//       height: 360,
//       child: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance.collection('livestreams').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return  Center(child: Text('no_livestreams'.tr));
//           }

//           final livestreamsData = snapshot.data!.docs;

//           return ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: const BouncingScrollPhysics(),
//             itemCount: livestreamsData.length,
//             itemBuilder: (context, index) {
//               final data =
//                   livestreamsData[index].data() as Map<String, dynamic>;
//               final adminName = data['adminName'] ?? 'Unknown';
//               final adminImage = data['adminPhoto'] ?? '';
//               final liveImage = data['liveImage'] ?? '';

//               final viewsCount = data['viewsCount'] ?? 0;
//               final title = data['title'] ?? '';
//               final description = data['description'] as String? ?? '';
//               final channelName = data['channelId'] ?? '';
//               final category = data['category'] ?? '';


//               return SizedBox(
//                 width: 150,
//                 child: GestureDetector(
//                   onTap: () {
//                     joinLiveStreamingWithPrefs(channelName);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: LiveVideoCard(
//                       description:description,
//                       adminName: adminName,
//                       adminImage: adminImage,
//                       viewsCount: viewsCount,
//                       title: title, liveImage: liveImage, category: category,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductList() {
//     return SizedBox(
//       height: 300,
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No products available".tr));
//           }

//           List<ProductEntity> products = snapshot.data!.docs
//               .map((doc) =>
//                   ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
//               .toList();

//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(

//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailScreen(product: products[index]),
//                       ),
//                     );
//                   },

//                   child: buildAuctionCard(products[index]));
//             },
//           );
//         },
//       ),
//     );
//   }



 
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradiant_tab_button.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import '../../livestreaming/livestreamingview_screen.dart';
import '../widgets/live_video_card.dart';
import 'widget/build_action_card.dart';

class FeatureActivityScreen extends StatelessWidget {
  final List<String> categories = ["All", "Streams", "Goods", "Search"];
  final RxInt selectedCategoryIndex = 0.obs;
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

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
                      _buildSectionTitle("Streams".tr),
                      SizedBox(height: 350, child: _buildLiveVideos(context)),
                    ],
                  );
                case "Goods":
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Goods".tr),
                      _buildProductList(),
                    ],
                  );
                case "Search":
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Search".tr),
                      _buildSearchBar(),
                     _buildSearchResults(),
                    ],
                  );
                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Streams".tr),
                      SizedBox(height: 360, child: _buildLiveVideos(context)),
                      const SizedBox(height: 16),
                      _buildSectionTitle("Goods".tr),
                      _buildProductList(),
                    ],
                  );
              }
            }),
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
                    text: categories[index].tr,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => searchQuery.value = value.trim().toLowerCase(),
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildLiveVideos(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('livestreams').snapshots(),
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

        final livestreamsData = snapshot.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: livestreamsData.length,
          itemBuilder: (context, index) {
            final data = livestreamsData[index].data() as Map<String, dynamic>;
            final adminName = data['adminName'] ?? 'Unknown';
            final adminImage = data['adminPhoto'] ?? '';
            final liveImage = data['liveImage'] ?? '';
            final viewsCount = data['viewsCount'] ?? 0;
            final title = data['title'] ?? '';
            final description = data['description'] as String? ?? '';
            final channelName = data['channelId'] ?? '';
            final category = data['category'] ?? '';

            return SizedBox(
              width: 150,
              child: GestureDetector(
                onTap: () => joinLiveStreamingWithPrefs(channelName),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: LiveVideoCard(
                    description: description,
                    adminName: adminName,
                    adminImage: adminImage,
                    viewsCount: viewsCount,
                    title: title,
                    liveImage: liveImage,
                    category: category,
                  ),
                ),
              ),
            );
          },
        );
      },
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
            return Center(child: Text("No products available".tr));
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: products[index]),
                    ),
                  );
                },
                child: buildAuctionCard(products[index]),
              );
            },
          );
        },
      ),
    );
  }

Widget _buildSearchResults() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('products').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text("No products found".tr));
      }

      List<ProductEntity> allProducts = snapshot.data!.docs
          .map((doc) =>
              ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Obx(() {
        final filtered = allProducts.where((product) {
          final title = product.title?.toLowerCase() ?? '';
          final description = product.description?.toLowerCase() ?? '';
          return title.contains(searchQuery.value) ||
              description.contains(searchQuery.value);
        }).toList();

        if (filtered.isEmpty) {
          return Center(child: Text("No results match your search.".tr));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: filtered[index]),
                  ),
                );
              },
              child: buildAuctionCard(filtered[index]),
            );
          },
        );
      });
    },
  );
}

}

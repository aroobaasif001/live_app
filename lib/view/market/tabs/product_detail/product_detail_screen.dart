import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/seller_information_screen.dart';

import '../../../../entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  /// Submit the rating to Firestore under products/{productId}/ratings/{userId}
  Future<void> _submitRating(String productId, double userRating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('ratings')
          .doc(user.uid)
          .set({
        'rating': userRating,
        'ratedAt': FieldValue.serverTimestamp(),
      });
      print('User ${user.uid} rated $userRating stars');
    } catch (error) {
      print('Error while submitting rating: $error');
    }
  }

  /// Display a dialog that allows the user to rate the product
  void _showRatingDialog(BuildContext context) {
    double userRating = 0.0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Rate this product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How would you rate this product?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < userRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          userRating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  '${userRating.toInt()} ${userRating == 1 ? 'star' : 'stars'}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (product.id != null) {
                    await _submitRating(product.id!, userRating);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanks for your rating!')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:  Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Text(product.title ?? 'Product Details'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              CustomContainer(
                height: 376,
                width: double.infinity,
                image: DecorationImage(
                  image: product.images != null && product.images!.isNotEmpty
                      ? NetworkImage(product.images!.first)
                      : AssetImage(iphoneImage) as ImageProvider,
                  fit: BoxFit.fill,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 12),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      icon: CustomContainer(
                        height: 30,
                        width: 30,
                        conColor: Colors.white,
                        shape: BoxShape.circle,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.title ?? 'Unknown Product',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFProRounded',
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      text:
                      '${product.category ?? 'Unknown'} - ${product.saleType ?? 'N/A'}',
                      fontFamily: "Gilroy",
                      fontSize: 17,
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        CustomContainer(
                          height: 22,
                          width: 61,
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.circular(4),
                          conColor: const Color(0xff7246F1).withOpacity(0.1),
                          child: CustomText(
                            text: product.isSold ?? false
                                ? 'Sold Out'
                                : 'Available',
                            fontSize: 12,
                            color: const Color(0xff7246F1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTable(
                      leftText: 'Selling Price',
                      rightText: '${product.price ?? 'N/A'} ₽',
                    ),
                    CustomTable(
                      leftText: 'Type of Sale',
                      rightText: product.saleType ?? 'N/A',
                      conColor: Colors.white,
                    ),
                    CustomTable(
                      leftText: 'Streamer',
                      rightText: product.streamer ?? 'Unknown',
                    ),
                    CustomTable(
                      leftText: 'Delivery',
                      rightText: product.delivery ?? 'N/A',
                      conColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Divider(color: conLineColor),
                    const SizedBox(height: 12),
                    // Display aggregated average rating using a StreamBuilder
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .doc(product.id)
                          .collection('ratings')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error loading ratings');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final docs = snapshot.data!.docs;
                        double total = 0.0;
                        int count = docs.length;
                        for (var doc in docs) {
                          final data =
                              doc.data() as Map<String, dynamic>? ?? {};
                          total += (data['rating'] is num
                              ? data['rating'].toDouble()
                              : 0.0);
                        }
                        final avgRating = count > 0 ? total / count : 0.0;
                        return Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              'Average Rating: ${avgRating.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // ButtonsTabBar for switching between product information tabs
                    DefaultTabController(
                      length: 2,
                      child: Builder(
                        builder: (context) {
                          final TabController tabController =
                          DefaultTabController.of(context)!;
                          tabController.addListener(() {
                            if (tabController.indexIsChanging &&
                                tabController.index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SellerInformationScreen(
                                    sellerProfileId: product.id ??
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                ),
                              );
                              tabController.index = 0;
                            }
                          });
                          return ButtonsTabBar(
                            unselectedBackgroundColor: Colors.white,
                            borderWidth: 0,
                            elevation: 0.0001,
                            unselectedBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            radius: 8,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            buttonMargin:
                            const EdgeInsets.symmetric(horizontal: 10),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.pinkAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            tabs: const [
                              Tab(text: 'About the Product'),
                              Tab(text: 'Seller Information'),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // TabBarView for additional product details
              CustomContainer(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: [
                    AboutTheProductScreen(),
                    SellerInformationScreen(
                      sellerProfileId:
                      product.id ?? FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Floating action buttons for rating and purchase (or price display)
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'rateButton',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => _showRatingDialog(context),
              child: const Icon(Icons.star, color: Colors.amber),
            ),
            const SizedBox(height: 10),
            CustomContainer(
              height: 50,
              width: 120,
              borderRadius: BorderRadius.circular(100),
              conColor: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: greyColor,
                  blurRadius: 5,
                  offset: const Offset(-1, 3),
                ),
              ],
              child: Center(
                child: CustomContainer(
                  height: 44,
                  width: 111,
                  borderRadius: BorderRadius.circular(100),
                  gradient: primaryGradientColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        height: 24,
                        width: 24,
                        image: DecorationImage(
                          image: AssetImage(storeIcon),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: '${product.price} ₽',
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/// ///

// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_container.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_table.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/utils/colors.dart';
// import 'package:live_app/utils/icons_path.dart';
// import 'package:live_app/utils/images_path.dart';
// import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';
// import 'package:live_app/view/market/tabs/product_detail/tabs/seller_information_screen.dart';
//
// import '../../../../entities/product_entity.dart';
//
// class ProductDetailScreen extends StatelessWidget {
//   final ProductEntity product;
//
//   ProductDetailScreen({required this.product});
//
//   void _showRatingDialog(BuildContext context) {
//     double userRating = 0.0;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Rate this product'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('How would you rate this product?'),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         icon: Icon(
//                           index < userRating ? Icons.star : Icons.star_border,
//                           color: Colors.amber,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             userRating = index + 1.0;
//                           });
//                         },
//                       );
//                     }),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     '${userRating.toInt()} ${userRating == 1 ? 'star' : 'stars'}',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Here you would typically save the rating to your database
//                     print('User rated: $userRating stars');
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Thanks for your rating!')),
//                     );
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Color(0xffC9C9C9),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Image
//               CustomContainer(
//                 height: 376,
//                 width: double.infinity,
//                 image: DecorationImage(
//                   image: product.images != null && product.images!.isNotEmpty
//                       ? NetworkImage(product.images!.first)
//                       : AssetImage(iphoneImage) as ImageProvider,
//                   fit: BoxFit.fill,
//                 ),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 50, right: 12),
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () => Get.back(),
//                       icon: CustomContainer(
//                         height: 30,
//                         width: 30,
//                         conColor: Colors.white,
//                         shape: BoxShape.circle,
//                         child: Icon(Icons.close),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: product.title ?? 'unknown_product'.tr,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'SFProRounded',
//                     ),
//                     SizedBox(height: 6),
//                     CustomText(
//                       text:
//                           '${product.category ?? 'unknown'.tr} - ${product.saleType ?? 'N/A'}',
//                       fontFamily: "Gilroy",
//                       fontSize: 17,
//                     ),
//                     SizedBox(height: 13),
//                     Row(
//                       children: [
//                         CustomContainer(
//                           height: 22,
//                           width: 61,
//                           alignment: Alignment.center,
//                           borderRadius: BorderRadius.circular(4),
//                           conColor: Color(0xff7246F1).withOpacity(0.1),
//                           child: CustomText(
//                             text: product.isSold ?? false
//                                 ? 'sold_out'.tr
//                                 : 'available'.tr,
//                             fontSize: 12,
//                             color: Color(0xff7246F1),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     CustomTable(
//                       leftText: 'selling_price'.tr,
//                       rightText: '${product.price ?? 'N/A'} ₽',
//                     ),
//                     CustomTable(
//                       leftText: 'type_of_sale'.tr,
//                       rightText: product.saleType ?? 'N/A',
//                       conColor: Colors.white,
//                     ),
//                     CustomTable(
//                       leftText: 'streamer'.tr,
//                       rightText: product.streamer ?? 'Unknown',
//                     ),
//                     CustomTable(
//                       leftText: 'delivery'.tr,
//                       rightText: product.delivery ?? 'N/A',
//                       conColor: Colors.white,
//                     ),
//                     SizedBox(height: 12),
//                     Divider(color: conLineColor),
//                     SizedBox(height: 12),
//                     DefaultTabController(
//                       length: 2,
//                       child: Builder(
//                         builder: (context) {
//                           final TabController tabController =
//                               DefaultTabController.of(context);
//                           tabController.addListener(() {
//                             if (tabController.indexIsChanging &&
//                                 tabController.index == 1) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => SellerInformationScreen(
//                                     sellerProfileId: product.id ??
//                                         FirebaseAuth.instance.currentUser!.uid,
//                                   ),
//                                 ),
//                               );
//                               tabController.index = 0;
//                             }
//                           });
//                           return ButtonsTabBar(
//                             unselectedBackgroundColor: Colors.white,
//                             borderWidth: 0,
//                             elevation: 0.0001,
//                             unselectedBorderColor: Colors.transparent,
//                             borderColor: Colors.transparent,
//                             radius: 8,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 10),
//                             buttonMargin: EdgeInsets.symmetric(horizontal: 10),
//                             labelStyle: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               gradient: LinearGradient(
//                                 colors: [Colors.blue, Colors.pinkAccent],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                             tabs: [
//                               Tab(text: 'about_the_product'.tr),
//                               Tab(text: 'seller_information'.tr),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                   ],
//                 ),
//               ),
//               CustomContainer(
//                 height: MediaQuery.of(context).size.height,
//                 child: TabBarView(
//                   children: [
//                     AboutTheProductScreen(),
//                     SellerInformationScreen(
//                       sellerProfileId:
//                           product.id ?? FirebaseAuth.instance.currentUser!.uid,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FloatingActionButton(
//               heroTag: 'rateButton',
//               mini: true,
//               backgroundColor: Colors.white,
//               onPressed: () => _showRatingDialog(context),
//               child: Icon(Icons.star, color: Colors.amber),
//             ),
//             SizedBox(height: 10),
//             CustomContainer(
//               height: 50,
//               width: 120,
//               borderRadius: BorderRadius.circular(100),
//               conColor: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: greyColor, blurRadius: 5, offset: Offset(-1, 3))
//               ],
//               child: Center(
//                 child: CustomContainer(
//                   height: 44,
//                   width: 111,
//                   borderRadius: BorderRadius.circular(100),
//                   gradient: primaryGradientColor,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomContainer(
//                         height: 24,
//                         width: 24,
//                         image: DecorationImage(image: AssetImage(storeIcon)),
//                       ),
//                       CustomText(
//                           text: '${product.price} ₽', color: Colors.white),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///

// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_container.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_table.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/utils/colors.dart';
// import 'package:live_app/utils/icons_path.dart';
// import 'package:live_app/utils/images_path.dart';
// import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';
// import 'package:live_app/view/market/tabs/product_detail/tabs/seller_information_screen.dart';
//
// import '../../../../entities/product_entity.dart';
//
// class ProductDetailScreen extends StatelessWidget {
//   final ProductEntity product;
//
//   ProductDetailScreen({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Color(0xffC9C9C9),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Image
//               CustomContainer(
//                 height: 376,
//                 width: double.infinity,
//                 image: DecorationImage(
//                   image: product.images != null && product.images!.isNotEmpty
//                       ? NetworkImage(product.images!.first)
//                       : AssetImage(iphoneImage) as ImageProvider, // Use first image or default
//                   fit: BoxFit.fill,
//                 ),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 50, right: 12),
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () => Get.back(),
//                       icon: CustomContainer(
//                         height: 30,
//                         width: 30,
//                         conColor: Colors.white,
//                         shape: BoxShape.circle,
//                         child: Icon(Icons.close),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: product.title ?? 'unknown_product'.tr,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'SFProRounded',
//                     ),
//                     SizedBox(height: 6),
//                     CustomText(
//                       text: '${product.category ?? 'unknown'.tr} - ${product.saleType ?? 'N/A'}',
//                       fontFamily: "Gilroy",
//                       fontSize: 17,
//                     ),
//                     SizedBox(height: 13),
//                     CustomContainer(
//                       height: 22,
//                       width: 61,
//                       alignment: Alignment.center,
//                       borderRadius: BorderRadius.circular(4),
//                       conColor: Color(0xff7246F1).withOpacity(0.1),
//                       child: CustomText(
//                         text: product.isSold ?? false ? 'sold_out'.tr : 'available'.tr,
//                         fontSize: 12,
//                         color: Color(0xff7246F1),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     CustomTable(
//                       leftText: 'selling_price'.tr,
//                       rightText: '${product.price ?? 'N/A'} ₽',
//                     ),
//                     CustomTable(
//                       leftText: 'type_of_sale'.tr,
//                       rightText: product.saleType ?? 'N/A',
//                       conColor: Colors.white,
//                     ),
//                     CustomTable(
//                       leftText: 'streamer'.tr,
//                       rightText: product.streamer ?? 'Unknown',
//                     ),
//                     CustomTable(
//                       leftText: 'delivery'.tr,
//                       rightText: product.delivery ?? 'N/A',
//                       conColor: Colors.white,
//                     ),
//                     SizedBox(height: 12),
//                     Divider(color: conLineColor),
//                     SizedBox(height: 12),
//                     DefaultTabController(
//                       length: 2,
//                       child: Builder(
//                         builder: (context) {
//                           final TabController tabController = DefaultTabController.of(context);
//                           tabController.addListener(() {
//                             if (tabController.indexIsChanging && tabController.index == 1) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) =>                    SellerInformationScreen(sellerProfileId: product.id ?? FirebaseAuth.instance.currentUser!.uid,),
//                                 ),
//                               );
//                               // Reset back to previous tab after navigation (optional)
//                               tabController.index = 0;
//                             }
//                           });
//                           return ButtonsTabBar(
//                             unselectedBackgroundColor: Colors.white,
//                             borderWidth: 0,
//                             elevation: 0.0001,
//                             unselectedBorderColor: Colors.transparent,
//                             borderColor: Colors.transparent,
//                             radius: 8,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                             buttonMargin: EdgeInsets.symmetric(horizontal: 10),
//                             labelStyle: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               gradient: LinearGradient(
//                                 colors: [Colors.blue, Colors.pinkAccent],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                             tabs: [
//                               Tab(text: 'about_the_product'.tr),
//                               Tab(text: 'seller_information'.tr),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//
//                     SizedBox(height: 12),
//                   ],
//                 ),
//               ),
//               CustomContainer(
//                 height: MediaQuery.of(context).size.height,
//                 child: TabBarView(
//                   children: [
//                     AboutTheProductScreen(),
//                     SellerInformationScreen(sellerProfileId: product.id ?? FirebaseAuth.instance.currentUser!.uid,),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: CustomContainer(
//           height: 50,
//           width: 120,
//           borderRadius: BorderRadius.circular(100),
//           conColor: Colors.white,
//           boxShadow: [
//             BoxShadow(color: greyColor, blurRadius: 5, offset: Offset(-1, 3))
//           ],
//           child: Center(
//             child: CustomContainer(
//               height: 44,
//               width: 111,
//               borderRadius: BorderRadius.circular(100),
//               gradient: primaryGradientColor,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomContainer(
//                     height: 24,
//                     width: 24,
//                     image: DecorationImage(image: AssetImage(storeIcon)),
//                   ),
//                   CustomText(text: '${product.price} ₽', color: Colors.white),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

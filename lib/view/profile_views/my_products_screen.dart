import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/view/profile_views/create_a_product_screen.dart';

import '../../custom_widgets/custom_container.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/images_path.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "My Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonsTabBar(
                unselectedBackgroundColor: Colors.white,
                borderWidth: 0,
                unselectedBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  Tab(text: "All"),
                  Tab(text: "Active"),
                  Tab(text: "Sold"),
                  Tab(text: "Fix"),
                  Tab(text: "Auction"),
                ],
              ),

              const SizedBox(height: 12),

              // Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Product List View
              Expanded(
                child: TabBarView(
                  children: [
                    buildProductList("All"),
                    buildProductList("Active"),
                    buildProductList("Sold"),
                    buildProductList("Fix"),
                    buildProductList("Auction"),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          onPressed: () {
            Get.to(() => const CreateProductScreen());
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildProductList(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        // Convert each doc into a ProductEntity
        List<ProductEntity> products = snapshot.data!.docs
            .map((doc) =>
            ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        // Filter logic
        if (filter == "Fix") {
          products = products.where((p) => p.saleType == "Buy Now").toList();
        } else if (filter == "Auction") {
          products = products.where((p) => p.saleType == "Auction").toList();
        } else if (filter == "Active") {
          products =
              products.where((p) => (p.isActive ?? false) && !(p.isSold ?? false))
                  .toList();
        } else if (filter == "Sold") {
          products = products.where((p) => p.isSold ?? false).toList();
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return buildProductItem(products[index]);
          },
        );
      },
    );
  }

  Widget buildProductItem(ProductEntity product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Product image
              CustomContainer(
                height: 135,
                width: 135,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    (product.images != null && product.images!.isNotEmpty)
                        ? product.images!.first
                        : 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),

              // "Auction" or "Buy Now"
              Positioned(
                top: 6,
                left: 6,
                child: CustomContainer(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: CustomText(
                    text: product.saleType == "Auction" ? "Auction" : "Buy Now",
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // "SOLD"
              if (product.isSold ?? false)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    conColor: Colors.red,
                    child: const CustomText(
                      text: "SOLD",
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Right side info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.title ?? "",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                CustomText(
                  text: product.description ?? "",
                  fontSize: 14,
                  color: Colors.grey,
                ),
                // Price
                CustomText(
                  text: product.price == null
                      ? "${product.startingBid ?? '0'} ₽"
                      : "${product.price} ₽",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),

                const SizedBox(height: 8),
                // Active or Inactive
                CustomText(
                  text: (product.isActive ?? false) ? "Active" : "Inactive",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: (product.isActive ?? false) ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




///



// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/entities/product_entity.dart';
// import 'package:live_app/view/profile_views/create_a_product_screen.dart';
//
// import '../../custom_widgets/custom_container.dart';
// import '../../custom_widgets/custom_gradient_button.dart';
// import '../../custom_widgets/custom_text.dart';
// import '../../utils/images_path.dart';
// class MyProductsScreen extends StatefulWidget {
//   const MyProductsScreen({super.key});
//
//   @override
//   State<MyProductsScreen> createState() => _MyProductsScreenState();
// }
//
// class _MyProductsScreenState extends State<MyProductsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text(
//             "My Products",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ButtonsTabBar(
//                 unselectedBackgroundColor: Colors.white,
//                 borderWidth: 0,
//                 unselectedBorderColor: Colors.transparent,
//                 borderColor: Colors.transparent,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 labelStyle: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 unselectedLabelStyle: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     colors: [Colors.blue, Colors.pinkAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 tabs: [
//                   Tab(text: "All"),
//                   Tab(text: "Active"),
//                   Tab(text: "Sold"),
//                   Tab(text: "Fix"),
//                   Tab(text: "Auction"),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // Search Bar
//               Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Search",
//                     prefixIcon: Icon(Icons.search, color: Colors.grey),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Product List View
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     buildProductList("All"),
//                     buildProductList("Active"),
//                     buildProductList("Sold"),
//                     buildProductList("Fix"),
//                     buildProductList("Auction"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Floating Action Button
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.purpleAccent,
//           onPressed: () {
//             Get.to(() => CreateProductScreen());
//           },
//           child: const Icon(Icons.add, size: 28, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Widget buildProductList(String filter) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('products').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No products found"));
//         }
//
//         List<ProductEntity> products = snapshot.data!.docs
//             .map((doc) =>
//                 ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
//             .toList();
//
//         if (filter == "Fix") {
//           products = products
//               .where((product) => product.saleType == "Buy Now")
//               .toList();
//         } else if (filter == "Auction") {
//           products = products
//               .where((product) => product.saleType == "Auction")
//               .toList();
//         } else if (filter == "Active") {
//           products = products
//               .where((product) => product.isActive! && !product.isSold!)
//               .toList();
//         } else if (filter == "Sold") {
//           products = products.where((product) => product.isSold!).toList();
//         }
//
//         return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             return buildProductItem(products[index]);
//           },
//         );
//       },
//     );
//   }
//   Widget buildProductItem(ProductEntity product) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               CustomContainer(
//                 height: 135,
//                 width: 135,
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: NetworkImage(
//                       product.images != null && product.images!.isNotEmpty
//                           ? product.images![0]
//                           : 'https://via.placeholder.com/150'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 6,
//                 left: 6,
//                 child: CustomContainer(
//                   height: 20,
//                   padding: EdgeInsets.symmetric(horizontal: 6),
//                   borderRadius: BorderRadius.circular(6),
//                   gradient: LinearGradient(
//                     colors: [Colors.blue, Colors.pinkAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   child: CustomText(
//                     text: product.saleType == "Auction" ? "Auction" : "Buy Now",
//                     fontSize: 10,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               if (product.isSold!) // ✅ Show "SOLD" if product is sold
//                 Positioned(
//                   bottom: 6,
//                   left: 6,
//                   child: CustomContainer(
//                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     borderRadius: BorderRadius.circular(6),
//                     conColor: Colors.red,
//                     child: CustomText(
//                       text: "SOLD",
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: product.title!,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//                 CustomText(
//                   text: product.description!,
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//                 CustomText(
//                   text: "${product.price} ₽",
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//                 const SizedBox(height: 8),
//                 CustomText(
//                   text: product.isActive! ? "Active" : "Inactive",
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: product.isActive! ? Colors.green : Colors.red,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

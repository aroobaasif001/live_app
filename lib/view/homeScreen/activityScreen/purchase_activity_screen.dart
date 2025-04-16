import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';
import '../../../utils/images_path.dart';

class PurchaseActivityScreen extends StatefulWidget {
  final String currentUserId;

  PurchaseActivityScreen({required this.currentUserId});

  @override
  _PurchaseActivityScreenState createState() => _PurchaseActivityScreenState();
}

class _PurchaseActivityScreenState extends State<PurchaseActivityScreen> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    "All",
    "Awaiting receipt",
    "On the way",
    "Awaiting shipment"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildCategoryTabs(),
          const SizedBox(height: 12),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  // Returns the content for the selected tab.
  Widget _buildTabContent() {
    switch (selectedCategoryIndex) {
      case 0:
        return _buildAllProductsTab();
      case 1:
        return _buildAwaitingReceiptTab();
      case 2:
        return _buildOnTheWayTab();
      case 3:
        return _buildAwaitingShipmentTab();
      default:
        return Container(); // Fallback in case of an unexpected index.
    }
  }

  // Tab 1: All Products
  Widget _buildAllProductsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("no_products_found".tr));
        }

        List<ProductEntity> allProducts = snapshot.data!.docs
            .map((doc) =>
            ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return _buildProductList(allProducts);
      },
    );
  }

  // Tab 2: Awaiting Receipt
  Widget _buildAwaitingReceiptTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text("no_products_found".tr,
                  style: const TextStyle(color: Colors.black)));
        }

        List<ProductEntity> awaitingReceiptProducts =
        snapshot.data!.docs.map((doc) {
          final product =
          ProductEntity.fromJson(doc.data() as Map<String, dynamic>);
          return product;
        }).where((product) {
          // Check if the bidders map exists and contains currentUserId.
          final isBidder = product.bidders != null &&
              product.bidders!.containsKey(widget.currentUserId);
          return isBidder;
        }).toList();

        if (awaitingReceiptProducts.isEmpty) {
          return Center(
              child: Text("No awaiting receipt products found.",
                  style: const TextStyle(color: Colors.black)));
        }

        return _buildProductList(awaitingReceiptProducts);
      },
    );
  }

  // Tab 3: On the Way
  Widget _buildOnTheWayTab() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('UserEntity')
          .doc(widget.currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("No user data found".tr));
        }

        // Fetch the list of product IDs from the auctionedWinProduct array in UserEntity.
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final List<String> auctionedProductIds =
        List<String>.from(userData['auctionedWinProduct'] ?? []);

        if (auctionedProductIds.isEmpty) {
          return Center(child: Text("No auctioned products found.".tr));
        }

        // Query products whose IDs are in auctionedProductIds.
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where(FieldPath.documentId, whereIn: auctionedProductIds)
              .snapshots(),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("No products found".tr));
            }

            List<ProductEntity> onTheWayProducts = productSnapshot.data!.docs
                .map((doc) =>
                ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
                .where((product) {
              // Only show active and not sold products.
              return product.isActive == true && product.isSold == false;
            }).toList();

            return _buildProductList(onTheWayProducts);
          },
        );
      },
    );
  }

  // Tab 4: Awaiting Shipment
  Widget _buildAwaitingShipmentTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("no_products_found".tr));
        }

        List<ProductEntity> awaitingShipmentProducts = snapshot.data!.docs
            .map((doc) =>
            ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
            .where((product) {
          return product.selfDestruct == true && product.isSold == false;
        }).toList();

        return _buildProductList(awaitingShipmentProducts);
      },
    );
  }

  // Helper method to build the product list for any tab.
  Widget _buildProductList(List<ProductEntity> products) {
    return ListView(
      children: [
        ...products
            .map((product) => GestureDetector(
          onTap: () {
            Get.to(() => ProductDetailScreen(product: product));
          },
          child: _buildProductCard(product),
        ))
            .toList(),
      ],
    );
  }

  // Build the category tabs.
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CustomGradiantTabButton(
                text: categories[index],
                isSelected: selectedCategoryIndex == index,
                onPressed: () {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }

Widget _buildProductCard(ProductEntity product, {
  String status = '',
  bool isActive=true,
  Color statusColor = Colors.purple,
  int messageCount = 3,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Stack(
          children: [
        ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(12),
    bottomLeft: Radius.circular(12),
  ),
  child: (product.images != null &&
          product.images!.isNotEmpty &&
          product.images!.first.isNotEmpty)
      ? Image.network(
          product.images!.first,
          width: 140,
          height: 140,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            watchVerticalImage,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        )
      : Image.asset(
          watchVerticalImage,
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
),


            // 🟢 Notification bubble (top-right corner)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/Bookmark.png',height: 16,width: 16,),
                  
                    const SizedBox(width: 4),
                    Text(
                      '$messageCount',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // 🟣 Status label (bottom-left corner)
            if (status.isNotEmpty)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storefront, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      product.streamer ?? 'company_name',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _buildRatingWidget(product),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.title ?? 'Product name',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  product.description ?? 'Description',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  "${product.price ?? '0'} ₽",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



  // Helper method to build the rating widget for a given product.
  Widget _buildRatingWidget(ProductEntity product) {
    // If the product does not have a valid ID then we cannot fetch ratings.
    if (product.id == null) return Container();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .collection('ratings')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error loading rating");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading rating...");
        }
        final ratingDocs = snapshot.data!.docs;
        double total = 0.0;
        int count = ratingDocs.length;
        for (var doc in ratingDocs) {
          final data = doc.data() as Map<String, dynamic>;
          total += (data['rating'] is num ? data['rating'].toDouble() : 0.0);
        }
        double averageRating = count > 0 ? total / count : 0.0;
        return Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}



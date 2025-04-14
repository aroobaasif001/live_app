import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';

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

  // This method returns the StreamBuilder for the selected tab
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
        return Container(); // In case there's an unexpected tab
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
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text("no_products_found".tr,
                  style: TextStyle(color: Colors.black))); // No products found
        }

        List<ProductEntity> awaitingReceiptProducts =
            snapshot.data!.docs.map((doc) {
          final product =
              ProductEntity.fromJson(doc.data() as Map<String, dynamic>);
          print('Product ID: ${product.id}, Bidders: ${product.bidders}');
          return product;
        }).where((product) {
          print(
              'Checking if currentUserId: ${widget.currentUserId} is in bidders...');
          // Check if bidders map exists and contains currentUserId
          final isBidder = product.bidders != null &&
              product.bidders!.containsKey(widget.currentUserId);
          print('Is currentUserId a bidder? $isBidder');
          return isBidder; // Only return products where currentUserId is a bidder
        }).toList();

        if (awaitingReceiptProducts.isEmpty) {
          return Center(
              child: Text("No awaiting receipt products found.",
                  style: TextStyle(
                      color: Colors
                          .black))); // Display message when no products match
        }

        return _buildProductList(
            awaitingReceiptProducts); // Call to method to display filtered products
      },
    );
  }

  // Tab 3: On the Way
  Widget _buildOnTheWayTab() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('UserEntity')
          .doc(widget.currentUserId) // Fetch the current user's document
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading spinner
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
              child: Text("No user data found"
                  .tr)); // Handle case if user data doesn't exist
        }

        // Fetch the list of product IDs from the auctionedWinProduct array in UserEntity
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final List<String> auctionedProductIds =
            List<String>.from(userData['auctionedWinProduct'] ?? []);

        if (auctionedProductIds.isEmpty) {
          return Center(
              child: Text("No auctioned products found."
                  .tr)); // Handle case where no products are auctioned
        }

        // Query the products collection for the products whose IDs are in the auctionedProductIds list
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where(FieldPath.documentId,
                  whereIn:
                      auctionedProductIds) // Filter products based on auctioned IDs
              .snapshots(),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading spinner
            }

            if (!productSnapshot.hasData ||
                productSnapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text("No products found"
                      .tr)); // Handle case where no products are found
            }

            List<ProductEntity> onTheWayProducts = productSnapshot.data!.docs
                .map((doc) =>
                    ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
                .where((product) {
              // Filter out sold and inactive products
              return product.isActive == true && product.isSold == false;
            }).toList();

            return _buildProductList(onTheWayProducts); // Display the products
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

  // Helper method to build the product list for any tab
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

  // Build the category tabs
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

  // Build the product card
  Widget _buildProductCard(ProductEntity product) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 6,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Row(
        children: [
          ClipRRect(
            // borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            child: Image.network(
              (product.images != null &&
                      product.images!.isNotEmpty &&
                      product.images!.first.isNotEmpty)
                  ? product.images!.first
                  : '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),

            //  Image.network(
            //   (product.images != null && product.images!.isNotEmpty)
            //       ? product.images!.first
            //       : 'https://via.placeholder.com/100',
            //   width: 100,
            //   height: 100,
            //   fit: BoxFit.cover,
            // ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title ?? "No title",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description ?? "No description"),
                  Text(
                    "${product.price ?? '0'} ₽",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

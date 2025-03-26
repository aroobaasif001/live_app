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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: widget.currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("no_products_found".tr));
          }

          List<ProductEntity> allProducts = snapshot.data!.docs.map((doc) =>
              ProductEntity.fromJson(doc.data() as Map<String, dynamic>)).toList();

          List<ProductEntity> soldProducts = allProducts.where((product) => product.isSold == true).toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildCategoryTabs(),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      Text("All Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...allProducts.map((product) => GestureDetector(

                          onTap: (){Get.to(()=>ProductDetailScreen(product: product));},
                          child


                          : _buildProductCard(product))).toList(),
                      const SizedBox(height: 20),
                      Text("Sold Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...soldProducts.map((product) => _buildSoldProductCard(product)).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildProductCard(ProductEntity product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12)),
            child: Image.network(
              (product.images != null && product.images!.isNotEmpty)
                  ? product.images!.first
                  : 'https://via.placeholder.com/100',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
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

  Widget _buildSoldProductCard(ProductEntity product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12)),
            child: Image.network(
              (product.images != null && product.images!.isNotEmpty)
                  ? product.images!.first
                  : 'https://via.placeholder.com/100',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
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
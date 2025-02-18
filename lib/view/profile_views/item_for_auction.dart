import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/entities/product_entity.dart';

class ItemAuctionScreen extends StatefulWidget {
  const ItemAuctionScreen({super.key});

  @override
  State<ItemAuctionScreen> createState() => _ItemAuctionScreenState();
}

class _ItemAuctionScreenState extends State<ItemAuctionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search by product name...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim().toLowerCase();
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black54),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildFilterButton("Sort", Icons.sort),
                  const SizedBox(width: 8),
                  _buildFilterButton("Category", Icons.category),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("products").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No auction products available"),
                      );
                    }
                    List<ProductEntity> products = snapshot.data!.docs
                        .map((doc) =>
                            ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
                        .toList();
                    products =
                        products.where((p) => p.saleType == "Auction").toList();
                    if (_searchQuery.isNotEmpty) {
                      products = products.where((p) {
                        final title = p.title?.toLowerCase() ?? "";
                        return title.contains(_searchQuery);
                      }).toList();
                    }

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("No matching products found"),
                      );
                    }

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildAuctionItem(products[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildFilterButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.black),
      label: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  Widget _buildAuctionItem(ProductEntity product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
  
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  (product.images != null && product.images!.isNotEmpty)
                      ? product.images!.first
                      : 'https://via.placeholder.com/150',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              // Positioned(
              //   bottom: 4,
              //   left: 4,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              //     decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       "Queue: ${product.queue ?? 0}",
              //       style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 12,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? "No Title",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(product.description ?? "No Description",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(
                  "${product.startingBid ?? 0} ₽ current bid",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                  
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Put on stream",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

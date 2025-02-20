import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../homeScreen/widgets/show_bet_bottom_sheet.dart';

class CurrentProductContainer extends StatelessWidget {
  final String channelId;
  final String name;
  final String photo;

  const CurrentProductContainer({Key? key, required this.channelId, required this.name, required this.photo}) : super(key: key);

  // Function to show bottom sheet for placing a bid


  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .4,
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('livestreams')
            .doc(channelId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No livestream data found.');
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Text('');
          }

          final currentProductId = data['currentProduct'] as String?;
          if (currentProductId == null || currentProductId.isEmpty) {
            return const Text('');
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .doc(currentProductId)
                .snapshots(),
            builder: (context, productSnapshot) {
              if (productSnapshot.hasError) {
                return Text('Error: ${productSnapshot.error}');
              }
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                return Text('No product found for ID: $currentProductId');
              }

              final productData = productSnapshot.data!.data() as Map<String, dynamic>?;
              if (productData == null) {
                return Text('Product data is empty for ID: $currentProductId');
              }

              final productTitle = productData['title'] ?? 'No Title';
              final productCategory = productData['category'] ?? 'No Category';
              final productDescription = productData['description'] ?? 'No Description';
              final productImages = productData['images'] as List<dynamic>? ?? [];
              final productImage = productImages.isNotEmpty ? productImages[0] : null;
              final productPrice = productData['price'];
              final productSaleType = productData['saleType'] ?? '';
              final productStartingBid = productData['startingBid'];
              final productDelivery = productData['delivery'] ?? 'No Delivery';

              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (productImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            productImage,
                            width: double.infinity,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 90,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        productTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   'Category: $productCategory\nDelivery: $productDelivery',
                      //   style: const TextStyle(fontSize: 14, color: Colors.grey),
                      // ),
                      // const SizedBox(height: 2),
                      Text(
                        productDescription,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        productSaleType == 'Auction'
                            ? 'Starting Bid: \$${productStartingBid ?? 0}'
                            : 'Price: \$${productPrice ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ensure the minimum bid is parsed as a double if it's coming as a String
                            double minimumBid = 0.0;
                            if (productStartingBid is String) {
                              minimumBid = double.tryParse(productStartingBid) ?? 0.0;
                            } else if (productStartingBid is double) {
                              minimumBid = productStartingBid;
                            }

                            // Show the bottom sheet with the minimum bid
                            showBetBottomSheet(context, minimumBid , name ,photo , channelId);
                          },
                          child: const Text('Bid Now'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

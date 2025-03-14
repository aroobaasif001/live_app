import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../homeScreen/widgets/show_bet_bottom_sheet.dart';

class CurrentProductContainer extends StatelessWidget {
  final String channelId;
  final String name;
  final String photo;

  const CurrentProductContainer({
    Key? key,
    required this.channelId,
    required this.name,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.21,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Optional: add background color or styling here
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('livestreams')
            .doc(channelId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No livestream data found.',
                style: TextStyle(color: Colors.white));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Text('', style: TextStyle(color: Colors.white));
          }

          final currentProductId = data['currentProduct'] as String?;
          if (currentProductId == null || currentProductId.isEmpty) {
            return const Text('', style: TextStyle(color: Colors.white));
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .doc(currentProductId)
                .snapshots(),
            builder: (context, productSnapshot) {
              if (productSnapshot.hasError) {
                return Text('Error: ${productSnapshot.error}',
                    style: const TextStyle(color: Colors.white));
              }
              if (productSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!productSnapshot.hasData ||
                  !productSnapshot.data!.exists) {
                return Text(
                  'No product found for ID: $currentProductId',
                  style: const TextStyle(color: Colors.white),
                );
              }

              final productData =
              productSnapshot.data!.data() as Map<String, dynamic>?;
              if (productData == null) {
                return Text(
                  'Product data is empty for ID: $currentProductId',
                  style: const TextStyle(color: Colors.white),
                );
              }   final productDoc = productSnapshot.data!;
              final productId = productDoc.id; // ✅ Product ID

              final productTitle = productData['title'] ?? 'No Title';
              final productDescription =
                  productData['description'] ?? 'No Description';
              final productPrice = productData['price'] ?? 0;
              final productSaleType = productData['saleType'] ?? '';
              final productStartingBid = productData['startingBid'] ?? 0;

              // Use startingBid if it's an Auction; otherwise, use productPrice.
              final displayPrice = productSaleType == 'Auction'
                  ? productStartingBid
                  : productPrice;

              final priceText = '$displayPrice P';

              double minimumBid = 0.0;
              if (productStartingBid is String) {
                minimumBid = double.tryParse(productStartingBid) ?? 0.0;
              } else if (productStartingBid is num) {
                minimumBid = productStartingBid.toDouble();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top area for product details
                  Flexible(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                productDescription,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Delivery & Payment',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Price info
                        Text(
                          priceText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom area for the bid button
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            showBetBottomSheet(
                              context,
                              minimumBid,
                              name,
                              photo,
                              channelId,
                                productId
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF3A8EF2), // Blue
                                  Color(0xFFD53F8C), // Pink/Purple
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Bid: $displayPrice >>',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}



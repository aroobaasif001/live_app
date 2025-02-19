import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentProductContainer extends StatelessWidget {
  final String channelId;
  const CurrentProductContainer({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add styling or constraints as needed:
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<DocumentSnapshot>(
        // 1) Listen to the livestreams doc for the given channelId.
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

          // Extract the currentProduct field
          final currentProductId = data['currentProduct'] as String?;
          if (currentProductId == null || currentProductId.isEmpty) {
            return const Text('');
          }

          // 2) If we have a currentProduct ID, listen to that product doc.
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

              // Extract product fields
              final productTitle = productData['title'] ?? 'No Title';
              final productCategory = productData['category'] ?? 'No Category';
              final productDescription = productData['description'] ?? 'No Description';
              final productImages = productData['images'] as List<dynamic>? ?? [];
              final productImage =
              productImages.isNotEmpty ? productImages[0] : null;
              final productPrice = productData['price'];
              final productSaleType = productData['saleType'] ?? '';
              final productStartingBid = productData['startingBid'];
              final productDelivery = productData['delivery'] ?? 'No Delivery';

              // Display the product info in a Card or any layout you prefer
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adjusts to fit content
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the first image or a placeholder
                      if (productImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            productImage,
                            width: double.infinity,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        productTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Category and Delivery
                      Text(
                        'Category: $productCategory\nDelivery: $productDelivery',
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 8),

                      // Description
                      Text(
                        productDescription,
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 8),

                      // Price or starting bid
                      Text(
                        productSaleType == 'Auction'
                            ? 'Starting Bid: ${productStartingBid ?? 0}'
                            : 'Price: ${productPrice ?? 0}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
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

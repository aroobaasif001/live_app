import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Shows a full-height bottom sheet with the current user's products in a grid layout.
/// Tapping a product updates the 'currentProduct' field of the [channelId] document in 'livestreams'.
void showUserProductsBottomSheet(BuildContext context, String channelId) {
  // Get the current user
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Handle unauthenticated state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not logged in.')),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    // Make the bottom sheet take up the full screen height.
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // So we can style the container inside.
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        // Allows the bottom sheet to be dragged to full screen.
        expand: false,
        initialChildSize: 0.9, // Start at 90% of screen height
        minChildSize: 0.5,     // Minimum height
        maxChildSize: 0.95,    // Maximum height
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            // A container to style the main content area.
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              // Query the "products" collection where 'id' equals the current user's uid.
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('id', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;
                if (products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                // Use a GridView to display two items per row.
                return GridView.builder(
                  controller: scrollController, // Connect to DraggableScrollableSheet
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,      // Two items per row
                    crossAxisSpacing: 16,   // Spacing between columns
                    mainAxisSpacing: 16,    // Spacing between rows
                    childAspectRatio: 0.7,  // Adjust to control item height
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final data = products[index].data() as Map<String, dynamic>;

                    // Extract fields from the product document.
                    final productDocId = products[index].id; // Document ID
                    final productTitle = data['title'] ?? 'No Title';
                    final productCategory = data['category'] ?? 'No Category';
                    final productDelivery = data['delivery'] ?? 'No Delivery';
                    final productDescription =
                        data['description'] ?? 'No Description';
                    final productImages = data['images'] as List<dynamic>? ?? [];
                    final productImage = productImages.isNotEmpty
                        ? productImages[0]
                        : null;
                    final productLiveOnly = data['liveOnly'] ?? false;
                    final productPrice = data['price'];
                    final productSaleType = data['saleType'] ?? '';
                    final productStartingBid = data['startingBid'];

                    // Build a card for each product.
                    return GestureDetector(
                      onTap: () async {
                        try {
                          // Update the livestreams document with the given channelId
                          // to set the 'currentProduct' field to the tapped product's doc ID.
                          await FirebaseFirestore.instance
                              .collection('livestreams')
                              .doc(channelId)
                              .update({'currentProduct': productDocId});

                          // Show a confirmation.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Livestream updated with product ID.'),
                            ),
                          );

                          // Close the bottom sheet after a successful update (optional).
                          Navigator.of(context).pop();
                        } catch (e) {
                          // Show an error message if the update fails.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating livestream: $e')),
                          );
                        }
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display product image (or a placeholder) at the top.
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: productImage != null
                                    ? Image.network(
                                  productImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                                    : Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Product info
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                productTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                productCategory,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                productDelivery,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                productSaleType == 'Auction'
                                    ? 'Starting Bid: ${productStartingBid ?? 0}'
                                    : 'Price: ${productPrice ?? 0}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),

                            // Optional: Show if it's "Live Only"
                            if (productLiveOnly)
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Live Only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      );
    },
  );
}

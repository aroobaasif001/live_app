import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../homeScreen/widgets/show_bet_bottom_sheet.dart';

class CurrentProductContainer extends StatelessWidget {
  final String channelId;
  final String name;
  final String photo;
  final bool isAdmin; // Added isAdmin parameter to constructor

  const CurrentProductContainer({
    Key? key,
    required this.channelId,
    required this.name,
    required this.photo,
    required this.isAdmin, // Accept isAdmin as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink(); // Hide on error
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Hide while loading
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink(); // Hide if no livestream data
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null) return const SizedBox.shrink();

        final currentProductId = data['currentProduct'] as String?;

        if (currentProductId == null || currentProductId.isEmpty) {
          return const SizedBox.shrink(); // Hide if no product ID
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(currentProductId)
              .snapshots(),
          builder: (context, productSnapshot) {
            if (productSnapshot.hasError) return const SizedBox.shrink();
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
              return const SizedBox.shrink(); // Hide if no product
            }

            final productData =
            productSnapshot.data!.data() as Map<String, dynamic>?;
            if (productData == null) return const SizedBox.shrink();

            final productDoc = productSnapshot.data!;
            final productId = productDoc.id;
            final productTitle = productData['title'] ?? 'No Title';
            final productDescription =
                productData['description'] ?? 'No Description';
            final productPrice = productData['price'] ?? 0;
            final productSaleType = productData['saleType'] ?? '';
            final productStartingBid = productData['startingBid'] ?? 0;

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

            // Admin check: Added via constructor
            return Container(
              height: Get.height * 0.3,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
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
                        Column(
                          children: [
                            Text(
                              priceText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

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
                                        productId,
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
                            )
                          ],
                        ),




                      ],
                    ),
                  ),
                  // If the user is an admin, show the bidders and sell button

                  if (isAdmin)
                    Column(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .doc(currentProductId)
                              .snapshots(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Show loading spinner
                            }

                            if (productSnapshot.hasError) {
                              return Text('Error: ${productSnapshot.error}', style: TextStyle(color: Colors.black)); // Show error if there's an issue
                            }

                            if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                              return const Text('Product not found', style: TextStyle(color: Colors.black)); // Handle case where product doesn't exist
                            }

                            final productData = productSnapshot.data!.data() as Map<String, dynamic>?;
                            if (productData == null) {
                              return const Text('No data available', style: TextStyle(color: Colors.black));
                            }

                            // Get the bidders map (which contains bid amounts)
                            final biddersMap = productData['bidders'] as Map<String, dynamic>?;

                            if (biddersMap == null || biddersMap.isEmpty) {
                              return const Text('No bidders available', style: TextStyle(color: Colors.black)); // No bidders in the map
                            }

                            // Convert the bidders map into a list with bidder ID (uid) and bid amount
                            final bidders = biddersMap.entries
                                .map((entry) {
                              return {
                                'id': entry.key, // bidder ID (user UID)
                                'bidAmount': entry.value, // bidder bid amount
                              };
                            })
                                .toList();

                            // Sort bidders by bid amount in descending order
                            bidders.sort((a, b) => (b['bidAmount'] as num).compareTo(a['bidAmount'] as num));

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: bidders.length,
                              itemBuilder: (context, index) {
                                final bidder = bidders[index];
                                final bidderId = bidder['id'] ?? 'Unknown'; // bidder UID (used as name for now)
                                final bidAmount = bidder['bidAmount'] ?? 0;
                                final isTopBidder = index == 0;

                                return ListTile(
                                  title: Text(
                                    bidderId.split(' ').take(5).join(' '), // Display only the first 5 words of bidderId
                                    style: TextStyle(
                                      color: isTopBidder ? Colors.blue : Colors.white,
                                    ),
                                  ),

                                  trailing: Column(
                                    children: [
                                      Text('$bidAmount P'),


                                      GestureDetector(
                                        onTap: () async {
                                          if (bidders.isNotEmpty) {
                                            // Get the top bidder
                                            final topBidder = bidders[0];

                                            // Add to UserEntity collection (winner of the auction)
                                            await FirebaseFirestore.instance
                                                .collection('UserEntity')
                                                .doc(topBidder['id'])
                                                .update({
                                              'auctionedWinProduct':
                                              FieldValue.arrayUnion([currentProductId]),
                                            });

                                            // Handle success (e.g., show a message or refresh UI)
                                          }
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
                                          'Sell',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),)

                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                ],
              ),
            );
          },
        );
      },
    );
  }
}

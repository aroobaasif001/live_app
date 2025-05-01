import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';

import '../../../../entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  Future<void> _submitRating(String productId, double userRating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('ratings')
          .doc(user.uid)
          .set({
        'rating': userRating,
        'ratedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print('Error while submitting rating: $error');
    }
  }

  void _showRatingDialog(BuildContext context) {
    double userRating = 0.0;
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Rate this product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How would you rate this product?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < userRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() => userRating = i + 1.0);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  '${userRating.toInt()} ${userRating == 1 ? 'star' : 'stars'}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (product.id != null) {
                    await _submitRating(product.id!, userRating);
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanks for your rating!')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── PRODUCT IMAGE ─────────────────────────
            CustomContainer(
              height: 376,
              width: double.infinity,
              image: DecorationImage(
                image: (product.images != null && product.images!.isNotEmpty)
                    ? NetworkImage(product.images!.first)
                    : AssetImage(iphoneImage) as ImageProvider,
                fit: BoxFit.fill,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, right: 12),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Get.back(),
                    icon: CustomContainer(
                      height: 30,
                      width: 30,
                      conColor: Colors.white,
                      shape: BoxShape.circle,
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ─── BASIC DETAILS ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: product.title ?? 'Unknown Product',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded',
                  ),
                  const SizedBox(height: 6),
                  CustomText(
                    text:
                    '${product.category ?? 'Unknown'} – ${product.saleType ?? 'N/A'}',
                    fontFamily: 'Gilroy',
                    fontSize: 17,
                  ),
                  const SizedBox(height: 13),
                  CustomContainer(
                    height: 22,
                    width: 80,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(4),
                    conColor: const Color(0xff7246F1).withOpacity(0.1),
                    child: CustomText(
                      text:
                      (product.isSold ?? false) ? 'Sold Out' : 'Available',
                      fontSize: 12,
                      color: const Color(0xff7246F1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTable(
                    leftText: 'Selling Price',
                    rightText: '${product.price ?? 'N/A'} ₽',
                  ),
                  CustomTable(
                    leftText: 'Type of Sale',
                    rightText: product.saleType ?? 'N/A',
                    conColor: Colors.white,
                  ),
                  CustomTable(
                    leftText: 'Streamer',
                    rightText: product.streamer ?? 'Unknown',
                  ),
                  CustomTable(
                    leftText: 'Delivery',
                    rightText: product.delivery ?? 'N/A',
                    conColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: conLineColor),
                  const SizedBox(height: 12),

                  // ─── AVERAGE RATING ────────────────────────
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .doc(product.id)
                        .collection('ratings')
                        .snapshots(),
                    builder: (ctx, snap) {
                      if (snap.hasError) {
                        return const Text('Error loading ratings');
                      }
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final docs = snap.data!.docs;
                      double total = 0;
                      for (var d in docs) {
                        final m = d.data() as Map<String, dynamic>? ?? {};
                        total += (m['rating'] is num
                            ? m['rating'].toDouble()
                            : 0.0);
                      }
                      final avg = docs.isNotEmpty ? total / docs.length : 0.0;
                      return Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            'Average Rating: ${avg.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ─── ABOUT THE PRODUCT ─────────────────────
                  AboutTheProductScreen(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // ─── FLOATING ACTIONS ─────────────────────────
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'rateButton',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () => _showRatingDialog(context),
            child: const Icon(Icons.star, color: Colors.amber),
          ),
          const SizedBox(height: 10),
          CustomContainer(
            height: 50,
            width: 120,
            borderRadius: BorderRadius.circular(100),
            conColor: Colors.white,
            boxShadow: [
              BoxShadow(
                color: greyColor,
                blurRadius: 5,
                offset: const Offset(-1, 3),
              ),
            ],
            child: Center(
              child: CustomContainer(
                height: 44,
                width: 111,
                borderRadius: BorderRadius.circular(100),
                gradient: primaryGradientColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomContainer(
                      height: 24,
                      width: 24,
                      image: DecorationImage(
                        image: AssetImage(storeIcon),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: '${product.price} ₽',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

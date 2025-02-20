import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import '../../entities/product_entity.dart';

class SoldProductsScreen extends StatefulWidget {
  const SoldProductsScreen({super.key});

  @override
  State<SoldProductsScreen> createState() => _SoldProductsScreenState();
}

class _SoldProductsScreenState extends State<SoldProductsScreen> {
  Stream<QuerySnapshot<ProductEntity>> getAllProduct =
  ProductEntity.collection().where("isSold", isEqualTo: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: CustomText(text: "Sold Products", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      body: StreamBuilder(
        stream: getAllProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: CustomText(text: "No sold products found", color: Colors.white));
          }

          return SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var productData = snapshot.data!.docs[index].data();
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.only(bottom: 15),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            productData.images!.isNotEmpty ? productData.images![0] : "",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      text: productData.title ?? "No Title",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  CustomGradientButton(
                                    text: "Sold",
                                    width: 80,
                                    height: 30,
                                    borderRadius: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              CustomText(
                                text: "Category : ${productData.category.toString()}",
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 5),
                              CustomText(
                                text: "Quantity : ${productData.quantity.toString()}",
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 5),
                              CustomText(
                                text: "Sold Price : \$${productData.soldPrice.toString()}",
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

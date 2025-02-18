import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/view/market/tabs/add_to_card/add_to_card_screen.dart';
import 'package:live_app/view/market/tabs/fix_card_screen.dart';

import '../../custom_widgets/custom_container.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../entities/product_entity.dart';
import '../../utils/images_path.dart';

class GetAllGoods extends StatefulWidget {
  const GetAllGoods({super.key});

  @override
  State<GetAllGoods> createState() => _GetAllGoodsState();
}

class _GetAllGoodsState extends State<GetAllGoods> {
  Stream<QuerySnapshot<ProductEntity>> getAllProduct =
      ProductEntity.collection().snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<ProductEntity>>(
      stream: getAllProduct,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<ProductEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data available');
        }
        final data = snapshot.data!;
        return Flexible(
          child: ListView.builder(
            itemCount: data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var productResponse = data.docs[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      height: 136,
                      width: 136,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: (productResponse.images != null && productResponse.images!.isNotEmpty)
                            ? NetworkImage(productResponse.images!.first)
                            : AssetImage(marketImage) as ImageProvider,
                        fit: BoxFit.fill,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomGradientButton(
                                height: 21,
                                width: 31,
                                fontSize: 10,
                                text: 'Fix',
                                onPressed: () {
                                  Get.to(() => FixCardScreen(
                                    productImage:productResponse.images!.first,
                                    productName:productResponse.title,
                                    productPrice: productResponse.startingBid,
                                    productCompanyId:productResponse.id,
                                  ));
                                }),
                            CustomContainer(
                              height: 30,
                              width: 45,
                              conColor: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.notifications_none_rounded,
                                      size: 16),
                                  SizedBox(width: 3),
                                  CustomText(text: '1')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: productResponse.title!,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: productResponse.description!,
                          ),
                          CustomText(
                            text: productResponse.price == null
                                ? '${productResponse.startingBid ?? '0'} ₽'
                                : '${productResponse.price} ₽',
                            fontWeight: FontWeight.bold,
                          ),

                          SizedBox(height: 25),
                          CustomGradientButton(
                            text: 'Add to Card',
                            onPressed: () {
                              Get.to(() => ProductDetailScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              );
            },
          ),
        );
      },
    );
  }
}

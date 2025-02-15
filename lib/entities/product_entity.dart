import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_entity.g.dart';

@JsonSerializable()
class ProductEntity {
  String? productId;
  String? category;
  String? title;
  String? description;
  int quantity;
  String typeOfSale;
  double? startingBid;
  bool selfDestruct;
  bool livePurchase;
  String? streamer;
  String? delivery;
  List<String>? images;

  ProductEntity({
    this.productId,
    this.category,
    this.title,
    this.description,
    this.quantity = 1,
    this.typeOfSale = "Auction",
    this.startingBid,
    this.selfDestruct = false,
    this.livePurchase = true,
    this.streamer,
    this.delivery,
    this.images,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);

  static CollectionReference<ProductEntity> collection() {
    return FirebaseFirestore.instance
        .collection('Products')
        .withConverter<ProductEntity>(
          fromFirestore: (snapshot, options) =>
              ProductEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static DocumentReference<ProductEntity> doc({required String productId}) {
    return FirebaseFirestore.instance
        .doc('Products/$productId')
        .withConverter<ProductEntity>(
          fromFirestore: (snapshot, options) =>
              ProductEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}

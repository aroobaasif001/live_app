import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_entity.g.dart';

@JsonSerializable()
class ProductEntity {
  final String? id;
  final String? category;
  final String? title;
  final String? description;
  final String? quantity;
  final String? saleType;
  final String? startingBid;
  final String? price;
  final bool? selfDestruct;
  final bool? liveOnly;
  final String? streamer;
  final String? delivery;
  final List<String>? images;
  final bool? isActive;
  final bool? isSold;

  ProductEntity(
      {this.id,
      this.category,
      this.title,
      this.description,
      this.quantity,
      this.saleType,
      this.startingBid,
      this.price,
      this.selfDestruct,
      this.liveOnly,
      this.streamer,
      this.delivery,
      this.images,
      this.isActive,
      this.isSold});



  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);

  static CollectionReference<ProductEntity> collection() {
    return FirebaseFirestore.instance
        .collection('products')
        .withConverter<ProductEntity>(
          fromFirestore: (snapshot, options) =>
              ProductEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static DocumentReference<ProductEntity> doc({required String productId}) {
    return FirebaseFirestore.instance
        .doc('products/$productId')
        .withConverter<ProductEntity>(
          fromFirestore: (snapshot, options) =>
              ProductEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}

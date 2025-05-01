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
  final String? soldPrice;
  final bool? selfDestruct;
  final bool? liveOnly;
  final String? streamer;
  final String? delivery;
  final List<String>? images;
  final bool? isActive;
  final bool? isSold;
  final int saveCount;
  final Map<String, dynamic>? bidders; // Store bidders as a Map<String, dynamic>

  ProductEntity({
    this.id,
    this.category,
    this.title,
    this.description,
    this.quantity,
    this.saleType,
    this.startingBid,
    this.price,
    this.soldPrice,
    this.selfDestruct,
    this.liveOnly,
    this.streamer,
    this.delivery,
    this.images,
    this.isActive,
    this.isSold,
    this.bidders,
    this.saveCount = 0,
  });

  // Factory constructor to create ProductEntity from Firestore data
  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  // Method to convert ProductEntity to Firestore document data
  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);

  // Firestore reference for products collection with type conversion
  static CollectionReference<ProductEntity> collection() {
    return FirebaseFirestore.instance
        .collection('products')
        .withConverter<ProductEntity>(
      fromFirestore: (snapshot, options) =>
          ProductEntity.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  // Firestore reference for a specific product document
  static DocumentReference<ProductEntity> doc({required String productId}) {
    return FirebaseFirestore.instance
        .doc('products/$productId')
        .withConverter<ProductEntity>(
      fromFirestore: (snapshot, options) =>
          ProductEntity.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  // Helper function to check if currentUserId is a bidder
  bool isBidder(String userId) {
    return bidders?.containsKey(userId) ?? false; // Checks if userId is a key in bidders map
  }
}

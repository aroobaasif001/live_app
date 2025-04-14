// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      id: json['id']?.toString(),
      category: json['category']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      quantity: json['quantity']?.toString(),
      saleType: json['saleType']?.toString(),
      startingBid: json['startingBid']?.toString(),
      price: json['price']?.toString(),
      soldPrice: json['soldPrice']?.toString(),
      selfDestruct: json['selfDestruct'] ?? false,
      liveOnly: json['liveOnly'] ?? false,
      streamer: json['streamer']?.toString(),
      delivery: json['delivery']?.toString(),
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      isActive: json['isActive'] ?? false,
      isSold: json['isSold'] ?? false,
      bidders: Map<String, dynamic>.from(json['bidders'] ?? {}),
      // id: json['id'] as String?,
      // category: json['category'] as String?,
      // soldPrice: json['soldPrice'] as String?,
      // title: json['title'] as String?,
      // description: json['description'] as String?,
      // quantity: json['quantity'] as String?,
      // saleType: json['saleType'] as String?,
      // startingBid: json['startingBid'] as String?,
      // price: json['price'] as String?,
      // selfDestruct: json['selfDestruct'] as bool?,
      // liveOnly: json['liveOnly'] as bool?,
      // streamer: json['streamer'] as String?,
      // delivery: json['delivery'] as String?,
      // images:
      //     (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      // isActive: json['isActive'] as bool?,
      // isSold: json['isSold'] as bool?,
      //     bidders: json['bidders'] as Map<String, dynamic>?, // Deserialize bidders here
    );

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'quantity': instance.quantity,
      'saleType': instance.saleType,
      'startingBid': instance.startingBid,
      'price': instance.price,
      'soldPrice': instance.soldPrice,
      'selfDestruct': instance.selfDestruct,
      'liveOnly': instance.liveOnly,
      'streamer': instance.streamer,
      'delivery': instance.delivery,
      'images': instance.images,
      'isActive': instance.isActive,
      'isSold': instance.isSold,
      'bidders': instance.bidders, // Serialize bidders here
    };

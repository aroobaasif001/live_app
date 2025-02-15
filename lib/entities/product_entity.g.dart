// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      productId: json['productId'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      typeOfSale: json['typeOfSale'] as String? ?? "Auction",
      startingBid: (json['startingBid'] as num?)?.toDouble(),
      selfDestruct: json['selfDestruct'] as bool? ?? false,
      livePurchase: json['livePurchase'] as bool? ?? true,
      streamer: json['streamer'] as String?,
      delivery: json['delivery'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'quantity': instance.quantity,
      'typeOfSale': instance.typeOfSale,
      'startingBid': instance.startingBid,
      'selfDestruct': instance.selfDestruct,
      'livePurchase': instance.livePurchase,
      'streamer': instance.streamer,
      'delivery': instance.delivery,
      'images': instance.images,
    };

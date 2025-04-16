// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationEntity _$RegistrationEntityFromJson(Map<String, dynamic> json) =>
    RegistrationEntity(
          delivery: json['delivery'] as String?,
          sold: json['sold'] as String?,
          reviews: json['reviews'] as String?,
          rating: json['rating'] as String?,
          regId: json['regId'] as String?,
          firstName: json['firstName'] as String?,
          lastName: json['lastName'] as String?,
          email: json['email'] as String?,
          gender: json['gender'] as String?,
          country: json['country'] as String?,
          city: json['city'] as String?,
          street: json['street'] as String?,
          house: json['house'] as String?,
          apartment: json['apartment'] as String?,
          entrance: json['entrance'] as String?,
          index: json['index'] as String?,
          interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          detailedInterests: (json['detailedInterests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          image: json['image'] as String?,
          coverImage: json['coverImage'] as String?,
          isBlocked: json['isBlocked'] as bool?,  // ✅ NEW FIELD
          isUserNew: json['isUserNew'] as bool?,  // ✅ NEW FIELD
    );

Map<String, dynamic> _$RegistrationEntityToJson(RegistrationEntity instance) =>
    <String, dynamic>{
          'regId': instance.regId,
          'firstName': instance.firstName,
          'lastName': instance.lastName,
          'email': instance.email,
          'gender': instance.gender,
          'country': instance.country,
          'city': instance.city,
          'street': instance.street,
          'house': instance.house,
          'apartment': instance.apartment,
          'entrance': instance.entrance,
          'index': instance.index,
          'interests': instance.interests,
          'detailedInterests': instance.detailedInterests,
          'image': instance.image,
          'coverImage': instance.coverImage,
          'rating': instance.rating,
          'reviews': instance.reviews,
          'sold': instance.sold,
          'delivery': instance.delivery,
          'isBlocked': instance.isBlocked,  // ✅ NEW FIELD
          'isUserNew': instance.isUserNew,  // ✅ NEW FIELD
    };

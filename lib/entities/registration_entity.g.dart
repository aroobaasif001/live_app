// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationEntity _$RegistrationEntityFromJson(Map<String, dynamic> json) =>
    RegistrationEntity(
      regId: json['regId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$RegistrationEntityToJson(RegistrationEntity instance) =>
    <String, dynamic>{
      'regId': instance.regId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'gender': instance.gender,
      'country': instance.country,
    };

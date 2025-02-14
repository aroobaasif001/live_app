// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeProfileEntity _$TradeProfileEntityFromJson(Map<String, dynamic> json) =>
    TradeProfileEntity(
      companyProfileImage: json['companyProfileImage'] as String?,
      companyCoverImage: json['companyCoverImage'] as String?,
      companyName: json['companyName'] as String?,
      companyNickName: json['companyNickName'] as String?,
      aboutMe: json['aboutMe'] as String?,
      companyId: json['companyId'] as String?,
      companyDocId: json['companyDocId'] as String?,
    );

Map<String, dynamic> _$TradeProfileEntityToJson(TradeProfileEntity instance) =>
    <String, dynamic>{
      'companyProfileImage': instance.companyProfileImage,
      'companyCoverImage': instance.companyCoverImage,
      'companyName': instance.companyName,
      'companyNickName': instance.companyNickName,
      'aboutMe': instance.aboutMe,
      'companyId': instance.companyId,
      'companyDocId': instance.companyDocId,
    };

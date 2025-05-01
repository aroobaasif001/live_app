// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportEntity _$ReportEntityFromJson(Map<String, dynamic> json) => ReportEntity(
      reporterId: json['reporterId'] as String?,
      reporterName: json['reporterName'] as String?,
      reportText: json['reportText'] as String?,
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ReportEntityToJson(ReportEntity instance) =>
    <String, dynamic>{
      'reporterId': instance.reporterId,
      'reporterName': instance.reporterName,
      'reportText': instance.reportText,
      'createAt': instance.createAt?.toIso8601String(),
      'status': instance.status,
    };

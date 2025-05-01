import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_entity.g.dart';

@JsonSerializable()
class ReportEntity {
  final String? reporterId;
  final String? reporterName;
  final String? reportText;
  final DateTime? createAt;
  final String? status;

  ReportEntity({
    this.reporterId,
    this.reporterName,
    this.reportText,
    this.createAt,
    this.status,
  });

  factory ReportEntity.fromJson(Map<String, dynamic> json) => _$ReportEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ReportEntityToJson(this);

  static CollectionReference<ReportEntity> collection() {
    return FirebaseFirestore.instance.collection('reports').withConverter<ReportEntity>(
          fromFirestore: (snapshot, options) => ReportEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static DocumentReference<ReportEntity> doc({required String reportId}) {
    return FirebaseFirestore.instance.doc('reports/$reportId').withConverter<ReportEntity>(
          fromFirestore: (snapshot, options) => ReportEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}

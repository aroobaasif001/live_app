import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';


part 'trade_profile_entity.g.dart';

@JsonSerializable()
class TradeProfileEntity {
  String? companyProfileImage;
  String? companyCoverImage;
  String? companyName;
  String? companyNickName;
  String? aboutMe;
  String? companyId;
  String? companyDocId;

  TradeProfileEntity(
      {this.companyProfileImage,
      this.companyCoverImage,
      this.companyName,
      this.companyNickName,
      this.aboutMe,
      this.companyId,
      this.companyDocId});

  factory TradeProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$TradeProfileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TradeProfileEntityToJson(this);

  static CollectionReference<TradeProfileEntity> collection() {
    return FirebaseFirestore.instance
        .collection('TradeProfileEntity')
        .withConverter<TradeProfileEntity>(
          fromFirestore: (snapshot, options) =>
              TradeProfileEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static DocumentReference<TradeProfileEntity> doc(
      {required String companyId}) {
    return FirebaseFirestore.instance
        .doc('TradeProfileEntity/$companyId')
        .withConverter<TradeProfileEntity>(
          fromFirestore: (snapshot, options) =>
              TradeProfileEntity.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}

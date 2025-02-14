import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_entity.g.dart';

@JsonSerializable()
class RegistrationEntity {
  final String? regId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? country;
  final String? city;
  final String? street;
  final String? house;
  final String? apartment;
  final String? entrance;
  final String? index;
  final List<String>? interests;
  final List<String>? detailedInterests;

  RegistrationEntity({
    this.regId,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.country,
    this.city,
    this.street,
    this.house,
    this.apartment,
    this.entrance,
    this.index,
    this.interests,
    this.detailedInterests,  // ✅ Include in constructor
  });

  factory RegistrationEntity.fromJson(Map<String, dynamic> json) =>
      _$RegistrationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationEntityToJson(this);

  static CollectionReference<RegistrationEntity> collection() {
    return FirebaseFirestore.instance
        .collection('UserEntity')
        .withConverter<RegistrationEntity>(
      fromFirestore: (snapshot, options) =>
          RegistrationEntity.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  static DocumentReference<RegistrationEntity> doc({required String userId}) {
    return FirebaseFirestore.instance
        .doc('UserEntity/$userId')
        .withConverter<RegistrationEntity>(
      fromFirestore: (snapshot, options) =>
          RegistrationEntity.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
  }
}

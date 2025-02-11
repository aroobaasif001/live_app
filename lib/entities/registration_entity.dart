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

  RegistrationEntity(
      {this.regId,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.country});

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

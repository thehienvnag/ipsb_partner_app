// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id'] as int?,
    name: json['name'] as String?,
    role: json['role'] as String?,
    imageUrl: json['imageUrl'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    status: json['status'] as String?,
    store: json['store'] == null
        ? null
        : Store.fromJson(json['store'] as Map<String, dynamic>),
    building: json['building'] == null
        ? null
        : Building.fromJson(json['building'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'imageUrl': instance.imageUrl,
      'phone': instance.phone,
      'email': instance.email,
      'status': instance.status,
      'store': instance.store,
      'building': instance.building,
    };

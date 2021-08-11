// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locator_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocatorTag _$LocatorTagFromJson(Map<String, dynamic> json) {
  return LocatorTag(
    id: json['id'] as int?,
    macAddress: json['macAddress'] as String?,
    status: json['status'] as String?,
    updateTime: json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String),
    floorPlanId: json['floorPlanId'] as int?,
    locationId: json['locationId'] as int?,
    lastSeen: json['lastSeen'] == null
        ? null
        : DateTime.parse(json['lastSeen'] as String),
  );
}

Map<String, dynamic> _$LocatorTagToJson(LocatorTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'macAddress': instance.macAddress,
      'status': instance.status,
      'floorPlanId': instance.floorPlanId,
      'locationId': instance.locationId,
      'updateTime': instance.updateTime?.toIso8601String(),
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

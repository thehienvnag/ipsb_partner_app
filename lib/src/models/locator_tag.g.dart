// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locator_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocatorTag _$LocatorTagFromJson(Map<String, dynamic> json) {
  return LocatorTag(
    id: json['id'] as int?,
    uuid: json['uuid'] as String?,
    status: json['status'] as String?,
    updateTime: json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String),
    floorPlanId: json['floorPlanId'] as int?,
    locationId: json['locationId'] as int?,
    buildingId: json['buildingId'] as int?,
    locatorTagGroupId: json['locatorTagGroupId'] as int?,
    txPower: (json['txPower'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$LocatorTagToJson(LocatorTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'status': instance.status,
      'floorPlanId': instance.floorPlanId,
      'locationId': instance.locationId,
      'buildingId': instance.buildingId,
      'locatorTagGroupId': instance.locatorTagGroupId,
      'txPower': instance.txPower,
      'updateTime': instance.updateTime?.toIso8601String(),
    };

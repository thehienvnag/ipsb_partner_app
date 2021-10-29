import 'package:json_annotation/json_annotation.dart';

part 'locator_tag.g.dart';

@JsonSerializable()
class LocatorTag {
  final int? id;
  final String? uuid,
      status;
  final int? floorPlanId, locationId, buildingId, locatorTagGroupId;
  final double? txPower;
  final DateTime? updateTime;

  LocatorTag({
    this.id,
    this.uuid,
    this.status,
    this.updateTime,
    this.floorPlanId,
    this.locationId,
    this.buildingId,
    this.locatorTagGroupId,
    this.txPower
  });

  factory LocatorTag.fromJson(Map<String, dynamic> json) =>
      _$LocatorTagFromJson(json);

  Map<String, dynamic> toJson() => _$LocatorTagToJson(this);
}
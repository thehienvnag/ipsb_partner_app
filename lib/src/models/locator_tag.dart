import 'package:json_annotation/json_annotation.dart';

part 'locator_tag.g.dart';

@JsonSerializable()
class LocatorTag {
  final int? id;
  final String? macAddress,
      status;
  final int? floorPlanId, locationId;
  final DateTime? updateTime, lastSeen;

  LocatorTag({
    this.id,
    this.macAddress,
    this.status,
    this.updateTime,
    this.floorPlanId,
    this.locationId,
    this.lastSeen,
  });

  factory LocatorTag.fromJson(Map<String, dynamic> json) =>
      _$LocatorTagFromJson(json);

  Map<String, dynamic> toJson() => _$LocatorTagToJson(this);
}
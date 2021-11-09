import 'package:json_annotation/json_annotation.dart';

part 'building.g.dart';

@JsonSerializable()
class Building {
  final int? id;
  final String? name;

  Building({
    this.id,
    this.name,
  });

  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingToJson(this);
}

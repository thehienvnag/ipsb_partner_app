import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:json_annotation/json_annotation.dart';

import 'building.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final int? id;
  final String? name, role, imageUrl, phone, email, status;
  final String? accessToken, refreshToken;
  final Store? store;
  final Building? building;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Account({
    this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.phone,
    this.email,
    this.accessToken,
    this.refreshToken,
    this.status,
    this.store,
    this.building,
  });

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final int? id;
  final String? name,
      role,
      imageUrl,
      phone,
      email,
      status;
  final Store? store;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Account({
    this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.phone,
    this.email,
    this.status,
    this.store
  });

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

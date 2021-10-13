import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';

import 'package:json_annotation/json_annotation.dart';

part 'coupon_in_use.g.dart';

@JsonSerializable()
class CouponInUse {
  final int? id;
  final int? couponId, visitorId;
  final DateTime? redeemDate, applyDate, feedbackDate;
  final String? status, feedbackContent, feedbackImage, feedbackReply;
  final double? rateScore;
  final Coupon? coupon;
  final Account? visitor;

  CouponInUse({
    this.applyDate,
    this.couponId,
    this.id,
    this.visitorId,
    this.redeemDate,
    this.status,
    this.feedbackContent,
    this.feedbackImage,
    this.feedbackReply,
    this.feedbackDate,
    this.rateScore,
    this.coupon,
    this.visitor
  });

  factory CouponInUse.fromJson(Map<String, dynamic> json) =>
      _$CouponInUseFromJson(json);

  Map<String, dynamic> toJson() => _$CouponInUseToJson(this);
}

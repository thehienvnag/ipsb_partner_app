import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_in_use_service.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';
import 'package:ipsb_partner_app/src/services/api/store_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class ManageCouponController extends GetxController {

  /// Shared data
  final SharedStates sharedData = Get.find();

  final listCoupon = <Coupon>[].obs;
  ICouponInUseService _service = Get.find();
  IStoreService _storeService = Get.find();

  /// Get list all coupon of visitor feedback before
  final listCouponInUse = <CouponInUse>[].obs;

  /// Set list coupon of visitor feedback before
  Future<void> getCouponInUseByCoupon(int couponId) async {
    final paging = await _service.getCouponInUseByCouponId(couponId);
    listCouponInUse.value = paging.content ?? [];
  }

  void gotoFeedbackListDetails(Coupon coupon) {
    sharedData.couponDetail.value = coupon;
    Get.toNamed(Routes.feedbacks);
  }

  ICouponService couponService = Get.find();

  Future<void> getCouponsByStoreId() async {
    Paging<Coupon> paging = await couponService.getCouponsByStoreId(8);
    listCoupon.value = paging.content ?? [];
  }

  Future<void> removeCoupon(int couponId) async {
    await couponService.removeCoupon(couponId);
    Get.back();
    getCouponsByStoreId();
  }

  Future<void> createCoupon() async {
    await Get.toNamed(Routes.createCoupon);
    getCouponsByStoreId();
  }

  final contentReplyFeedback = "".obs;

  /// Set content when feedback
  void changeReplyFeedbackContent(String content) {
    contentReplyFeedback.value = content;
  }

  bool updateCoupon = false;

  Store? store;
  Future<Store?> getStoreById(int storeId) async {
    return await _storeService.getStoreById(storeId);
  }

  Future<void> getStoreInformation() async {
    store = await getStoreById(8);
  }

  void replyFeedback(int couponInUseId) async{
    BotToast.showLoading();
    updateCoupon = await _service.putReplyFeedbackCouponInUse(couponInUseId,contentReplyFeedback.value);
    if (updateCoupon) {
      BotToast.showText(
          text: "Reply Success !",
          textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
    }else{
      BotToast.showText(
          text: "Reply Failed !",
          textStyle: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
    }
    getCouponsByStoreId();
    BotToast.closeAllLoading();
  }

  final loadReplyFeedback = "".obs;

  void getReplyFeedback(List<CouponInUse> listFeedback, int couponInUseId) {
    for(int i = 0; i < listFeedback.length; i++){
      print('hey: ' + listFeedback[i].feedbackReply.toString());
      if(couponInUseId == listFeedback[i].id){
        if(listFeedback[i].feedbackReply != null){
          loadReplyFeedback.value = listFeedback[i].feedbackReply!;
        }else{
          loadReplyFeedback.value = "";
        }
      }
    }
  }

  void gotoCouponDetails(Coupon coupon) {
    sharedData.coupon.value = coupon;
    Get.toNamed(Routes.couponDetails);
  }

  @override
  void onInit() {
    super.onInit();
    getCouponsByStoreId();
    getStoreInformation();
  }
}

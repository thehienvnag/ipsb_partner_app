import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_in_use_service.dart';
import 'package:ipsb_partner_app/src/services/api/store_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class ManageFeedbackController extends GetxController {
  ICouponInUseService _service = Get.find();
  IStoreService _storeService = Get.find();

  /// Shared data
  final SharedStates sharedData = Get.find();

  /// Get list all coupon of visitor feedback before
  final listCouponInUse = <CouponInUse>[].obs;

  /// Set list coupon of visitor feedback before
  Future<void> getCouponInUse() async {
    final paging = await _service.getCouponInUseByStoreId(8);
    listCouponInUse.value = paging.content ?? [];
  }

  final couponInUseId = 0.obs;

  /// Set couponInuseId when feedback
  void changeReplyFeedback(int id) {
    couponInUseId.value = id;
  }

  final contentReplyFeedback = "".obs;

  /// Set content when feedback
  void changeReplyFeedbackContent(String content) {
    contentReplyFeedback.value = content;
  }

  bool updateCoupon = false;

  CouponInUse? couponInUse;
  Future<CouponInUse?> getCouponInUseById(int couponInUseId) async {
    return await _service.getCouponInUse(couponInUseId);
  }

  Store? store;
  Future<Store?> getStoreById(int storeId) async {
    return await _storeService.getStoreById(storeId);
  }

  Future<void> getStoreInformation() async {
    store = await getStoreById(8);
  }

  /// Set list coupon of visitor feedback before
  Future<void> getCouponInUseByCoupon(int couponId) async {
    final paging = await _service.getCouponInUseByCouponId(couponId);
    listCouponInUse.value = paging.content ?? [];
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
    getCouponInUseByCoupon(sharedData.couponDetail.value.id!.toInt());
    BotToast.closeAllLoading();
  }
  final loadReplyFeedback = "".obs;

  void getReplyFeedback(List<CouponInUse> listFeedback, int couponInUseId) {
    for(int i = 0; i < listFeedback.length; i++){
      if(couponInUseId == listFeedback[i].id){
        if(listFeedback[i].feedbackReply != null){
          loadReplyFeedback.value = listFeedback[i].feedbackReply!;
        }else{
          loadReplyFeedback.value = "";
        }
      }
    }
  }

  final indexViewMore = "".obs;

  void changeHideInfo(int indexFeedback){
    if(indexViewMore.value.compareTo(indexFeedback.toString()) == 0){
      indexViewMore.value = "";
    }else {
      indexViewMore.value = indexFeedback.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getStoreInformation();
    getCouponInUseByCoupon(sharedData.couponDetail.value.id!.toInt());
  }
}

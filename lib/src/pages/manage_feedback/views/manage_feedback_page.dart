import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/pages/manage_feedback/controllers/manage_feedback_controller.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:loading_animations/loading_animations.dart';

bool isExpanded = false;

class ManageFeedbackPage extends GetView<ManageFeedbackController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Danh sách đánh giá',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Obx(() {
        final listFeedbacks = controller.listCouponInUse;
        if (listFeedbacks.isEmpty) {
          return LoadingFlipping.circle(
            borderColor: Colors.cyan,
            borderSize: 3.0,
            size: 30.0,
            backgroundColor: Colors.cyanAccent,
            duration: Duration(milliseconds: 500),
          );
        } else {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                buildFeedbacks(context, listFeedbacks),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget buildFeedbacks(BuildContext context, List<CouponInUse> listFeedBack) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: listFeedBack.length,
      itemBuilder: (context, index) {
        final feedback = listFeedBack[index];
        return Card(
          margin: EdgeInsets.only(top: 10, left: 6, right: 6),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            feedback.visitor!.imageUrl.toString())),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedback.visitor!.name.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        RatingBar.builder(
                          initialRating: feedback.rateScore!.toDouble(),
                          itemSize: 18,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) => true,
                          updateOnDrag: true,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 18),
                    Text(
                      Formatter.dateCaculator(
                        feedback.feedbackDate,
                      ),
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: screenSize.width * 0.3,
                      height: 100,
                      child: feedback.feedbackImage != null
                          ? Card(
                              child: Image.network(
                                  feedback.feedbackImage.toString()))
                          : Image.network(
                              'https://pngimg.com/uploads/mouth_smile/mouth_smile_PNG42.png')),
                  Container(
                    width: screenSize.width * 0.58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feedback.coupon!.name.toString(),
                            style: TextStyle(fontSize: 19)),
                        Text(
                          feedback.feedbackContent.toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

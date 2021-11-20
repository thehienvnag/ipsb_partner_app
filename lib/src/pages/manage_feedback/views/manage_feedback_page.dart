import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/pages/manage_feedback/controllers/manage_feedback_controller.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:loading_animations/loading_animations.dart';

bool isExpanded = false;

class ManageFeedbackPage extends GetView<ManageFeedbackController> {
  final SharedStates sharedData = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back(closeOverlays: true);
          },
        ),
        title: Text(
          'Feedbacks List',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Obx(() {
        final listFeedbacks = controller.listCouponInUse;
        if (listFeedbacks.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: screenSize.width * 0.48,
                  width: screenSize.width * 0.48,
                  child: Image.asset(ConstImg.empty),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'No available feedbacks',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: screenSize.width * 0.7,
                  child: Text(
                    'Come back to check after receiving new feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                buildFeedbacks(context, listFeedbacks, controller),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget buildFeedbacks(BuildContext context, List<CouponInUse> listFeedBack,ManageFeedbackController controller) {
  final screenSize = MediaQuery.of(context).size;
  return ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: listFeedBack.length,
    itemBuilder: (context, index) {
      final feedback = listFeedBack[index];
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar( radius: 18, backgroundImage: NetworkImage(feedback.visitor!.imageUrl.toString())),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(feedback.visitor!.name.toString(),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                          RatingBar.builder(
                            initialRating: feedback.rateScore!.toDouble(),
                            itemSize: 20,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (value) => true,
                            updateOnDrag: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        Formatter.dateCaculator(feedback.feedbackDate),
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5,),
                      (feedback.feedbackReply == null) ?
                      Text('New !',style: TextStyle(color: Colors.red,fontSize: 15),)
                      : Text('Replied',style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w700),),
                    ],
                  ),
                ],
              ),
              Container(
                width: screenSize.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenSize.width * 0.72,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(feedback.feedbackContent.toString(), style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.changeHideInfo(index);
                      },
                        child: Text('View More',style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),)
                    ),
                  ],
                ),
              ),
              Obx((){
                return
                (controller.indexViewMore.value.compareTo(index.toString()) == 0) ?
                 Column(
                   children: [
                     Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width:  screenSize.width * 0.4,
                              height: screenSize.height * 0.2,
                              alignment: Alignment.centerLeft,
                              child: feedback.feedbackImage != null
                                  ? Card(child: Image.network(feedback.feedbackImage.toString()))
                                  : Image.network('https://pngimg.com/uploads/mouth_smile/mouth_smile_PNG42.png')
                          ),
                        ),
                      ],
                ),
                     (feedback.feedbackReply == null) ?
                     buildReplyForm(controller,feedback.id!.toInt()):
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                             margin: EdgeInsets.only(left: 7),
                             child: Icon(FontAwesomeIcons.share,size: 25,color: Colors.black45,)),
                         Container(
                           width: screenSize.width * 0.82,
                           margin: EdgeInsets.only(top: 15),
                           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                           decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 (controller.store.isNull) ? 'Loading...': controller.store!.name.toString(),
                                 style: Theme.of(context).textTheme.caption?.copyWith(
                                     fontWeight: FontWeight.w600, color: Colors.black,fontSize: 16),
                               ),
                               SizedBox(
                                 height: 4,
                               ),
                               Text(
                                 (controller.store.isNull) ? 'Loading...': feedback.feedbackReply.toString(),
                                 style: Theme.of(context).textTheme.caption?.copyWith(
                                     fontWeight: FontWeight.w300, color: Colors.black,fontSize: 13),
                               ),
                               SizedBox(height: 5)
                             ],
                           ),
                         ),
                       ],
                     ),
                   ],
                 ) : SizedBox();
              }),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildReplyForm(ManageFeedbackController controller, int couponInUseId){
  return Row(
    children: [
      Expanded (
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey,
              width: 0.1,
            ),
          ),
          child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Type a reply message',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                controller.changeReplyFeedbackContent(value);
              }),
        ),
      ),
      GestureDetector(
        onTap: (){
          controller.replyFeedback(couponInUseId);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Icon(Icons.send, color: Colors.white),
        ),
      )
    ],
  );
}


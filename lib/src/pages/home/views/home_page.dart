import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/home/controllers/home_controller.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:comment_tree/comment_tree.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black38),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: DialogButton(
            child: Text('Hello'),
            onPressed: (){
              _onAlertWithCustomContentPressed(context);
            }
        ),
      ),
      bottomNavigationBar: CustomBottombar(),
    );
  }

  // Alert custom content
  _onAlertWithCustomContentPressed(context) {
    Size screenSize = MediaQuery.of(context).size;
    Alert(
        context: context,
        title: "Reply feed back",
        style: AlertStyle(titleStyle: TextStyle(fontSize: 20)),
        content: Container(
          width: screenSize.width *0.8,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Colors.grey,
                width: 0.4,
              ),
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              maxLines: 5,
              onChanged: (value) {
                // controller.saveFeedback(value);
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(15, 5, 10, 10),
                labelText: 'Content reply',
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context)
            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}

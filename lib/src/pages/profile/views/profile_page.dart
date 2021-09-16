import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/profile/controllers/profile_controller.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0 * 5),
          Column(
            children: <Widget>[
              Container(
                height: 10.0 * 10,
                width: 10.0 * 10,
                margin: EdgeInsets.only(top: 10.0 * 3),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 10.0 * 5,
                        backgroundImage: NetworkImage(
                            'https://image.thanhnien.vn/2048/uploaded/hoangnam/2016_05_04/anh1_sqpb.jpg')),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.profileDetail);
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 10.0 * 2.5,
                          width: 10.0 * 2.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            heightFactor: 10.0 * 1.5,
                            widthFactor: 10.0 * 1.5,
                            child: Icon(
                              FontAwesomeIcons.pencilAlt,
                              color: Colors.black,
                              size: 10.0 * 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Đồng Hữu Long",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.profileDetail);
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(
                bottom: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 25,
                    color: Color(0xff28BEBA),
                  ),
                  SizedBox(width: 15),
                  Text('Tài khoản của tôi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 20),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.help, size: 25, color: Color(0xff28BEBA)),
                  SizedBox(width: 15),
                  Text('Trợ giúp và hỗ trợ',
                      style: TextStyle(
                        fontSize: 10.0 * 1.7,
                        fontWeight: FontWeight.w500,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(
                bottom: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.policy, size: 25, color: Color(0xff28BEBA)),
                  SizedBox(width: 15),
                  Text('Điều khoản & chính sách',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.setting);
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(bottom: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.settings, size: 25, color: Color(0xff28BEBA)),
                  SizedBox(width: 15),
                  Text('Cài đặt',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // gooleSignout();
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => LoginScreen(),
              // ));
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(
                bottom: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.logout, size: 25, color: Color(0xff28BEBA)),
                  SizedBox(width: 15),
                  Text('Đăng xuất',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

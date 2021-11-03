import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/pages/profile/controllers/profile_controller.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class ProfilePage extends GetView<ProfileController> {
  final SharedStates sharedData = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
      final Account? userInfo = sharedData.account;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: screenSize.height * 0.3,
                color: Colors.green.shade200,
              ),
            ),
            Column(
            children: <Widget>[
              SizedBox(height: screenSize.height*0.1),
              Column(
                children: <Widget>[
                  Container(
                    height: context.height * 0.13,
                    width: context.width * 0.243,
                    margin: EdgeInsets.only(top: 30),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(radius: 50,
                            backgroundImage: (userInfo.isNull)
                                ? NetworkImage('https://pngimg.com/uploads/mouth_smile/mouth_smile_PNG42.png')
                                : NetworkImage(userInfo!.imageUrl.toString())),
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
                  Text( (userInfo.isNull)? 'Username loading' : userInfo!.name.toString(),
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
                  margin: EdgeInsets.symmetric(horizontal: 30,).copyWith(bottom: 20,),
                  padding: EdgeInsets.symmetric(horizontal: 20,),
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
                      Text('My account',
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
                  padding: EdgeInsets.symmetric(horizontal: 20,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.help, size: 25, color: Color(0xff28BEBA)),
                      SizedBox(width: 15),
                      Text('Help and support',
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
                      Text('Terms & Policy',
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
              Container(
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
                    Text('Setting',
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
              GestureDetector(
                onTap: () {
                  // controller.logOut();
                  Get.toNamed(Routes.login);
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
                      Text('Logout',
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
          ]
        ),
        bottomNavigationBar: CustomBottombar(),
      );
  }
}
class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100); // center point - right point
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
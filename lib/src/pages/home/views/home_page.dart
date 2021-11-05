import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/home/controllers/home_controller.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.network("https://i.pinimg.com/564x/76/1c/19/761c198fc1e3512737b9a19381da49d9.jpg",
              fit: BoxFit.cover,
              width: screenSize.width,
              height: screenSize.height*0.8,
            ),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 45,
                  crossAxisSpacing: 25,
                  children: List.generate(choices.length, (index) {
                    return Center(
                      child: _buildTabs(choices[index], index, controller),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget _buildTabs(Choice choice,int index, HomeController controller) {
  return GestureDetector(
    onTap: (){
      controller.onpress(index);
    },
    child: Card(
        elevation: 10,
        color: choice.color.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: TextButton.icon(
              onPressed: (){
                controller.onpress(index);
                },
              icon: Icon(
                choice.icon,
                size: 40,
                color: Colors.white,
              ),
              label: Text(
                choice.title,
                style: TextStyle(color: Colors.white),
              )),
        )),
  );
}

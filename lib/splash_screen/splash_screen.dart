import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_store/api/response/category_product_response.dart';

import '../page/index_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    //set timeout splashscreen
    Future.delayed(Duration(seconds: 5),(){
      // Get.offAll(IndexScreen());
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset("assets/images/techmart.png",
                  height: 500,
                  width: 500
              ),
            ),
            // Text("Tech Mart",
            //   style: TextStyle(
            //       color: Colors.blue.shade700,
            //       fontWeight: FontWeight.w700,
            //       fontSize: 40,
            //     letterSpacing: 1
            //   ),
            // ),
            // SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('Đang tải dữ liệu'),
            //     SizedBox(
            //       width: 5,
            //     ),
            //     SizedBox(
            //       height: 15,
            //       width: 15,
            //       child: CircularProgressIndicator(
            //         color: Colors.black,
            //         strokeWidth: 1,
            //
            //       ),
            //     ),
            //
            //   ],
            // )

          ],
        ),
    );
  }
}

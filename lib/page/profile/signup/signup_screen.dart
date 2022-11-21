import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/api/response/signup_response.dart';
import 'package:smart_store/page/index_screen.dart';
import 'package:smart_store/page/profile/signup/create_info/create_info_screen.dart';
import 'package:smart_store/widget/global_textfield.dart';

import '../signin/sigin_screen.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30,),
                SvgPicture.asset("assets/images/sign_up.svg",
                  height: MediaQuery.of(context).size.height*.35,
                  // fit: BoxFit.cover,
                ),
                SizedBox(height: 30,),
            Form(
              // key: viewModel.formSignin,
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  children: [
                    GlobalTextField(
                      controller: emailControl,
                      // title: 'Email',
                      hint: 'Tài khoản',
                      requireInput: '',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      // validator: Validator.email,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GlobalTextField(
                      controller: passControl,
                      // controller: viewModel.passWordController,
                      // title: 'Mật khẩu',
                      hint: 'Mật khẩu',
                      requireInput: '',
                      prefixIcon: Icon(Icons.lock_rounded, color: Colors.blue),
                      textInputType: TextInputType.visiblePassword,
                      // validator: Validator.password,
                      security: true,
                    ),
                    SizedBox(
                      height: 40,
                    ),


                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                          );
                          await Future.delayed(Duration(seconds: 2));
                      await postSignup(emailControl.text, passControl.text)
                          .then((value) async{

                        await postSignin(
                            emailControl.text, passControl.text).then((value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            String? userID = value?.userId;
                            prefs.setString('userID', userID!);
                            Get.to(CreateInfoScreen(userID: userID,));

                          });
                        });
                      }).catchError((error){
                        Get.dialog(AlertDialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          contentPadding: EdgeInsets.all(15),

                          title: Column(
                            children: [
                              Text("Đăng kí tài khoản thất bại!",style: TextStyle(
                                  fontSize: 17,fontWeight: FontWeight.w700,letterSpacing: 1
                              ),),
                              SizedBox(height: 20,),
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red)
                                  ),
                                  child: Icon(Icons.close,color: Colors.red,size: 50,)),
                            ],
                          ),
                          // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),

                          actions: [
                            Center(
                              child: Container(
                                // padding:EdgeInsets.all(30),
                                width:MediaQuery.of(context).size.width*.6,
                                height: 50,
                                child: ElevatedButton(onPressed: (){
                                  Get.back();
                                  Get.back();

                                },
                                    child: Text("Quay lại")),
                              ),
                            )
                          ],
                        ));
                      });

                        },
                        child: Text(
                          'ĐĂNG KÝ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade700,
                              letterSpacing: 1.5),
                        ),
                        style: ElevatedButton.styleFrom(

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                            primary: Colors.white,
                            side: BorderSide(
                                color: Colors.blue.shade700,
                                width: 1
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn đã có tài khoản?',
                      style: TextStyle(
                        fontSize: 15, letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();

                          Get.to(SignInScreen());

                      },
                      child: Text(
                        'Đăng nhập ngay',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      Get.back();


                      // Get.offAll(IndexScreen());


                    },
                    child: Text(
                      'Trở về',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          letterSpacing: 1),
                    ))
              ],
            ),
          ),
        ));
  }
}

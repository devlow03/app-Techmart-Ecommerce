import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/api/response/signin_response.dart';
import 'package:smart_store/main.dart';
import 'package:smart_store/widget/global_textfield.dart';

import '../../index_screen.dart';
import '../profile_screen.dart';
import '../signup/signup_screen.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({Key? key, }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  // @override
  bool _isloading = false;

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
                SvgPicture.asset("assets/images/login.svg",
                  height: MediaQuery.of(context).size.height*.35,
                  fit: BoxFit.cover,
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
                        hint: 'Email',
                        requireInput: '',
                        prefixIcon: Icon(Icons.email, color: Colors.blue),
                        // validator: Validator.email,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GlobalTextField(
                        controller: passControl,
                        hint: 'Mật khẩu',
                        requireInput: '',
                        prefixIcon:
                        Icon(Icons.lock_rounded, color: Colors.blue),
                        textInputType: TextInputType.visiblePassword,
                        // validator: Validator.password,
                        security: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              // Get.to(ForgotPassWordScreen());
                            },
                            child: Text(
                              'Quên mật khẩu ?',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 0.5),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
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
                            await postSignin(emailControl.text, passControl.text).then((value) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              setState((){
                                String? userID = value?.userId;
                                prefs.setString('userID', userID!);

                              });
                              Navigator.pop(context);
                              Navigator.pop(context,'refresh');


                            }).catchError((error) {
                              Get.dialog(AlertDialog(
                                backgroundColor: Colors.white,
                                insetPadding:
                                EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                contentPadding: EdgeInsets.all(15),

                                title: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.red)),
                                        child: Icon(
                                          Icons.close,
                                          size: 50,
                                          color: Colors.red,
                                        )),
                                    SizedBox(height: 20,),
                                    Text(
                                      "Đăng nhập tài khoản thất bại!",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Vui lòng kiểm tra lại email và mật khẩu!',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),

                                actions: [
                                  Center(
                                    child: Container(
                                      // padding:EdgeInsets.all(30),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          .6,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () {
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
                            'ĐĂNG NHẬP',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.5),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            primary: Colors.blue.shade700,
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
                      'Bạn chưa có tài khoản?',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(SignUpScreen());
                      },
                      child: Text(
                        'Đăng ký',
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

                      // Get.offAll(IndexScreen(indexTab: 3));
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

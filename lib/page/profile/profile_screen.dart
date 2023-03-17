import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/page/all_order/all_order_screen.dart';
import 'package:smart_store/page/favorite/favorite_screen.dart';
import 'package:smart_store/page/profile/about/about_screen.dart';
import 'package:smart_store/page/profile/profile_detail/profile_detail_screen.dart';
import 'package:smart_store/page/profile/signin/sigin_screen.dart';
import 'package:smart_store/page/profile/signup/signup_screen.dart';
import 'package:smart_store/widget/global_webview.dart';
import '../../api/request/api.dart';
import '../../api/response/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override

  static String? token;
  void initState() {
    super.initState();
    setState(() {
      getUser();
      refreshScreen();
    });
  }
  void refreshScreen(){
    setState((){});
}

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade200,
        title: Text('Cá nhân'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState((){
            setState(() {
              token = prefs.getString('token');
            });
          });
        },
        child: ListView(
          // padding: const EdgeInsets.symmetric(vertical: 5),
          children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade100
                  ),
                  child: Visibility(
                    visible:token!=null,
                    replacement: Container(
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: Image.network(
                                    'https://cdn-icons-png.flaticon.com/512/4322/4322991.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*.28,
                                    child: ElevatedButton(
                                        onPressed: () async{
                                          String refresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:(context){
                                                    return SignInScreen();
                                                  })
                                          );
                                          if(refresh == "refresh"){
                                            getUser();
                                          }
                                        },

                                        child: Text('Đăng nhập')),
                                  ),
                                  SizedBox(width: 20,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*.28,
                                    child: ElevatedButton(
                                        onPressed: ()async{
                                          String refresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:(context){
                                                    return SignUpScreen();
                                                  })
                                          );
                                          if(refresh == "refresh"){
                                            getUser();
                                          }


                                        },
                                        child: Text('Đăng ký')),
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),



                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 8,
                            color: Colors.grey.shade200,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: ()async{
                                    String refresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:(context){
                                              return SignInScreen();
                                            })
                                    );
                                    if(refresh == "refresh"){
                                      getUser();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(

                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset("assets/images/note.png",


                                                width: MediaQuery.of(context).size.width*.1,

                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Text('Đơn hàng',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),

                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios,size: 20,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: ()async{
                                    String refresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:(context){
                                              return SignInScreen();
                                            })
                                    );
                                    if(refresh == "refresh"){
                                      getUser();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(

                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset("assets/images/love.png",


                                                width: MediaQuery.of(context).size.width*.1,

                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Text('Yêu thích',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),

                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios,size: 20,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: ()async{
                                    Get.to(
                                        GlobalWebview(
                                          tittleWeb: "Phản hồi",
                                          linkWeb: "https://docs.google.com/forms/d/e/1FAIpQLSdAw27DgHJ-PiOw9Bw6chXHOQyYUGA3rie1_g4rQvlBGz0_Vw/viewform?usp=pp_url",


                                        )
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(

                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset("assets/images/contact.png",


                                                width: MediaQuery.of(context).size.width*.1,

                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Text('Phản hồi',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),

                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios,size: 20,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: ()async{
                                   Get.to(AboutScreen());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(

                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset("assets/images/about.png",


                                                width: MediaQuery.of(context).size.width*.1,

                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Text('Thông tin',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),

                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios,size: 20,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        FutureBuilder<User?>(
                          future: getInfo(token),
                          builder: (context, snapshot){
                            return InkWell(
                              onTap: ()async{
                                String refresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:(context){
                                          return ProfileDetailScreen(
                                            token: token,
                                            userData: snapshot.data,
                                          );
                                        })
                                );
                                if(refresh == "refresh"){
                                  getUser();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 30,
                                            backgroundImage: NetworkImage('https://smartstore.khanhnhat.top${snapshot.data?.avatar??''}',),
                                          ),
                                          SizedBox(width: 40,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Xin chào!",
                                                style: TextStyle(height: 1,
                                                    color: Colors.grey.shade300,
                                                  letterSpacing: 1
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Text(snapshot.data?.fullname??'',
                                                style: TextStyle(height: 1,
                                                    color: Colors.white,
                                                  letterSpacing: 1
                                                ),
                                              )
                                            ],
                                          )

                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Icon(Icons.edit,color: Colors.white,),
                                      ),
                                      // SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                        SizedBox(height: 30,),
                       Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: Colors.white
                         ),
                         child: Column(
                           children: [
                             InkWell(
                               onTap: ()async{
                                 Get.to(AllOrderScreen());
                               },
                               child: Container(
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(

                                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         SizedBox(
                                           height: 30,
                                           child: Image.asset("assets/images/note.png",


                                             width: MediaQuery.of(context).size.width*.1,

                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         Text('Đơn hàng',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),

                                       ],
                                     ),
                                     Icon(Icons.arrow_forward_ios,size: 20,
                                       color: Colors.grey,
                                     )
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: 20,),
                             InkWell(
                               onTap: ()async{
                                 // Get.to(FavoriteScreen());
                               },
                               child: Container(
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(

                                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         SizedBox(
                                           height: 30,
                                           child: Image.asset("assets/images/love.png",


                                             width: MediaQuery.of(context).size.width*.1,

                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         Text('Yêu thích',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),

                                       ],
                                     ),
                                     Icon(Icons.arrow_forward_ios,size: 20,
                                       color: Colors.grey,
                                     )
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: 20,),
                             InkWell(
                               onTap: ()async{
                                  Get.to(
                                    GlobalWebview(
                                      tittleWeb: "Phản hồi",
                                      linkWeb: "https://docs.google.com/forms/d/e/1FAIpQLSdAw27DgHJ-PiOw9Bw6chXHOQyYUGA3rie1_g4rQvlBGz0_Vw/viewform?usp=pp_url",


                                    )
                                  );
                               },
                               child: Container(
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(

                                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         SizedBox(
                                           height: 30,
                                           child: Image.asset("assets/images/contact.png",


                                             width: MediaQuery.of(context).size.width*.1,

                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         Text('Phản hồi',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),

                                       ],
                                     ),
                                     Icon(Icons.arrow_forward_ios,size: 20,
                                       color: Colors.grey,
                                     )
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: 20,),
                             InkWell(
                               onTap: ()async{
                                  Get.to(AboutScreen());
                               },
                               child: Container(
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(

                                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         SizedBox(
                                           height: 30,
                                           child: Image.asset("assets/images/about.png",


                                             width: MediaQuery.of(context).size.width*.1,

                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         Text('Thông tin',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),

                                       ],
                                     ),
                                     Icon(Icons.arrow_forward_ios,size: 20,
                                       color: Colors.grey,
                                     )
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: 20,),
                             InkWell(
                               onTap: ()async{
                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                                 prefs.remove('userID');
                                 setState(() {
                                   token = null;
                                 });
                               },
                               child: Container(
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(

                                       children: [
                                         SizedBox(
                                           height: 30,
                                           child: Image.asset("assets/images/logout.png",


                                             width: MediaQuery.of(context).size.width*.1,

                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         Text('Đăng xuất',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),

                                       ],
                                     ),
                                     Icon(Icons.arrow_forward_ios,size: 20,
                                       color: Colors.grey,
                                     )
                                   ],
                                 ),
                               ),
                             )
                           ],
                         ),
                       )
                      ],
                    ),
                    ),
                  ),
                ),
            SizedBox(height: 10,),


          ]
        )
      )
    );
  }
}

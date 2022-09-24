import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/page/all_order/success.dart';

import '../../api/response/cart_response.dart';
import '../../api/response/info_order_response.dart';
import '../cart/cart_screen.dart';
import '../profile/signin/sigin_screen.dart';
import 'order_detail_screen.dart';
class AllOrderScreen extends StatefulWidget {
  final int? userID;
  const AllOrderScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  @override
  String? userID;
  void initState() {
    super.initState();
    setState(() {
      getUser();
    });
  }
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID')??'';
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text("Quản lí đơn hàng",
        style: TextStyle(
          color: Colors.black
        ),
        ),
        actions: [
          FutureBuilder<CartResponse?>(
            future: getCart(userID),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
                      child: IconButton(
                          onPressed: () {
                            userID!= null ? Get.to(CartScreen(userID: int.parse(userID.toString()))):
                            Get.to(SignInScreen());

                          },
                          icon: SvgPicture.asset('assets/images/cart.svg')
                      ),
                    ),
                    Positioned(
                      right:20,
                      bottom:27,
                      child:Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:  snapshot.data?.cart?.length!= null? Colors.blue.shade700 : null
                        ),
                        child: Text( snapshot.data?.cart?.length.toString()??'',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    )
                  ],

                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
                child: IconButton(
                    onPressed: () async {
                      if(userID!= null) {
                        Get.to(CartScreen(userID: int.parse(userID.toString())));
                      }
                      else{
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
                      }
                      // setState((){
                      //   coutCart = snapshot.data?.cart?.length.toString()??'';
                      // });
                    },
                    icon: SvgPicture.asset('assets/images/cart.svg',
                      color: Colors.black,
                    )
                ),
              );

            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          setState((){});
        },
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300)
                  )
                ),
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 11
                  ),
                  labelColor: Colors.red,
                  indicatorColor: Colors.blue,

                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Text("Chờ xác nhận",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                    Tab(
                      child: Text("Chờ lấy hàng",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                    Tab(
                      child: Text("Đang giao",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                    Tab(
                      child: Text("Đã giao",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                    Tab(
                      child: Text("Đã hủy",
                      style: TextStyle(
                        color: Colors.black
                      ),
                      ),
                    )
                  ],

                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                Center(child:Text('Không tồn tại đơn hàng')),
                    SuccessOrderScreen(userID: userID??''),
        Center(child:Text('Không tồn tại đơn hàng')),
        Center(child:Text('Không tồn tại đơn hàng')),
        Center(child:Text('Không tồn tại đơn hàng')),

                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

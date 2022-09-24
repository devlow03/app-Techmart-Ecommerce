import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/page/all_new/all_new_screen.dart';
import 'package:smart_store/page/all_order/all_order_screen.dart';
import 'package:smart_store/page/favorite/favorite_screen.dart';
import 'package:smart_store/page/homepage/homepage_screen.dart';
import 'package:smart_store/page/profile/profile_screen.dart';
import 'package:smart_store/page/profile/signin/sigin_screen.dart';
import 'package:smart_store/page/search_page/search_page.dart';

import '../api/response/cart_response.dart';
import '../config_static_data.dart';
import 'cart/cart_screen.dart';

class IndexScreen extends StatefulWidget {
  final int? tabIndex;
  const IndexScreen({super.key, this.tabIndex,});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  String? userID;
  void initState() {
    super.initState();

    setState(() {
      getUser();
      getCart(userID);
    });
  }
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tabData = [
      {
        'tabIndex':0,
        'screen': const HomePageScreen(),
        'tabName':'Trang chủ',
        'tabIcon':"assets/images/icons/home.png",
        'tabColor': _selectedIndex == 0 ? Colors.blue:Colors.black
      },
      {
        'tabIndex':1,
        'screen': const AllNewsScreen(),
        'tabName':'Tin tức',
        'tabIcon':"assets/images/icons/news.png",
        'tabColor': _selectedIndex == 1 ? Colors.blue:Colors.black
      },
      // {'screen': const Text('2'),  'tabIcon':_selectedIndex == 1 ? "assets/images/heart_on.png":"assets/images/heart_off.png"},
      // {
      //
      //   'screen': const AllOrderScreen(),
      //   'tabName':'Đơn hàng',
      //   'tabIcon':"assets/images/icons/bag.png",
      //   'tabColor': _selectedIndex == 3? Colors.blue:Colors.black
      // },
      {

        'screen': const ProfileScreen(),
        'tabName':'Tài khoản',
        'tabIcon':"assets/images/icons/user.png",
        'tabColor': _selectedIndex == 2? Colors.blue:Colors.black
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: [0,1,2].contains(_selectedIndex)
          ? null
      :AppBar(
        elevation: 1,
        backgroundColor: Colors.grey.shade100,
        title: TextField(
          onTap: (){
            showSearch(
                context: context,
                delegate: SearchPage(hintText: 'Tìm kiếm sản phẩm'));
          },
          readOnly: true,
          decoration: InputDecoration(
              hintText: "Tìm kiếm sản phẩm",
              hintStyle: TextStyle(
                  fontSize: 15
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 5),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Colors.grey.shade300
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300
                  )
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(Icons.search,color: Colors.grey,size: 20,)
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
                          onPressed: () async{
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
                    onPressed: () {
                      Get.to(CartScreen(userID: int.parse(userID.toString())));
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
      body: tabData.elementAt(_selectedIndex)['screen'],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(

          elevation: 0.0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade800,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            // fontWeight: FontWeight.w600,
            // letterSpacing: ,
            color: Colors.grey,
            height: 2



          ),
          unselectedFontSize: 11,
          items: tabData.map((e) {
            return BottomNavigationBarItem(
              icon: SizedBox(width: 20, height: 20, child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 5),
                  height: 30,
                  child: Image.asset(e['tabIcon'].toString(),
                    color: e['tabColor'],

                  ))),
              label: e['tabName'],
            );
          }).toList(),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

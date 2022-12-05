import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_store/api/response/new_response.dart';
import 'package:smart_store/page/all_new/all_new_screen.dart';
import 'package:smart_store/page/all_products/all_product_screen.dart';
import 'package:smart_store/page/product_detail/product_detail_screen.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/page/profile/signin/sigin_screen.dart';

import 'package:smart_store/widget/global_product.dart';
import 'package:get/get.dart';
import 'package:smart_store/widget/global_webview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../api/response/Banner_res.dart';
import '../../api/response/Category_res.dart';
import '../../api/response/cart_response.dart';
import '../../api/response/prod_category_res.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../search_page/search_page.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final listColor = [
    0xffef476f,
    0xffffd166,
    0xff06d6a0,
    0xfff118ab2,
    0xff073b4c,
    0xfff07167,
    0xff00afb9,
    0xff0081a7,


  ];
  int activeIndex = 0;
  TextEditingController nameController = TextEditingController();
  String host = "https://smartstore.khanhnhat.top";
  @override
  String? userID;

  void initState(){
    setState((){
      getUser();

    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }
  // checkInternet()async{
  //   await InternetConnectionChecker().hasConnection;
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.grey.shade300
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
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
          color: Colors.black,
          strokeWidth: 3,
          onRefresh: ()async{
            await getBanner().then((value){
              setState((){});
            });

          },
          child: ListView(
            children: [
              FutureBuilder<BannerRes?>(
                future: getBanner(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CarouselSlider.builder(
                              itemCount: snapshot.data?.data?.length ?? 0,
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  aspectRatio: 14 / 5,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  }

                                  // // viewportFraction: 1,

                                  // // enableInfiniteScroll: true
                                  ),
                              itemBuilder: (context, index, realIndex) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  child: Image.network(
                                    snapshot.data?.data?[index].urlBannerImg??'',
                                    width:
                                        MediaQuery.of(context).size.width,

                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                                bottom: 10,
                                child: AnimatedSmoothIndicator(
                                  count: snapshot.data?.data?.length ?? 0,
                                  activeIndex: activeIndex,
                                  effect: ExpandingDotsEffect(
                                      dotWidth: 6,
                                      dotHeight: 6,
                                      dotColor: Colors.grey,
                                      activeDotColor: Colors.black),
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey.shade100,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              'Danh mục sản phẩm',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                      ],
                    );
                  }
                   return Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider.builder(
                            itemCount: 1,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                aspectRatio: 14 / 5,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 5),
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                }

                              // // viewportFraction: 1,

                              // // enableInfiniteScroll: true
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  color: Colors.grey,


                                ),
                              );
                            },
                          ),
                          Positioned(
                              bottom: 10,
                              child: AnimatedSmoothIndicator(
                                count: snapshot.data?.data?.length ?? 0,
                                activeIndex: activeIndex,
                                effect: ExpandingDotsEffect(
                                    dotWidth: 6,
                                    dotHeight: 6,
                                    dotColor: Colors.grey,
                                    activeDotColor: Colors.black),
                              ))
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                        color: Colors.grey.shade100,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Text(
                            'Danh mục sản phẩm',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  );
                },
              ),
              FutureBuilder<CategoryRes?>(
                future: getCategory(),
                builder: (context,snapshot){
                  if(snapshot.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.category?.length??0,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(AllProductsScreen(
                                      id_category: snapshot.data
                                          ?.category?[index].idCategory.toString(),
                                      data2: snapshot.data?.category?[index],
                                    ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,

                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*.4,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Color(listColor[index]),
                                          borderRadius: BorderRadius.circular(5)
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.network(
                                               snapshot.data?.category?[index]
                                              .image ?? '',

                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * .1,
                                                // fit: BoxFit.fill,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(snapshot.data?.category?[index]
                                                  .nameType ?? '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15
                                              ),

                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }, separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(width: 20,);
                            },


                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey.shade100,
                        ),
                        SizedBox(height: 10,),
                        SizedBox(height: 20,),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data?.category?.length??0,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${snapshot
                                            .data
                                            ?.category?[index]
                                            .nameType ??
                                            ''} nổi bật',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Get.to(AllProductsScreen(
                                              id_category: snapshot.data?.category?[index].idCategory.toString(),
                                              data2: snapshot.data?.category?[index],
                                            ));
                                          },
                                          child: Text(
                                            "Xem thêm>",
                                            style: TextStyle(
                                                fontSize: 14,
                                                // fontWeight: FontWeight.w700,
                                                color: Colors.blue.shade700),
                                          )),
                                    ],
                                  ),
                                ),
                                FutureBuilder<ProdCategoryRes?>(
                                  future: getCategoryProduct(snapshot.data?.category?[index].idCategory),
                                  builder: (
                                      context,
                                      snapshot,
                                      ) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Container(
                                            margin:EdgeInsets.all(10),
                                            child: GridView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 3),
                                              shrinkWrap: true,
                                              itemCount: (snapshot
                                                  .data
                                                  ?.prodCategory
                                                  ?.length ??
                                                  0) >
                                                  4
                                                  ? 4
                                                  : (snapshot.data?.prodCategory
                                                  ?.length ??
                                                  0),
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(ProductDetailScreen(
                                                      idCategory: snapshot.data?.prodCategory?[index].idCategory.toString(),
                                                      id: snapshot.data?.prodCategory?[index].id.toString(),
                                                      name: snapshot.data?.prodCategory?[index].name.toString(),
                                                      price: snapshot.data?.prodCategory?[index].price.toString(),
                                                      descript: snapshot.data?.prodCategory?[index].descript,
                                                      image: snapshot.data?.prodCategory?[index].imgLink,

                                                    ));
                                                  },
                                                  child: GlobalProduct(
                                                    imageLink: snapshot
                                                        .data
                                                        ?.prodCategory?[index]
                                                        .imgLink,
                                                    shortDes: snapshot
                                                        .data
                                                        ?.prodCategory?[index]
                                                        .shortDes,
                                                    // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
                                                    price:
                                                    '${snapshot.data?.prodCategory?[index].price ?? ''}',
                                                    nameProduct:
                                                    '${snapshot.data?.prodCategory?[index].name}',
                                                    numStar: '5.0',
                                                  ),
                                                );
                                              },
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20,
                                                childAspectRatio: 3 / 5,
                                              ),
                                            ),
                                          ),

                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        Container(
                                          margin:EdgeInsets.all(10),
                                          child: GridView.builder(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            shrinkWrap: true,
                                            itemCount: 4,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                // padding: EdgeInsets.symmetric(vertical: 5),
                                                width: MediaQuery.of(context).size.width*.3,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  // border: Border.all(color: Colors.red),
                                                  border: Border.all(color: Colors.grey.shade300,),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  // mainAxisAlignment: MainAxisAlignment.,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade300,
                                                      highlightColor: Colors.grey.shade100,
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width*.3,
                                                        height: 150,

                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child:Shimmer.fromColors(
                                                        baseColor: Colors.grey.shade300,
                                                        highlightColor: Colors.grey.shade100,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*.3,
                                                          height: 12,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Center(
                                                      child:Shimmer.fromColors(
                                                        baseColor: Colors.grey.shade300,
                                                        highlightColor: Colors.grey.shade100,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*.3,
                                                          height: 12,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      // mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.grey.shade100,
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width*.3,
                                                                      height: 12,
                                                                      color: Colors.white,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),


                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 20,
                                              childAspectRatio: 3 / 5,
                                            ),
                                          ),
                                        ),

                                      ],
                                    );

                                  },
                                ),
                                SizedBox(height: 20,),


                              ],
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10,);
                        },

                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey.shade100,
                        ),
                        SizedBox(height: 10,),

                      ],
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 3,
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {

                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,

                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*.4,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5)
                                        ),


                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 20,);
                          },


                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.category?.length??0,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                            ],
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10,);
                      },

                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                        color: Colors.grey.shade100,
                      ),


                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20
                ),
                child: Row(
                  children: [
                    Text('Tin tức công nghệ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700),

                    )
                  ],
                ),
              ),
              FutureBuilder<NewResponse?>(
                future: getNews(),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: (){
                                Get.to(GlobalWebview(
                                  tittleWeb: snapshot.data?.articles?[index].title??'',
                                  linkWeb: snapshot.data?.articles?[index].url??'',
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade200,width: 1.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                                  snapshot.data?.articles?[index].title ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      height: 1.5,

                                                      fontSize: 15),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.visible,
                                                )),
                                            SizedBox(width: 5,),
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Image.network(
                                                  snapshot.data?.articles?[index].urlToImage ?? '',
                                                  fit: BoxFit.cover,
                                                  width:
                                                  MediaQuery.of(context).size.width *
                                                      .55,
                                                  height: 130,
                                                )),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                ),
                              ),
                            );
                          },

                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width:MediaQuery.of(context).size.width*.6,
                          height:45,
                          child: ElevatedButton(
                              onPressed: (){
                                Get.to(AllNewsScreen());
                              },
                              child: Text('Xem thêm',
                              style: TextStyle(
                                color: Colors.black87
                              ),
                              ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black
                                ),
                                  borderRadius: BorderRadius.circular(8)
                              )
                            ),

                          ),
                        ),


                      ],
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200,width: 1.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                            width: MediaQuery.of(context).size.width * .25,
                                            child: Container(
                                              height: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                            height: 10,
                                            width: MediaQuery.of(context).size.width * .25,
                                            child: Container(
                                              height: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                            height: 10,
                                            width: MediaQuery.of(context).size.width * .25,
                                            child: Container(
                                              height: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            height: 120,
                                            width: MediaQuery.of(context).size.width*.55,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ),
                      );
                    },

                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                  );




                },
              ),
              SizedBox(height: 30,),
            ],
          ),

          // body: Text('a'),
        ));
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_store/page/product_detail/product_detail_screen.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../api/response/Banner_res.dart';
import '../../api/response/Cart_res.dart';
import '../../api/response/Category_res.dart';
import '../../api/response/cart_response.dart';
import '../../api/response/prod_category_res.dart';
import '../../widget/global_product.dart';
import '../cart/cart_screen.dart';
import '../profile/signin/sigin_screen.dart';
import '../search_page/search_page.dart';

class AllProductsScreen extends StatefulWidget {
  // final String? id_category;
  // final Category? initProduct;
  // final String? id_mobile;
  final String? id_category;
  final ProdCategory? data;
  final Category?data2;
  const AllProductsScreen({Key? key,this.id_category, this.data, this.data2, }) : super(key: key);
  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  int activeIndex = 0;
  String? token;
  void initState() {
    super.initState();
    setState(() {
      getUser();
    });
  }
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();

          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        elevation: 0.0,
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
          FutureBuilder<CartRes?>(
            future: getCart(token),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
                      child: IconButton(
                          onPressed: () {
                            token!= null ? Get.to(CartScreen(token: token)):
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
                    onPressed: () {
                      Get.to(CartScreen(token:token));
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
          await getCart(token).then((value){
            setState((){});
          });
          await getCategoryProduct(widget.id_category).then((value) => {
          setState((){})
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
                                aspectRatio: 14 / 4,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 5),
                                // viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                }

                              // // viewportFraction: 1,

                              // // enableInfiniteScroll: true
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  child: Image.network(
                                    snapshot.data?.data?[index]
                                        .urlBannerImg ??
                                        '',
                                    width:
                                    MediaQuery.of(context).size.width,

                                    fit: BoxFit.fill,
                                  ),
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

                    ],
                  );
                }
                if(snapshot.hasError){
                  return Center();
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
                              aspectRatio: 14 / 4,
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

                    SizedBox(
                      height: 20,
                    ),

                  ],
                );
              },
            ),
            FutureBuilder<ProdCategoryRes?>(
                future: getCategoryProduct(widget.id_category),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        widget.data2?.nameType?.length!=null?Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Row(
                            children: [
                              Text('Phân loại theo: ${widget.data2?.nameType??''}'),
                            ],
                          ),
                        ):Center(),
                        Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.prodCategory?.length ?? 0,
                            itemBuilder: (context, index) {
                              return  InkWell(
                                onTap: (){
                                  Get.to(ProductDetailScreen(
                                    idCategory: snapshot.data?.prodCategory?[index].idCategory.toString(),
                                    id: snapshot.data?.prodCategory?[index].id.toString(),
                                    name: snapshot.data?.prodCategory?[index].name,
                                    price: snapshot.data?.prodCategory?[index].price.toString(),
                                    descript: snapshot.data?.prodCategory?[index].descript,
                                    image: snapshot.data?.prodCategory?[index].imgLink,
                                  ));
                                },
                                child: GlobalProduct(
                                  imageLink:
                                  snapshot.data?.prodCategory?[index].imgLink,
                                  shortDes: snapshot.data?.prodCategory?[index].shortDes,
                                  // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
                                  price: '${snapshot.data?.prodCategory?[index].price??''}',
                                  nameProduct: '${snapshot.data?.prodCategory?[index].name}',
                                  numStar: '5.0',
                                ),
                              );


                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                  // if(snapshot.hasError){
                  //   return Center(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         SizedBox(height: 300,),
                  //         Text('Không có kết nối',
                  //           style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600
                  //           ),
                  //         ),
                  //         SizedBox(height: 10,),
                  //         Text('Vui lòng kiểm tra kết nối mạng và thử lại'),
                  //         SizedBox(height: 20,),
                  //         ElevatedButton(
                  //           style: ElevatedButton.styleFrom(
                  //               padding: EdgeInsets.symmetric(horizontal: 40),
                  //               primary: Colors.blue.shade700
                  //           ),
                  //           child: Text('Thử lại'),
                  //           onPressed: (){
                  //             setState((){});
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }
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
                                            // Row(
                                            //   children: [
                                            //     Image.asset("assets/images/products/star_ico.png"),
                                            //     SizedBox(width: 5,),
                                            //     Text(widget.numStar??''),
                                            //   ],
                                            // ),

                                            // Text('${numReview} reviews')

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
                }
            ),
          ],
        ),
      ),
    );
  }
}

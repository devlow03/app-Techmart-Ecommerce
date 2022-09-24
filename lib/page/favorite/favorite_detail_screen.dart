// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:smart_store/api/response/favorite_response.dart';
// import 'package:smart_store/widget/photo_view.dart';
//
// import '../../api/request/api.dart';
// import '../../api/response/cart_response.dart';
// import '../../api/response/category_product_response.dart';
// import '../../api/response/get_info.dart';
// import '../../api/response/slider_product_response.dart';
// import '../../widget/global_product.dart';
// import '../all_products/all_product_screen.dart';
// import '../cart/cart_screen.dart';
// import '../order/order_product.dart';
// import '../product_detail/product_detail_screen.dart';
// import '../profile/signin/sigin_screen.dart';
// class FavoriteDetailScreen extends StatefulWidget {
//   final Favorite? favorite_data;
//   const FavoriteDetailScreen({Key? key, this.favorite_data}) : super(key: key);
//
//   @override
//   State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
// }
//
// class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
//   int activeIndex = 0;
//   int maxText = 8;
//
//
//
//
//   @override
//   int _itemCount = 1;
//   String? userID;
//
//   void initState() {
//     super.initState();
//     setState(() {
//       getUser();
//     });
//   }
//   getUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userID = prefs.getString('userID');
//     });
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar:  AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.grey.shade100,
//         // centerTitle: true,
//         leading: IconButton(
//           onPressed: (){
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back,color: Colors.black,),
//         ),
//         actions: [
//           //don't delete
//           FutureBuilder<CartResponse?>(
//             future: getCart(userID),
//             builder: (context,snapshot){
//               if(snapshot.connectionState == ConnectionState.done){
//                 return Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
//                       child: IconButton(
//                           onPressed: () {
//                             userID!= null ? Get.to(CartScreen(userID: int.parse(userID.toString()))):
//                             Get.to(SignInScreen());
//
//                           },
//                           icon: FaIcon(FontAwesomeIcons.cartShopping,size:20,color: Colors.black,)
//                       ),
//                     ),
//                     Positioned(
//                       right: 20,
//                       bottom:25,
//                       child:Container(
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:  snapshot.data?.cart?.length!= null? Colors.red : null
//                         ),
//                         child: Text( snapshot.data?.cart?.length.toString()??'',
//                           style: TextStyle(
//                               color: Colors.white
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//
//                 );
//               }
//               return Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
//                 child: IconButton(
//                     onPressed: () {
//                       Get.to(CartScreen(userID: int.parse(userID.toString())));
//                       // setState((){
//                       //   coutCart = snapshot.data?.cart?.length.toString()??'';
//                       // });
//                     },
//                     icon: FaIcon(FontAwesomeIcons.cartShopping,size:20,color: Colors.black,)
//                 ),
//               );
//
//             },
//           ),
//
//         ],
//       ),
//       body: RefreshIndicator(
//         color: Colors.black,
//         strokeWidth: 3,
//         onRefresh: () async {
//           setState((){});
//         },
//         child: ListView(
//           children: [
//             FutureBuilder<SliderProductResponse?>(
//               future: getSliderProduct(widget.favorite_data?.id),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return Stack(
//                     alignment: Alignment.topCenter,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white
//                         ),
//                         child: CarouselSlider.builder(
//                           itemCount: snapshot.data?.slider?.length,
//                           options: CarouselOptions(
//                             aspectRatio: 20/16,
//                             autoPlay: true,
//                             autoPlayInterval: Duration(seconds: 3),
//                             enlargeCenterPage: true,
//
//                             onPageChanged: (index, reason) {
//                               setState(() {
//                                 activeIndex = index;
//                               });
//                             },
//
//                             viewportFraction: 1,
//                             // enlargeCenterPage: true,
//                             // enableInfiniteScroll: true
//                           ),
//                           itemBuilder: (context, index, realIndex) {
//                             return InkWell(
//                               onTap: (){
//                                 Get.to(PhotoView(
//                                   id: widget.favorite_data?.id,
//                                 ));
//                               },
//                               child: Image.network(
//                                 snapshot.data?.slider?[index].linkImg ?? '',
//                                 width: MediaQuery.of(context).size.width,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Positioned(
//                           bottom: 20,
//                           right: 10,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 5),
//                             decoration: BoxDecoration(
//                               color: Colors.white38,
//                               // border:Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Text(
//                                 '${activeIndex + 1}/${snapshot.data?.slider?.length ?? 0}'),
//                           )),
//
//                     ],
//                   );
//                 }
//                 return Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white
//                       ),
//                       child: CarouselSlider.builder(
//                         itemCount: 1,
//                         options: CarouselOptions(
//                           aspectRatio: 20/16,
//                           autoPlay: true,
//                           autoPlayInterval: Duration(seconds: 3),
//                           enlargeCenterPage: true,
//
//                           onPageChanged: (index, reason) {
//                             setState(() {
//                               activeIndex = index;
//                             });
//                           },
//
//                           viewportFraction: 1,
//                           // enlargeCenterPage: true,
//                           // enableInfiniteScroll: true
//                         ),
//                         itemBuilder: (context, index, realIndex) {
//                           return Shimmer.fromColors(
//                             baseColor: Colors.grey.shade300,
//                             highlightColor: Colors.grey.shade100,
//                             child: Container(
//                               height: 100,
//                               width: MediaQuery.of(context).size.width,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Positioned(
//                         bottom: 20,
//                         right: 10,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.white38,
//                             // border:Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                               '${activeIndex + 1}/${snapshot.data?.slider?.length ?? 0}'),
//                         )),
//
//                   ],
//                 );
//               },
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 // borderRadius: BorderRadius.only(
//                 //     topRight: Radius.circular(40),
//                 //     topLeft: Radius.circular(40)
//                 // ),
//                 color: Colors.white,
//
//                 // border: Border.all(color: Colors.grey.shade400)
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 25, vertical: 5),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: Text(
//                                   widget.favorite_data?.name ?? ''.toUpperCase(),
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 1.3),
//                                 ))
//                           ],
//                         ),
//                         SizedBox(height: 5,),
//                         Row(
//                           children: [
//                             Text(
//
//                               NumberFormat.simpleCurrency(locale: 'vi').format(double.parse(widget.favorite_data?.price.toString() ?? '')*_itemCount)
//                               ,
//                               style: TextStyle(
//                                   color: Colors.redAccent,
//                                   height: 2,
//                                   fontSize: 18,
//                                   letterSpacing: 1.3),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 25, vertical: 5),
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset('assets/images/star.png',
//                                   height: 20,
//                                   width: 15,
//
//                                 ),
//                                 SizedBox(width: 3,),
//                                 Text('4.6 (120 reviews) | Đã bán 72')
//
//                               ],
//                             ),
//                             FutureBuilder<FavoriteResponse?>(
//                                 future: getFavoriteId(userID,widget.favorite_data?.id),
//                                 builder: (context,snapshot){
//                                   return  Row(
//                                     children: [
//                                       InkWell(
//                                           onTap:()async{
//                                             snapshot.data?.favorite?.length == null ?
//                                             await addFavorite(widget.favorite_data?.id,userID).then((value)async{
//                                               SharedPreferences prefs = await SharedPreferences.getInstance();
//                                               prefs.setString('message', value?.message??'');
//                                               setState((){
//
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                     SnackBar(
//                                                       backgroundColor: Colors.black54,
//                                                       width: 300,
//                                                       content: Text('Đã thêm vào sản phẩm yêu thích!',
//                                                         textAlign: TextAlign.center,
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             letterSpacing: 1
//                                                         ),
//                                                       ),
//                                                       elevation: 3.0,
//                                                       duration: Duration(seconds: 2),
//                                                       behavior: SnackBarBehavior.floating,
//                                                       shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.circular(20)
//                                                       ),
//                                                     )
//
//                                                 );
//
//                                               });
//                                             }):
//                                             await removeFavorite(widget.favorite_data?.id,userID).then((value)async{
//                                               SharedPreferences prefs = await SharedPreferences.getInstance();
//                                               prefs.setString('message', value?.message??'');
//                                               setState((){
//
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                     SnackBar(
//                                                       backgroundColor: Colors.black54,
//                                                       width: 300,
//                                                       content: Text('Đã xóa khỏi sản phẩm yêu thích!',
//                                                         textAlign: TextAlign.center,
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             letterSpacing: 1
//                                                         ),
//                                                       ),
//                                                       elevation: 3.0,
//                                                       duration: Duration(seconds: 2),
//                                                       behavior: SnackBarBehavior.floating,
//                                                       shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.circular(20)
//                                                       ),
//                                                     )
//
//                                                 );
//
//                                               });
//                                             })
//                                             ;
//
//
//
//                                           },
//                                           child: snapshot.data?.favorite?.length != null?Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           )
//
//                                               : Icon(
//                                             Icons.favorite_border_outlined,
//
//                                           )),
//                                       SizedBox(width: 10,),
//                                       Image.asset('assets/images/share.png',
//                                         height: 20,
//                                         width: 30,
//                                       )
//                                     ],
//                                   );
//                                 })
//
//
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 10,),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: Colors.grey.shade100,
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     width: MediaQuery.of(context).size.width * .9,
//
//                     decoration: BoxDecoration(
//                       // color: Colors.white,
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Column(
//                       children: [
//                         Text('Thông tin sản phẩm',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 20,),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(widget.favorite_data?.descript ?? '',
//                                 style: TextStyle(),
//                                 maxLines: maxText,
//
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20,),
//                         maxText == 8 ?InkWell(
//                           onTap: (){
//                             setState((){
//                               maxText = widget.favorite_data?.descript?.length??0;
//                             });
//                           },
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text('Xem thêm',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       letterSpacing: 1
//                                   ),
//                                 ),
//                                 SizedBox(width: 5,),
//                                 Icon(Icons.keyboard_arrow_down)
//                               ],
//                             ),
//                           ),
//                         ):InkWell(
//                           onTap: (){
//                             setState((){
//                               maxText = 8;
//                             });
//                           },
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text('Thu gọn',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       letterSpacing: 1
//                                   ),
//                                 ),
//                                 SizedBox(width: 5,),
//                                 Icon(Icons.keyboard_arrow_up)
//                               ],
//                             ),
//                           ),
//                         )
//
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(
//                     height: 15,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: Colors.grey.shade100,
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     width: MediaQuery.of(context).size.width * .95,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Sản phẩm tương tự",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w700),
//                               ),
//                               InkWell(
//                                   onTap: () {
//                                     Get.to(AllProductsScreen(
//                                       id_category: widget.favorite_data?.idCategory,
//
//                                     ));
//                                   },
//                                   child: Text(
//                                     "Xem thêm >>",
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.blue.shade700),
//                                   )),
//                             ],
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // ClipRRect(
//                   //   borderRadius: BorderRadius.only(
//                   //       topLeft: Radius.circular(20),
//                   //       topRight: Radius.circular(20)
//                   //   ),
//                   //   child:
//                   // ),
//                 ],
//               ),
//             ),
//             FutureBuilder<CategoryProductResponse?>(
//                 future: getCategoryProduct(widget.favorite_data?.idCategory),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return SizedBox(
//                       height: 280,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: 4,
//                         itemBuilder: (context, int index) {
//                           return AspectRatio(
//                             aspectRatio: 3/4.5,
//                             child: InkWell(
//                               onTap: () {
//                                 Get.back();
//                                 Get.to(ProductDetailScreen(
//                                   data: snapshot
//                                       .data?.productsCategory?[index],
//                                   idCategory: widget.favorite_data?.idCategory,
//                                 ));
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10),
//                                 child: GlobalProduct(
//                                   imageLink: snapshot
//                                       .data
//                                       ?.productsCategory?[index]
//                                       .imgLink,
//                                   shortDes: snapshot
//                                       .data
//                                       ?.productsCategory?[index]
//                                       .shortDes,
//                                   // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
//                                   price:
//                                   '${snapshot.data?.productsCategory?[index].price ?? ''}',
//                                   nameProduct:
//                                   '${snapshot.data?.productsCategory?[index].name}',
//                                   numStar: '5.0',
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder:
//                             (BuildContext context, int index) {
//                           return SizedBox(
//                             width: 3,
//                           );
//                         },
//                       ),
//                     );
//                   }
//                   return SizedBox(
//                     height: 280,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 4,
//                       itemBuilder: (context, int index) {
//                         return AspectRatio(
//                           aspectRatio: 3/4.5,
//                           child: Container(
//                             // padding: EdgeInsets.symmetric(vertical: 5),
//                             width: MediaQuery.of(context).size.width*.3,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               // border: Border.all(color: Colors.red),
//                               border: Border.all(color: Colors.grey.shade300,),
//                               color: Colors.white,
//                             ),
//                             child: Column(
//                               // mainAxisAlignment: MainAxisAlignment.,
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Shimmer.fromColors(
//                                   baseColor: Colors.grey.shade300,
//                                   highlightColor: Colors.grey.shade100,
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width*.3,
//                                     height: 150,
//
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10)
//                                       ),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20,),
//                                 Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                                     child:Shimmer.fromColors(
//                                       baseColor: Colors.grey.shade300,
//                                       highlightColor: Colors.grey.shade100,
//                                       child: Container(
//                                         width: MediaQuery.of(context).size.width*.3,
//                                         height: 12,
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                 ),
//                                 SizedBox(height: 5,),
//                                 Center(
//                                     child:Shimmer.fromColors(
//                                       baseColor: Colors.grey.shade300,
//                                       highlightColor: Colors.grey.shade100,
//                                       child: Container(
//                                         width: MediaQuery.of(context).size.width*.3,
//                                         height: 12,
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                 ),
//                                 SizedBox(height: 5,),
//                                 Column(
//                                   // mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Shimmer.fromColors(
//                                                 baseColor: Colors.grey.shade300,
//                                                 highlightColor: Colors.grey.shade100,
//                                                 child: Container(
//                                                   width: MediaQuery.of(context).size.width*.3,
//                                                   height: 12,
//                                                   color: Colors.white,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           // Row(
//                                           //   children: [
//                                           //     Image.asset("assets/images/products/star_ico.png"),
//                                           //     SizedBox(width: 5,),
//                                           //     Text(widget.numStar??''),
//                                           //   ],
//                                           // ),
//
//                                           // Text('${numReview} reviews')
//
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder:
//                           (BuildContext context, int index) {
//                         return SizedBox(
//                           width: 3,
//                         );
//                       },
//                     ),
//                   );
//                 }),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//
//         // color: Colors.transparent,
//         elevation: 0.0,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(10),
//                 topLeft: Radius.circular(10)
//             ),
//             boxShadow: [
//
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: Offset(0, 3), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () async{
//                     if(userID!=null) {
//
//
//                         await postAddCart(userID, widget.favorite_data?.id, _itemCount).then((value) async{
//
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 backgroundColor: Colors.black54,
//                                 width: 200,
//                                 content: Text('Đã thêm vào giỏ hàng!',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       letterSpacing: 1
//                                   ),
//                                 ),
//                                 elevation: 3.0,
//                                 duration: Duration(seconds: 2),
//                                 behavior: SnackBarBehavior.floating,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20)
//                                 ),
//                               )
//
//                           );
//                           setState((){});
//                         });
//                       }
//
//                     else{
//                       Get.to(SignInScreen());
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                             color: Colors.grey.shade300
//                         )
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40),
//                       child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           child:  FaIcon(FontAwesomeIcons.cartPlus,color: Colors.black,)
//                       ),
//                     ),
//                   ),
//                 ),
//                 FutureBuilder<GetInfo?>(
//                   future: getInfo(userID),
//                   builder: (context,snapshot){
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: ElevatedButton(
//                           onPressed: () async{
//
//                             if(userID!=null) {
//
//                                 print(snapshot.data?.user?.city);
//                                 Get.to(OrderProduct(
//                                   thumnail: widget.favorite_data?.imgLink,
//                                   namePro: widget.favorite_data?.name,
//                                   price: widget.favorite_data?.price,
//                                   amount: _itemCount,
//                                   idPro: widget.favorite_data?.id,
//                                   userID: int.parse(userID??''),
//                                   userData: snapshot.data?.user,
//                                 ));
//
//
//                             }
//                             else{
//                               String refresh = await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder:(context){
//                                         return SignInScreen();
//                                       })
//                               );
//                               if(refresh == "refresh"){
//                                 getUser();
//                               }
//
//
//                             }
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             child: Text(
//                               "Mua ngay",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30)),
//                               primary: Colors.black),
//                         ),
//                       ),
//                     );
//                   },
//
//                 )
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

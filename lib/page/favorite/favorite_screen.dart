// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:smart_store/api/response/favorite_response.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../../api/request/api.dart';
// import '../../api/response/cart_response.dart';
// import '../../widget/global_product.dart';
// import '../../widget/global_webview.dart';
// import '../cart/cart_screen.dart';
// import '../product_detail/product_detail_screen.dart';
// import '../profile/signin/sigin_screen.dart';
// import 'favorite_detail_screen.dart';
// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }
//
// class _FavoriteScreenState extends State<FavoriteScreen> {
//   @override
//   int activeIndex = 0;
//   String? userID;
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
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: (){
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back,color: Colors.black,),
//         ),
//         title: Text("Sản phẩm yêu thích",
//           style: TextStyle(
//               color: Colors.black
//           ),
//         ),
//         actions: [
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
//                           icon: SvgPicture.asset('assets/images/cart.svg')
//                       ),
//                     ),
//                     Positioned(
//                       right:20,
//                       bottom:27,
//                       child:Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:  snapshot.data?.cart?.length!= null? Colors.blue.shade700 : null
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
//                     onPressed: () async {
//                       if(userID!= null) {
//                         Get.to(CartScreen(userID: int.parse(userID.toString())));
//                       }
//                       else{
//                         String refresh = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder:(context){
//                                   return SignInScreen();
//                                 })
//                         );
//                         if(refresh == "refresh"){
//                           getUser();
//                         }
//                       }
//                       // setState((){
//                       //   coutCart = snapshot.data?.cart?.length.toString()??'';
//                       // });
//                     },
//                     icon: SvgPicture.asset('assets/images/cart.svg',
//                       color: Colors.black,
//                     )
//                 ),
//               );
//
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         color: Colors.black,
//         strokeWidth: 3,
//         onRefresh: ()async{
//           setState((){});
//           getFavorite(userID);
//         },
//         child: ListView(
//           children: [
//
//
//             SizedBox(height: 20,),
//             FutureBuilder<FavoriteResponse?>(
//                 future: getFavorite(userID),
//                 builder: (context,snapshot){
//                   if (snapshot.hasData) {
//                     return Column(
//                       children: [
//                         Container(
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: snapshot.data?.favorite?.length ?? 0,
//                             itemBuilder: (context, index) {
//                               return  InkWell(
//                                 onTap: (){
//                                   Get.to(ProductDetailScreen(
//                                     idCategory: snapshot.data?.favorite?[index].idCategory,
//                                     image: snapshot.data?.favorite?[index].imgLink,
//                                     name: snapshot.data?.favorite?[index].name,
//                                     price: snapshot.data?.favorite?[index].price,
//                                     id: snapshot.data?.favorite?[index].id,
//                                     descript: snapshot.data?.favorite?[index].descript,
//                                   ));
//                                 },
//                                 child: GlobalProduct(
//                                   imageLink:
//                                   snapshot.data?.favorite?[index].imgLink,
//                                   shortDes: snapshot.data?.favorite?[index].shortDes,
//                                   // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
//                                   price: '${snapshot.data?.favorite?[index].price??''}',
//                                   nameProduct: '${snapshot.data?.favorite?[index].name}',
//                                   numStar: '5.0',
//                                 ),
//                               );
//
//
//                             },
//                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 20,
//                               childAspectRatio: 3 / 5,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   if(snapshot.hasError){
//                     return Center(
//                       child: Text('Không có sản phẩm nào'),
//                     );
//                   }
//                   return Column(
//                     children: [
//                       Container(
//                         margin:EdgeInsets.all(10),
//                         child: GridView.builder(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 3),
//                           shrinkWrap: true,
//                           itemCount: 4,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return Container(
//                               // padding: EdgeInsets.symmetric(vertical: 5),
//                               width: MediaQuery.of(context).size.width*.3,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 // border: Border.all(color: Colors.red),
//                                 border: Border.all(color: Colors.grey.shade300,),
//                                 color: Colors.white,
//                               ),
//                               child: Column(
//                                 // mainAxisAlignment: MainAxisAlignment.,
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   Shimmer.fromColors(
//                                     baseColor: Colors.grey.shade300,
//                                     highlightColor: Colors.grey.shade100,
//                                     child: Container(
//                                       width: MediaQuery.of(context).size.width*.3,
//                                       height: 150,
//
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(10),
//                                             topRight: Radius.circular(10)
//                                         ),
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 20,),
//                                   Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child:Shimmer.fromColors(
//                                         baseColor: Colors.grey.shade300,
//                                         highlightColor: Colors.grey.shade100,
//                                         child: Container(
//                                           width: MediaQuery.of(context).size.width*.3,
//                                           height: 12,
//                                           color: Colors.white,
//                                         ),
//                                       )
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Center(
//                                       child:Shimmer.fromColors(
//                                         baseColor: Colors.grey.shade300,
//                                         highlightColor: Colors.grey.shade100,
//                                         child: Container(
//                                           width: MediaQuery.of(context).size.width*.3,
//                                           height: 12,
//                                           color: Colors.white,
//                                         ),
//                                       )
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Column(
//                                     // mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Shimmer.fromColors(
//                                                   baseColor: Colors.grey.shade300,
//                                                   highlightColor: Colors.grey.shade100,
//                                                   child: Container(
//                                                     width: MediaQuery.of(context).size.width*.3,
//                                                     height: 12,
//                                                     color: Colors.white,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             // Row(
//                                             //   children: [
//                                             //     Image.asset("assets/images/products/star_ico.png"),
//                                             //     SizedBox(width: 5,),
//                                             //     Text(widget.numStar??''),
//                                             //   ],
//                                             // ),
//
//                                             // Text('${numReview} reviews')
//
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             );
//                           },
//                           gridDelegate:
//                           SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 20,
//                             childAspectRatio: 3 / 5,
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   );
//                 }
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_store/api/request/api.dart';
// import 'package:smart_store/api/response/search_response.dart';
// import 'package:smart_store/page/search_page/search_page.dart';
// import 'package:smart_store/widget/global_product.dart';
//
// import '../product_detail/product_detail_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//
//   final SearchProducts? searchPro;
//   const SearchScreen({Key? key,this.searchPro}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.blue.shade200,
//         // centerTitle: true,
//         leading: IconButton(
//           onPressed: (){
//             Get.back();
//
//           },
//           icon: Icon(Icons.arrow_back,color: Colors.black,),
//         ),
//         title: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: TextField(
//             readOnly: true,
//             showCursor: false,
//             onTap: (){
//               showSearch(context: context, delegate: SearchPage(
//                   hintText: 'Tìm kiếm sản phẩm'
//               ));
//             },
//             textInputAction: TextInputAction.search,
//             onSubmitted: (value) {
//               // var name = nameController.text;
//               // Get.to(SearchScreen(
//               //   name: name,
//               // ),
//               // );
//               showSearch(context: context, delegate: SearchPage());
//             },
//
//             decoration: InputDecoration(
//               fillColor: Colors.grey.shade200,
//               filled: true,
//               contentPadding: const EdgeInsets.all(14),
//               suffixIcon: IconButton(
//                 onPressed: (){
//                   // var name = nameController.text;
//                   // Get.to(SearchPage(
//                   //
//                   // ),
//                   // );
//                   showSearch(context: context, delegate: SearchPage());
//                 },
//                 icon: Image.asset("assets/images/search_ico.png",color: Colors.black,),
//               ),
//               border: InputBorder.none,
//               hintText: widget.searchPro?.name,
//               hintStyle: const TextStyle(
//                   color:Colors.grey
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide:  BorderSide(color: Colors.grey.shade200),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               focusedBorder:OutlineInputBorder(
//                 borderSide:  BorderSide(color: Colors.grey.shade200),
//                 borderRadius: BorderRadius.circular(5),
//               ) ,
//             ),
//           ),
//         ),
//         // title:Text('Smart Shop',style: TextStyle(color: Colors.blue.shade700,fontSize: 18,fontWeight: FontWeight.w700),),
//         actions: [
//           // IconButton(
//           //   onPressed: () {
//           //     // Get.to(const SearchPage());
//           //   },
//           //   icon: Icon(
//           //     Icons.search,
//           //   ),
//           // ),
//           // IconButton(
//           //     onPressed: () {},
//           //     icon: Image.asset("assets/images/bell_ico.png")
//           // ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
//             child: IconButton(
//                 onPressed: () {
//
//                 },
//                 icon: Image.asset("assets/images/cart_ico.png")
//             ),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         color: Colors.black,
//         strokeWidth: 3,
//         onRefresh: refeshScreen,
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 5,
//             ),
//         Container(
//           width: MediaQuery.of(context).size.width * .95,
//           child: Column(
//             children: [
//
//               SizedBox(
//                 height: 10,
//               ),
//               GridView.builder(
//                 padding:
//                 EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 shrinkWrap: true,
//                 itemCount: 1,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () {
//                       Get.to(ProductDetailScreen(
//                         search_data: widget.searchPro,
//                         idCategory: widget.searchPro?.idCategory.toString(),
//
//                       ));
//                     },
//                     child: GlobalProduct(
//                       imageLink: widget.searchPro?.imgLink,
//                       shortDes: widget.searchPro?.shortDes,
//                       // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
//                       price:
//                       '${widget.searchPro?.price ?? ''}',
//                       nameProduct:
//                       '${widget.searchPro?.name}',
//                       numStar: '5.0',
//                     ),
//                   );
//                 },
//                 gridDelegate:
//                 SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 2 / 3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//             SizedBox(
//               height: 30,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

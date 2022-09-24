// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_store/page/profile/profile_detail/profile_detail_screen.dart';
//
// import '../../../api/request/api.dart';
// import '../../../api/response/city_response.dart';
// import '../../../api/response/district_response.dart';
// import '../../../api/response/ward_response.dart';
// class UpdateInfoScreen extends StatefulWidget {
//   final String? cityCode;
//   final String? disCode;
//   final String? wardCode;
//   final String? userID;
//   const UpdateInfoScreen({Key? key, this.cityCode, this.disCode, this.wardCode, this.userID,}) : super(key: key);
//
//   @override
//   State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
// }
//
// class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
//    String? cityCode;
//    String? disCode;
//    String? wardCode;
//   String? cityChosse;
//   String? disChosse;
//   String? wardChosse;
//   void initState(){
//     setState((){
//       cityCode = widget.cityCode;
//       disCode = widget.disCode;
//       wardCode = widget.wardCode;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.grey.shade200,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context,'refresh');
//           },
//           icon: Icon(Icons.arrow_back),color: Colors.black,),
//         centerTitle: true,
//         title: Text(
//           "Địa chỉ",
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
//               color: Colors.black
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: ()async{
//           setState((){});
//         },
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               margin: EdgeInsets.all(8),
//               width: MediaQuery.of(context).size.width*.9,
//               child: Column(
//                 children: [
//
//                   FutureBuilder<CityResponse?>(
//                     future: getCity(),
//                     builder: (context, snapshot) {
//                       return Column(
//                         children: [
//                           DropdownButtonFormField<String>(
//                             dropdownColor: Colors.white,
//                             focusColor: Colors.white,
//                             decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.all(8),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                     borderSide: BorderSide(
//                                         color: Colors.transparent,
//                                         width: 1)),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent, width: 1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent, width: 1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white),
//                             elevation: 1,
//                             hint: Text('Chọn tỉnh/thành phố'),
//                             items: snapshot.data?.results?.map((e) {
//                               return DropdownMenuItem<String>(
//                                   value: e.code,
//                                   onTap: (){
//                                     cityCode = null;
//                                     disChosse = null;
//                                     disCode = null;
//                                     disChosse = null;
//                                     wardCode = null;
//                                     wardChosse = null;
//                                   },
//                                   child: Text(e.name ?? ''));
//                             }).toList(),
//
//
//                             onChanged: (newValue) {
//                               setState(() {
//                                 cityChosse = newValue;
//                                 cityCode == null;
//
//
//                               });
//                             },
//                             menuMaxHeight:
//                             MediaQuery.of(context).size.height * .9,
//                             isDense: true,
//                             value: cityCode!=null?cityCode:cityChosse,
//                             isExpanded: true,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//
//                   SizedBox(
//                     height: 15,
//                   ),
//                   FutureBuilder<DistrictResponse?>(
//                     future: getDistrict(cityCode!=null?cityCode:cityChosse),
//                     builder: (context, snapshot) {
//                       return Column(
//                         children: [
//                           DropdownButtonFormField<String>(
//                             dropdownColor: Colors.white,
//                             focusColor: Colors.white,
//                             decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.all(8),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                     borderSide: BorderSide(
//                                         color: Colors.transparent,
//                                         width: 1
//                                     )
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent,
//                                       width: 1
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent,
//                                       width: 1
//                                   ),
//
//                                   borderRadius: BorderRadius.circular(10),
//
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white
//                             ),
//                             elevation: 1,
//                             hint: Text('Chọn quận/huyện'),
//                             items: snapshot.data?.results?.map((e) {
//                               return DropdownMenuItem<String>(
//                                   value: e.code,
//                                   onTap: (){
//                                     setState((){
//                                       disCode = null;
//                                       wardCode = null;
//                                     });
//                                   },
//                                   child: Text(e.name ?? ''));
//                             }).toList(),
//                             // onTap: (){
//                             //   setState((){
//                             //     wardChosse = null;
//                             //     disCode = null;
//                             //   });
//                             // },
//                             onChanged: (Value) {
//                               setState(() {
//                                 disChosse = Value;
//                                 disCode = null;
//                                 wardCode = null;
//                                 wardChosse = null;
//
//                               });
//                             },
//
//                             value: disCode!=null?disCode:disChosse,
//                             isExpanded: true,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//
//
//                   SizedBox(
//                     height: 15,
//                   ),
//                   FutureBuilder<WardResponse?>(
//                     future: getWard(disCode!=null?disCode:disChosse),
//                     builder: (context, snapshot) {
//                       return Column(
//                         children: [
//                           DropdownButtonFormField<String>(
//                             dropdownColor: Colors.white,
//                             focusColor: Colors.white,
//                             decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.all(8),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                     borderSide: BorderSide(
//                                         color: Colors.transparent,
//                                         width: 1
//                                     )
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent,
//                                       width: 1
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.transparent,
//                                       width: 1
//                                   ),
//
//                                   borderRadius: BorderRadius.circular(10),
//
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white
//                             ),
//                             elevation: 1,
//                             hint: Text('Chọn phường/xã'),
//                             items: snapshot.data?.results?.map((e) {
//                               return DropdownMenuItem<String>(
//                                   value: e.code,
//                                   onTap: (){
//                                     setState((){
//
//                                       wardCode=null;
//                                       wardChosse=null;
//                                       // disChosse = null;
//
//                                     });
//                                   },
//                                   child: Text(e.name ?? ''));
//                             }).toList(),
//                             onChanged: (Value) {
//                               setState(() {
//                                 wardChosse = Value;
//                                 wardCode=null;
//                               });
//                             },
//                             value: wardCode!=null?wardCode:wardChosse,
//                             isExpanded: true,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//
//                   SizedBox(
//                     height: 15,
//                   ),
//                   ElevatedButton(
//                   onPressed: ()async{
//                     await postAddress(
//                     cityCode!=null?cityCode:cityChosse,
//                     disCode!=null?disCode:disChosse,
//                     wardCode!=null?wardCode:wardChosse,
//                     widget.userID
//                     ).then((value){
//                      setState((){
//                        ScaffoldMessenger.of(context)
//                            .showSnackBar(SnackBar(
//                          backgroundColor:
//                          Colors.blue.shade700,
//                          content: Text(
//                              'Cập nhật thành công'),
//                          duration:
//                          Duration(seconds: 2),
//                        ));
//                      });
//                     });
//                   },
//                       child: Text('Cập nhật'))
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

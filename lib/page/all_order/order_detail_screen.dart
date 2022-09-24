import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/request/api.dart';
import '../../api/response/city_response.dart';
import '../../api/response/district_response.dart';
import '../../api/response/get_info.dart';
import '../../api/response/info_order_response.dart';
import '../../api/response/ward_response.dart';
class OrderDetailScreen extends StatefulWidget {
  final Order? data;
  const OrderDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back,color: Colors.black,)),
        centerTitle: true,
        title: Text("Chi tiết đơn hàng",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{},
        child: ListView(
          children: [
            FutureBuilder<GetInfo?>(
              future: getInfo(widget.data?.userID),
              builder: (context, snapshot) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Thông tin khách hàng",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.drive_file_rename_outline,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey.shade200))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'ID',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Text(
                                'K${widget.data?.userID}H ',
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 1,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey.shade200))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tên ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                widget.data?.fullname??'',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Column(
                          children: [

                            FutureBuilder<CityResponse?>(
                              future: getCity(),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      iconSize: 0.0,
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent, width: 1),
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent, width: 1),
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white),
                                      elevation: 1,
                                      hint: Text('Chọn tỉnh/thành phố'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Tỉnh/Thành phố',
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),),
                                                Text(e.name ?? '',
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                ),
                                              ],
                                            ));
                                      }).toList(),


                                      onChanged:null,

                                      menuMaxHeight:
                                      MediaQuery.of(context).size.height * .9,
                                      isDense: true,
                                      value: widget.data?.city,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            FutureBuilder<DistrictResponse?>(
                              future: getDistrict(widget.data?.city),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      iconSize: 0.0,
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1
                                            ),
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1
                                            ),

                                            borderRadius: BorderRadius.circular(0),

                                          ),
                                          filled: true,
                                          fillColor: Colors.white
                                      ),
                                      elevation: 1,
                                      hint: Text('Chọn quận/huyện'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Quận/Huyện',
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),),
                                                Text(e.name ?? '',
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }).toList(),
                                      onChanged:null,

                                      value: widget.data?.district,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),


                            SizedBox(
                              height: 15,
                            ),
                            FutureBuilder<WardResponse?>(
                              future: getWard(widget.data?.district),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      iconSize: 0.0,
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1
                                            ),
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1
                                            ),

                                            borderRadius: BorderRadius.circular(0),

                                          ),
                                          filled: true,
                                          fillColor: Colors.white
                                      ),
                                      elevation: 1,
                                      hint: Text('Chọn quận/huyện'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Phường/Xã',
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),),
                                                Text(e.name ?? '',
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }).toList(),
                                      onChanged:null,
                                      value: widget.data?.ward,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(
                              height: 15,
                            ),


                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey.shade200))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Điện thoại ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '${snapshot.data?.user?.phone ?? ''}',
                                style: TextStyle(fontSize: 16),
                              ),

                            ],
                          ),
                        ),

                        //don't delete

                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: Colors.black)
              ),
              // margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(widget.data?.idOrder??''),
                        SizedBox(height: 15,),

                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Image.network(
                          widget.data?.image?? '',
                          width:
                          MediaQuery.of(context).size.width *
                              .25,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data?.name ??
                                    '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text('${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(widget.data?.price ?? ''))}',
                                style:TextStyle(
                                    fontSize: 12
                                ) ,),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: 'Thành tiền : ',
                                        style: TextStyle(fontSize: 12,color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:'${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(widget.data?.price?? '')*int.parse(widget.data?.amount?? ''))}',
                                              style: TextStyle(color: Colors.redAccent)
                                          )

                                        ]
                                    ),

                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Text('Đặt hàng thành công',
                                    style: TextStyle(color: Colors.green),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20,vertical: 5),
                              child: Text("x${widget.data?.amount ??''}"
                                ,
                              ),
                            ),


                          ],
                        ),

                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

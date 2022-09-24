import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/response/district_response.dart';
import 'package:smart_store/page/all_order/all_order_screen.dart';
import 'package:smart_store/widget/global_textfield.dart';

import '../../api/request/api.dart';
import '../../api/response/cart_response.dart';
import '../../api/response/city_response.dart';
import '../../api/response/get_info.dart';
import '../../api/response/total_cart_response.dart';
import '../../api/response/ward_response.dart';
import '../index_screen.dart';
import '../product_detail/product_detail_screen.dart';
class OrderProduct extends StatefulWidget {
  final User? userData;
  final String? thumnail;
  final String? namePro;
  final int? amount;
  final String? price;
  final int? userID;
  final String? idPro;
  const OrderProduct({Key? key, this.userID, this.thumnail, this.namePro, this.amount, this.price, this.idPro,  this.userData, }) : super(key: key);

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  int itemCount=1;
  String? cityChosse = null;
  String? disChosse = null;
  String? wardChosse = null;
  String? cityCode;
  String? disCode;
  String? wardCode;

  void initState(){
    setState((){
      cityCode = widget.userData?.city;
      disCode = widget.userData?.district;
      wardCode = widget.userData?.ward;
    });
  }



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
        title: Text("Tạo đơn hàng",
        style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{},
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  GlobalTextField(
                    controller: fullName,
                    hint: 'Nhập họ tên',
                    requireInput: '',
                    // validator: Validator.fullname,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                  ),
                  SizedBox(height: 15,),

                  FutureBuilder<CityResponse?>(
                    future: getCity(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white),
                            elevation: 1,
                            hint: Text('Chọn tỉnh/thành phố'),
                            items: snapshot.data?.results?.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e.code,
                                  onTap: (){
                                    cityCode = null;
                                    disChosse = null;
                                    disCode = null;
                                    disChosse = null;
                                    wardCode = null;
                                    wardChosse = null;
                                  },
                                  child: Text(e.name ?? ''));
                            }).toList(),


                            onChanged: (newValue) {
                              setState(() {
                                cityChosse = newValue;
                                cityCode == null;


                              });
                            },
                            menuMaxHeight:
                            MediaQuery.of(context).size.height * .9,
                            isDense: true,
                            value: widget.userData?.city,
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
                    future: getDistrict(cityCode!=null?cityCode:cityChosse),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1
                                  ),

                                  borderRadius: BorderRadius.circular(10),

                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                            elevation: 1,
                            hint: Text('Chọn phường/xã'),
                            items: snapshot.data?.results?.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e.code,
                                  onTap: (){
                                    setState((){
                                      disCode = null;
                                      wardCode = null;
                                    });
                                  },
                                  child: Text(e.name ?? ''));
                            }).toList(),
                            // onTap: (){
                            //   setState((){
                            //     wardChosse = null;
                            //     disCode = null;
                            //   });
                            // },
                            onChanged: (Value) {
                              setState(() {
                                disChosse = Value;
                                disCode = null;
                                wardCode = null;
                                wardChosse = null;

                              });
                            },

                            value: disCode!=null?disCode:disChosse,
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
                    future: getWard(disCode!=null?disCode:disChosse),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1
                                  ),

                                  borderRadius: BorderRadius.circular(10),

                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                            elevation: 1,
                            hint: Text('Chọn quận/huyện'),
                            items: snapshot.data?.results?.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e.code,
                                  onTap: (){
                                    setState((){

                                      wardCode=null;
                                      wardChosse=null;
                                      // disChosse = null;

                                    });
                                  },
                                  child: Text(e.name ?? ''));
                            }).toList(),
                            onChanged: (Value) {
                              setState(() {
                                wardChosse = Value;
                                wardCode=null;
                              });
                            },
                            value: wardCode!=null?wardCode:wardChosse,
                            isExpanded: true,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 15,),
                  GlobalTextField(
                    textInputType: TextInputType.phone,
                    controller: phone,
                    hint: 'Nhập số điện thoại',
                    // validator: Validator.phone,
                    requireInput: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('Sản phẩm',
                      style: Theme.of(context).textTheme.headline6,
                      )
                    ],
                  ),


                ],

              ),
            ),
            widget.thumnail?.length != null ? Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.thumnail?? '',
                        width:
                        MediaQuery.of(context).size.width *
                            .4,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
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
                            widget.namePro??'',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(NumberFormat.simpleCurrency(
                              locale: 'vi')
                              .format(int.parse(widget.price ??
                              '')),
                            style:TextStyle(
                                fontSize: 12
                            ) ,),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(()  {
                                      if(itemCount<=1){
                                        itemCount=1;
                                      }
                                      else{
                                        itemCount = itemCount -1;
                                      }


                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey.shade300
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                    '$itemCount'
                                ),
                              ),

                              InkWell(
                                  onTap: () async {
                                    setState(() {
                                      itemCount = itemCount + 1;
                                    });
                                  },
                                  child:
                                  Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        color: Colors.black,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(Icons.add, size: 20,
                                          color: Colors.white,

                                        ),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ):
            FutureBuilder<CartResponse?>(
                future: getCart(widget.userID),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.cart?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey(snapshot.data?.cart?[index].id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width*.95,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(color: Colors.grey.shade300)

                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete_forever,size: 60,color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) {
                            return showDialog(
                                context: context,
                                builder: (cart){
                                  return AlertDialog(
                                    content: Text('Bạn có muốn xóa sản phẩm này ?'),
                                    actions: [
                                      ElevatedButton(
                                          style:ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              side: BorderSide(
                                                  color: Colors.grey.shade200
                                              )
                                          ),
                                          onPressed: (){
                                            Navigator.of(cart).pop(false);
                                          },
                                          child: Text('Không',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          )
                                      ),
                                      ElevatedButton(
                                          style:ElevatedButton.styleFrom(
                                              primary: Colors.red
                                          ),
                                          onPressed: (){
                                            Navigator.of(cart).pop(true);
                                          },
                                          child: Text('Đồng ý')
                                      )
                                    ],
                                  );
                                });
                          },
                          onDismissed: (direction){
                            setState((){
                              deleteCart(snapshot.data?.cart?[index].idCart??'');
                            });
                          },
                          child: InkWell(
                            onTap: (){
                              Get.to(ProductDetailScreen(
                                idCategory: snapshot.data?.cart?[index].idCategory,
                                id: snapshot.data?.cart?[index].id,
                                image: snapshot.data?.cart?[index].imgLink,
                                descript: snapshot.data?.cart?[index].descript,
                                price: snapshot.data?.cart?[index].price,
                                name: snapshot.data?.cart?[index].name,

                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width*.95,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                // border: Border.all(color: Colors.grey.shade300)

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        snapshot.data?.cart?[index].imgLink ?? '',
                                        width:
                                        MediaQuery.of(context).size.width *
                                            .4,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
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
                                            snapshot.data?.cart?[index]
                                                .name ??
                                                '',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(NumberFormat.simpleCurrency(
                                              locale: 'vi')
                                              .format(int.parse(snapshot.data
                                              ?.cart?[index].price ??
                                              '')),
                                            style:TextStyle(
                                                fontSize: 12
                                            ) ,),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          setState(()  {
                                                            int.parse(snapshot.data?.cart?[index].amount??'') <=1
                                                                ?
                                                            Get.dialog(AlertDialog(
                                                              content: Text('Bạn có muốn xóa sản phẩm này ?'),
                                                              actions: [
                                                                ElevatedButton(
                                                                    style:ElevatedButton.styleFrom(
                                                                        primary: Colors.white,
                                                                        side: BorderSide(
                                                                            color: Colors.grey.shade200
                                                                        )
                                                                    ),
                                                                    onPressed: (){
                                                                      Get.back();
                                                                    },
                                                                    child: Text('Không',
                                                                      style: TextStyle(
                                                                          color: Colors.black
                                                                      ),
                                                                    )
                                                                ),
                                                                ElevatedButton(
                                                                    style:ElevatedButton.styleFrom(
                                                                      primary: Colors.red,

                                                                    ),
                                                                    onPressed: (){
                                                                      setState((){
                                                                        deleteCart(snapshot.data?.cart?[index].idCart??'').then((value)async{
                                                                          await getCart(widget.userID).then((value)async{
                                                                            print(value?.cart?.length);
                                                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                            setState((){
                                                                              var numCart = value?.cart?.length.toString();
                                                                              prefs.setString('numCart', numCart??'');
                                                                            });

                                                                          });
                                                                        });
                                                                        Get.back();
                                                                      });
                                                                    },
                                                                    child: Text('Đồng ý')
                                                                )
                                                              ],
                                                            )):
                                                            postUpdateAmount(int.parse(snapshot.data?.cart?[index].amount??'')-1,snapshot.data?.cart?[index].idCart );

                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colors.grey.shade300
                                                              )
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5),
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        )),


                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                      child: Text(
                                                        (snapshot.data?.cart?[index]
                                                            .amount ??
                                                            ''),
                                                      ),
                                                    ),

                                                    InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            postUpdateAmount(
                                                              int.parse(snapshot
                                                                  .data
                                                                  ?.cart?[index]
                                                                  .amount ??
                                                                  '') +
                                                                  1,
                                                              snapshot
                                                                  .data
                                                                  ?.cart?[index]
                                                                  .idCart ??
                                                                  '',
                                                            );
                                                          });
                                                        },
                                                        child:
                                                        Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,

                                                              color: Colors.black,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(5),
                                                              child: Icon(Icons.add, size: 20,
                                                                color: Colors.white,

                                                              ),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey.shade300
                                                    )
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Get.dialog(AlertDialog(
                                                        content: Text('Bạn có muốn xóa sản phẩm này ?'),
                                                        actions: [
                                                          ElevatedButton(
                                                              style:ElevatedButton.styleFrom(
                                                                  primary: Colors.white,
                                                                  side: BorderSide(
                                                                      color: Colors.grey.shade200
                                                                  )
                                                              ),
                                                              onPressed: (){
                                                                Get.back();
                                                              },
                                                              child: Text('Không',
                                                                style: TextStyle(
                                                                    color: Colors.black
                                                                ),
                                                              )
                                                          ),
                                                          ElevatedButton(
                                                              style:ElevatedButton.styleFrom(
                                                                primary: Colors.red,

                                                              ),
                                                              onPressed: (){
                                                                setState((){
                                                                  deleteCart(snapshot.data?.cart?[index].idCart??'').then((value)async{
                                                                    await getCart(widget.userID).then((value)async{
                                                                      print(value?.cart?.length);
                                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                      setState((){
                                                                        var numCart = value?.cart?.length.toString();
                                                                        prefs.setString('numCart', numCart??'');
                                                                      });

                                                                    });
                                                                  });
                                                                  Get.back();
                                                                });
                                                              },
                                                              child: Text('Đồng ý')
                                                          )
                                                        ],
                                                      ));
                                                    },
                                                    child: Icon(Icons.delete,
                                                      color: Colors.redAccent,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey.shade200,
                        );
                      },
                    );
                  }
                  if(snapshot.hasError){
                    return Center(
                        child: Text("Không có sản phẩm trong giỏ hàng"));
                  }
                  return Center(child: CircularProgressIndicator(

                  ),);

                }),
          ],
        ),
      ),
        bottomNavigationBar: Container(
          // padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child: widget.thumnail?.length!= null? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child:

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tổng: ',
                          style: TextStyle(
                              color: Colors.black,
                              height: 2,
                              fontSize: 14,
                              letterSpacing: 1),
                        ),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(int.parse(widget.price??'')* itemCount),
                          style: TextStyle(
                              color: Colors.red,
                              height: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),

                // SizedBox(width: 1,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () async{

                        if(fullName.text=='' && phone.text==''){
                          Get.dialog(AlertDialog(
                            backgroundColor: Colors.white,
                            insetPadding:
                            EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8)),
                            contentPadding: EdgeInsets.all(15),

                            title: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.red)),
                                    child: Icon(
                                      Icons.close,
                                      size: 50,
                                      color:Colors.red,
                                    )),
                                SizedBox(height: 20,),
                                Text(
                                  "Đặt hàng không thành công!",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                            // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                            actions: [
                              Center(
                                child: Container(
                                  // padding:EdgeInsets.all(30),
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      .6,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: Text("Quay lại")),
                                ),
                              )
                            ],
                          ));
                        }
                        else{
                          await postOnlyOrder(
                              fullName.text,
                              cityCode!=null?cityCode:cityChosse,
                               disCode!=null?disCode:disChosse,
                                wardCode!=null?wardCode:wardChosse,
                              phone.text, int.parse(widget.price??'')* itemCount, widget.userID).then((value) async{

                            await postPushProduct(widget.idPro, widget.namePro, widget.thumnail?? '', itemCount, widget.price, value?.idOrder).then((value) {
                              Get.dialog(AlertDialog(
                                backgroundColor: Colors.white,
                                insetPadding:
                                EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                contentPadding: EdgeInsets.all(15),

                                title: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.green)),
                                        child: Icon(
                                          Icons.check,
                                          size: 50,
                                          color:Colors.green,
                                        )),
                                    SizedBox(height: 20,),
                                    Text(
                                      "Đặt hàng thành công!",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                                // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                                actions: [
                                  Center(
                                    child: Container(
                                      // padding:EdgeInsets.all(30),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          .6,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            Get.offAll(IndexScreen());
                                          },
                                          child: Text("Quay lại trang chủ")),
                                    ),
                                  )
                                ],
                              ));

                            }).catchError((error){
                              Get.dialog(AlertDialog(
                                backgroundColor: Colors.white,
                                insetPadding:
                                EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                contentPadding: EdgeInsets.all(15),

                                title: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.red)),
                                        child: Icon(
                                          Icons.close,
                                          size: 50,
                                          color:Colors.red,
                                        )),
                                    SizedBox(height: 20,),
                                    Text(
                                      "Đặt hàng không thành công!",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                                // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                                actions: [
                                  Center(
                                    child: Container(
                                      // padding:EdgeInsets.all(30),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          .6,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            Get.back();
                                          },
                                          child: Text("Quay lại")),
                                    ),
                                  )
                                ],
                              ));
                            });
                          });

                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Đặt hàng",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          primary: Colors.blue.shade700),
                    ),
                  ),
                )
              ],
            ),
          ):
          FutureBuilder<TotalCartResponse?>(
            future: getTotalCart(widget.userID),
            builder: (context, snapshot) {

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child:
                snapshot.data?.totalCart?.name!=null?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tổng: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  height: 2,
                                  fontSize: 14,
                                  letterSpacing: 1),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'vi')
                                  .format(int.parse(
                                  snapshot.data?.totalCart?.total ?? '')),
                              style: TextStyle(
                                  color: Colors.red,
                                  height: 2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(width: 1,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () async{

                             if(fullName.text==''  && phone.text==''){
                               Get.dialog(AlertDialog(
                                 backgroundColor: Colors.white,
                                 insetPadding:
                                 EdgeInsets.symmetric(vertical: 10),
                                 shape: RoundedRectangleBorder(
                                     borderRadius:
                                     BorderRadius.circular(8)),
                                 contentPadding: EdgeInsets.all(15),

                                 title: Column(
                                   children: [
                                     Container(
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             border: Border.all(
                                                 color: Colors.red)),
                                         child: Icon(
                                           Icons.close,
                                           size: 50,
                                           color:Colors.red,
                                         )),
                                     SizedBox(height: 20,),
                                     Text(
                                       "Đặt hàng không thành công!",
                                       style: TextStyle(
                                           fontSize: 17,
                                           fontWeight: FontWeight.w700,
                                           letterSpacing: 1),
                                     ),
                                   ],
                                 ),
                                 // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                                 actions: [
                                   Center(
                                     child: Container(
                                       // padding:EdgeInsets.all(30),
                                       width: MediaQuery.of(context)
                                           .size
                                           .width *
                                           .6,
                                       height: 50,
                                       child: ElevatedButton(
                                           onPressed: () async {
                                             Get.back();
                                           },
                                           child: Text("Quay lại")),
                                     ),
                                   )
                                 ],
                               ));
                             }
                             else{
                               await postCreateOrder(
                                   fullName.text,
                                   cityCode!=null?cityCode:cityChosse,
                                   disCode!=null?disCode:disChosse,
                                   wardCode!=null?wardCode:wardChosse,
                                   phone.text,
                                   snapshot.data?.totalCart?.total ?? '',
                                   widget.userID).then((value) {
                                 Get.dialog(AlertDialog(
                                   backgroundColor: Colors.white,
                                   insetPadding:
                                   EdgeInsets.symmetric(vertical: 10),
                                   shape: RoundedRectangleBorder(
                                       borderRadius:
                                       BorderRadius.circular(8)),
                                   contentPadding: EdgeInsets.all(15),

                                   title: Column(
                                     children: [
                                       Container(
                                           decoration: BoxDecoration(
                                               shape: BoxShape.circle,
                                               border: Border.all(
                                                   color: Colors.green)),
                                           child: Icon(
                                             Icons.check,
                                             size: 50,
                                             color:Colors.green,
                                           )),
                                       SizedBox(height: 20,),
                                       Text(
                                         "Đặt hàng thành công!",
                                         style: TextStyle(
                                             fontSize: 17,
                                             fontWeight: FontWeight.w700,
                                             letterSpacing: 1),
                                       ),
                                     ],
                                   ),
                                   // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                                   actions: [
                                     Center(
                                       child: Container(
                                         // padding:EdgeInsets.all(30),
                                         width: MediaQuery.of(context)
                                             .size
                                             .width *
                                             .6,
                                         height: 50,
                                         child: ElevatedButton(
                                             onPressed: () async {
                                               Get.offAll(IndexScreen());
                                             },
                                             child: Text("Quay lại trang chủ")),
                                       ),
                                     )
                                   ],
                                 ));

                               },).catchError((e){
                                 Get.dialog(AlertDialog(
                                   backgroundColor: Colors.white,
                                   insetPadding:
                                   EdgeInsets.symmetric(vertical: 10),
                                   shape: RoundedRectangleBorder(
                                       borderRadius:
                                       BorderRadius.circular(8)),
                                   contentPadding: EdgeInsets.all(15),

                                   title: Column(
                                     children: [
                                       Container(
                                           decoration: BoxDecoration(
                                               shape: BoxShape.circle,
                                               border: Border.all(
                                                   color: Colors.red)),
                                           child: Icon(
                                             Icons.close,
                                             size: 50,
                                             color:Colors.red,
                                           )),
                                       SizedBox(height: 20,),
                                       Text(
                                         "Đặt hàng không thành công!",
                                         style: TextStyle(
                                             fontSize: 17,
                                             fontWeight: FontWeight.w700,
                                             letterSpacing: 1),
                                       ),
                                     ],
                                   ),
                                   // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                                   actions: [
                                     Center(
                                       child: Container(
                                         // padding:EdgeInsets.all(30),
                                         width: MediaQuery.of(context)
                                             .size
                                             .width *
                                             .6,
                                         height: 50,
                                         child: ElevatedButton(
                                             onPressed: () async {
                                               Get.back();
                                             },
                                             child: Text("Quay lại")),
                                       ),
                                     )
                                   ],
                                 ));
                               });
                             }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Đặt hàng",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: Colors.blue.shade700),
                        ),
                      ),
                    )
                  ],
                ):null,
              );


            },
          ),
        )
    );
  }
}

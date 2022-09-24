import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/api/response/get_info.dart';
import 'package:smart_store/page/order/order_product.dart';
import 'package:smart_store/page/product_detail/product_detail_screen.dart';
import '../../api/response/cart_response.dart';
import '../../api/response/total_cart_response.dart';

class CartScreen extends StatefulWidget {
  final int? userID;

  const CartScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? coutCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: FutureBuilder<CartResponse?>(
            future: getCart(widget.userID),
            builder: (context,snapshot){
              return IconButton(
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState((){
                    Get.back();
                    // Get.to(CartScreen(userID: int.parse(userID.toString()),));
                  });

                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              );
            },

          ),
          elevation: 0.0,
          backgroundColor: Colors.grey.shade100,
          centerTitle: true,
          title: Text(
            'Giỏ Hàng',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
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
                                                .35,
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
                                                  SizedBox(width: 10,),
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
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Center(

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
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          // padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child:  FutureBuilder<TotalCartResponse?>(
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
                    FutureBuilder<GetInfo?>(
                      future: getInfo(widget.userID),
                      builder: (context,snapshot){
                        return  Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(OrderProduct(
                                  userID: widget.userID,
                                  userData: snapshot.data?.user,
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  "Mua ngay",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  primary: Colors.black),
                            ),
                          ),
                        );
                      },

                    )
                    // SizedBox(width: 1,),

                  ],
                ):null,
              );
            },
          ),
        )
    );
  }
}

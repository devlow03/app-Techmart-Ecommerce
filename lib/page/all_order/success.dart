import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/request/api.dart';
import '../../api/response/info_order_response.dart';
import 'order_detail_screen.dart';
class SuccessOrderScreen extends StatefulWidget {
  final String userID;
  const SuccessOrderScreen({Key? key, required this.userID}) : super(key: key);

  @override
  State<SuccessOrderScreen> createState() => _SuccessOrderScreenState();
}

class _SuccessOrderScreenState extends State<SuccessOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 20,),
        // Text(userID??''),
        FutureBuilder<InfoOrderResponse?>(
            future: infoOrder(widget.userID),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.order?.length??0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Get.to(OrderDetailScreen(
                          data: snapshot.data?.order?[index],
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white,

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '????n h??ng: ${snapshot.data?.order?[index].idOrder?? ''}',
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),

                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Image.network(
                                    snapshot.data?.order?[index].image?? '',
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
                                          snapshot.data?.order?[index]
                                              .name ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text('${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(snapshot.data?.order?[index].price ?? ''))}',
                                          style:TextStyle(
                                              fontSize: 12
                                          ) ,),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: 'Th??nh ti???n : ',
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:'${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(snapshot.data?.order?[index].price?? '')*int.parse(snapshot.data?.order?[index].amount?? ''))}',
                                                    style: TextStyle(color: Colors.redAccent)
                                                )

                                              ]
                                          ),

                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            Text('?????t h??ng th??nh c??ng',
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
                                        child: Text("x${snapshot.data?.order?[index].amount ??''}"
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
                return Center(child:Text('Kh??ng t???n t???i ????n h??ng'));
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.to(OrderDetailScreen(
                        data: snapshot.data?.order?[index],
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white,
                          // border: Border.all(color: Colors.grey.shade200)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
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
                            ),
                            SizedBox(height: 10,),

                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*.25,
                                    height: 70,
                                    color: Colors.white,
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
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*.3,
                                          height: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*.3,
                                          height: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*.3,
                                          height: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width*.3,
                                              height: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),


                          ],
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
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}

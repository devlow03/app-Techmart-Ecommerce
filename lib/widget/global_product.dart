import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../page/product_detail/product_detail_screen.dart';
class GlobalProduct extends StatefulWidget {
  final String? imageLink;
  final String? nameProduct;
  final dynamic  price;
  final String? numStar;
  final String? shortDes;
  // final String? shortDescript;
  const GlobalProduct({
    Key? key,
    this.imageLink,
    this.nameProduct,
    this.price,
    this.shortDes,
    this.numStar,
    // this.shortDescript


  }) : super(key: key);


  @override
  State<GlobalProduct> createState() => _GlobalProductState();
}

class _GlobalProductState extends State<GlobalProduct> {


  @override
  Widget build(BuildContext context) {
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
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            ),
            child: Image.network(widget.imageLink??'',
              width: MediaQuery.of(context).size.width*.3,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(widget.nameProduct??'',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  height: 1,
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                color: Colors.black
                  ),),
          ),
          SizedBox(height: 5,),
          Center(
            child: Text(
              widget.shortDes??'',
              style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,),
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
                        Text(NumberFormat.simpleCurrency(locale: 'vi').format(double.parse(widget.price)),
                          style: TextStyle(fontSize: 14,color: Colors.redAccent),),
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
  }
}


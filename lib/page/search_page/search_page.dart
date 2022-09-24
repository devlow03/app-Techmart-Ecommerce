import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:smart_store/api/response/search_response.dart';
import 'package:smart_store/page/product_detail/product_detail_screen.dart';
import 'package:smart_store/page/search_products/search_screen.dart';

import '../../api/request/api.dart';
import '../../widget/global_product.dart';

class SearchPage extends SearchDelegate{

   final String? hintText;
  SearchPage({this.hintText});

  @override
  String? get searchFieldLabel => hintText;

  @override
  List<Widget>? buildActions(BuildContext context) {

   return[
     IconButton(
       icon:const Icon(Icons.clear),
       onPressed: (){
        query='';
       },
     )

   ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          Get.back();
        },
        icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  if(query.length>0){
    return FutureBuilder<SearchResponse?>(
      future: getSearch(query),
      builder: (context,snapshot){

        return ListView.builder(
          itemCount: snapshot.data?.searchProducts?.length??0,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Column(
              children: [
                InkWell(
                  onTap: (){
                    Get.to(ProductDetailScreen(
                      idCategory: snapshot.data?.searchProducts?[index].idCategory,
                      id: snapshot.data?.searchProducts?[index].id,
                      name: snapshot.data?.searchProducts?[index].name,
                      price: snapshot.data?.searchProducts?[index].price,
                      image:snapshot.data?.searchProducts?[index].imgLink,
                      descript: snapshot.data?.searchProducts?[index].descript,
                    ));
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                      leading: Image.network(snapshot.data?.searchProducts?[index].imgLink??''),
                      title:Text(snapshot.data?.searchProducts?[index].name??'',style:
                      TextStyle(fontSize: 12),),
                      subtitle: Text(NumberFormat.simpleCurrency(locale: 'vi').format(double.parse(snapshot.data?.searchProducts?[index].price??'')),style: TextStyle(color: Colors.red),),
                      trailing: SvgPicture.asset("assets/images/arrow-up-left.svg",
                      )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200
                  ),
                )
              ],
            );
          },
        );



      },
    );
  }
  return Center();


  }
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<SearchResponse?>(
      future: getSearch(query),
      builder: (context,snapshot){
        if (snapshot.hasData) {
          return Container(
            color: Colors.grey.shade200,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 20),
              shrinkWrap: true,
              itemCount: snapshot.data?.searchProducts?.length ??0,


              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(ProductDetailScreen(
                      idCategory: snapshot.data?.searchProducts?[index].idCategory,
                      id: snapshot.data?.searchProducts?[index].id,
                      name: snapshot.data?.searchProducts?[index].name,
                      price: snapshot.data?.searchProducts?[index].price,
                      image:snapshot.data?.searchProducts?[index].imgLink,
                      descript: snapshot.data?.searchProducts?[index].descript,
                    ));
                  },
                  child: GlobalProduct(
                    imageLink: snapshot.data?.searchProducts?[index].imgLink,
                    shortDes: snapshot.data?.searchProducts?[index].shortDes,
                    // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
                    price:
                    '${snapshot.data?.searchProducts?[index].price ?? ''}',
                    nameProduct:
                    '${snapshot.data?.searchProducts?[index].name}',
                    numStar: '5.0',
                  ),
                );
              },
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 5,
              ),
            ),
          );
        }
        if(snapshot.hasError){
          return Center(
            child: Text(" Không tìm thấy sản phẩm này"),
          );
        }
        return const Center(child: CircularProgressIndicator( color: Colors.black,
          strokeWidth: 3,));

      },
    );
  }
}
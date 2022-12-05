import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_store/api/response/comment_response.dart';
import 'package:smart_store/api/response/prodslider_res.dart';
import 'package:smart_store/api/response/search_response.dart';
import 'package:smart_store/api/response/slider_product_response.dart';
import 'package:smart_store/page/profile/signin/sigin_screen.dart';
import 'package:smart_store/page/search_page/search_page.dart';
import 'package:smart_store/widget/global_product.dart';
import 'package:smart_store/widget/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../api/request/api.dart';
import '../../api/response/cart_response.dart';
import '../../api/response/favorite_response.dart';
import '../../api/response/get_info.dart';
import '../../api/response/prod_category_res.dart';
import '../all_products/all_product_screen.dart';
import '../cart/cart_screen.dart';
import '../order/order_product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? id;
  final String? name;
  final String? price;
  final String? descript;
  final String? idCategory;
  final String? image;
  const ProductDetailScreen(
      {Key? key,  this.idCategory, this.id, this.name, this.price, this.descript, this.image})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int activeIndex = 0;
  int maxText = 8;
  int? onComment;
  TextEditingController comment = TextEditingController();
  String? commentText;
  int? cError;
  @override
  int _itemCount = 1;
  List imageComment = [];
  static String? userID;
  void initState() {
    super.initState();
    setState(() {
      getUser();
    });
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }
  File? image;
  Future selectImage(ImageSource source) async{

    final  selectImg =   await ImagePicker().pickImage(source: source);
    if(selectImg != null){
      File convertFile = File(selectImg.path);

      setState(() {

        image = convertFile;
        imageComment.add(image);



      });
    }

  }
  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Tải ảnh hồ sơ lên"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(

              onTap: ()async{
                // Navigator.pop(context);
                await selectImage(ImageSource.gallery);
                Get.back();




              },
              leading: Icon(Icons.photo_album_rounded),
              title: Text('Chọn từ thư viện'),
            ),

            ListTile(
              onTap:()async{
                await selectImage(ImageSource.camera);
                Get.back();



              },
              leading: Icon(Icons.camera_alt),
              title: Text('Chụp ảnh'),
            ),
          ],
        ),


      );
    });
  }
  Future refreshScreen()async{
    setState((){});

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        // centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          //don't delete
          FutureBuilder<CartResponse?>(
            future: getCart(userID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
                      child: IconButton(
                          onPressed: () async {
                            if (userID != null) {
                              Get.to(CartScreen(
                                  userID: int.parse(userID.toString())));
                            } else {
                              String refresh = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignInScreen();
                              }));
                              if (refresh == "refresh") {
                                getUser();
                              }
                            }
                          },
                          icon: SvgPicture.asset('assets/images/cart.svg')),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 27,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: snapshot.data?.cart?.length != null
                                ? Colors.blue.shade700
                                : null),
                        child: Text(
                          snapshot.data?.cart?.length.toString() ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8.0),
                child: IconButton(
                    onPressed: () {
                      Get.to(CartScreen(userID: int.parse(userID.toString())));
                    },
                    icon: SvgPicture.asset(
                      'assets/images/cart.svg',
                      color: Colors.black,
                    )),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        strokeWidth: 3,
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            FutureBuilder<ProdsliderRes?>(
              future: getSliderProduct(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: CarouselSlider.builder(
                          itemCount: snapshot.data?.slider?.length,
                          options: CarouselOptions(
                            aspectRatio: 20 / 16,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            enlargeCenterPage: true,

                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },

                            viewportFraction: 1,
                            // enlargeCenterPage: true,
                            // enableInfiniteScroll: true
                          ),
                          itemBuilder: (context, index, realIndex) {
                            return InkWell(
                              onTap: () {
                                Get.to(PhotoView(
                                  id: widget.id,
                                ));
                              },
                              child: Image.network(
                                snapshot.data?.slider?[index].linkImg ?? '',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              // border:Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                                '${activeIndex + 1}/${snapshot.data?.slider?.length ?? 0}'),
                          )),
                    ],
                  );
                }
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: CarouselSlider.builder(
                        itemCount: 1,
                        options: CarouselOptions(
                          aspectRatio: 20 / 16,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          enlargeCenterPage: true,

                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },

                          viewportFraction: 1,
                          // enlargeCenterPage: true,
                          // enableInfiniteScroll: true
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        right: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            // border:Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                              '${activeIndex + 1}/${snapshot.data?.slider?.length ?? 0}'),
                        )),
                  ],
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(widget.name ?? ''.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.3),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                               NumberFormat.simpleCurrency(locale: 'vi')
                                      .format(double.parse(
                                              widget.price.toString()) *
                                          _itemCount),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  height: 2,
                                  fontSize: 18,
                                  letterSpacing: 1.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/star.png',
                                  height: 20,
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('4.6 (120 reviews) | Đã bán 72')
                              ],
                            ),
                            FutureBuilder<FavoriteResponse?>(
                                future: getFavoriteId(userID, widget.id),
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            if (userID != null) {

                                                snapshot.data?.favorite
                                                            ?.length ==
                                                        null
                                                    ? await addFavorite(
                                                            widget.id,
                                                            userID)
                                                        .then((value) async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        setState(() {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            backgroundColor:
                                                                Colors.black54,
                                                            width: 300,
                                                            content: Text(
                                                              'Đã thêm vào sản phẩm yêu thích!',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      1),
                                                            ),
                                                            elevation: 3.0,
                                                            duration: Duration(
                                                                seconds: 2),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ));
                                                        });
                                                      })
                                                    : await removeFavorite(
                                                            widget.id,
                                                            userID)
                                                        .then((value) async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        setState(() {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            backgroundColor:
                                                                Colors.black54,
                                                            width: 300,
                                                            content: Text(
                                                              'Đã xóa khỏi sản phẩm yêu thích!',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      1),
                                                            ),
                                                            elevation: 3.0,
                                                            duration: Duration(
                                                                seconds: 2),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ));
                                                        });
                                                      });

                                            } else {
                                              Get.to(SignInScreen());
                                            }
                                          },
                                          child:
                                              snapshot.data?.favorite?.length !=
                                                      null
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_border_outlined,
                                                    )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/share.png',
                                        height: 20,
                                        width: 30,
                                      )
                                    ],
                                  );
                                })
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 10,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          'Thông tin sản phẩm',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.descript ?? '',
                                style: TextStyle(),
                                maxLines: maxText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        maxText == 8
                            ? InkWell(
                                onTap: () {
                                  setState(() {

                                        maxText = widget.descript?.length ??0;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Xem thêm',
                                        style: TextStyle(
                                            fontSize: 16, letterSpacing: 1),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    maxText = 8;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Thu gọn',
                                        style: TextStyle(
                                            fontSize: 16, letterSpacing: 1),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.keyboard_arrow_up)
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 7,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Bình luận'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: onComment != null,
                          replacement: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: TextField(
                              readOnly: true,
                              onTap: () {

                                setState(() {
                                  onComment = 1;
                                  cError = 1;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Mời bạn để lại bình luận...',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade500)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade500)),
                              ),
                              maxLines: 4,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade500)
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: TextFormField(
                                        onEditingComplete: (){
                                          setState((){
                                            cError = 1;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Mời bạn để lại bình luận...',
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        maxLines: 4,
                                        controller: comment,
                                        // validator: ,


                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width*.95,
                                      color: Colors.grey.shade500,


                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                                showPhotoOptions();
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset("assets/images/camera.png",
                                                height: 25,
                                                  width: 25,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(width: 5,),
                                                Text('Gửi ảnh')
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            child: ElevatedButton(
                                              onPressed: () async{
                                                if(comment.text == ''){
                                                  setState((){

                                                    cError = null;
                                                    Future.delayed(Duration(seconds: 1));



                                                  });
                                                }
                                                else{
                                                  setState((){
                                                    onComment = null;
                                                    commentText = comment.text;
                                                    comment.clear();


                                                  });

                                                  if(image == null){
                                                    await createComment(
                                                        commentText,
                                                        null,
                                                        userID,
                                                        widget.id);
                                                  }
                                                  else{
                                                    await createComment(
                                                        commentText,
                                                        image!,
                                                        userID,
                                                        widget.id);
                                                  }
                                                }

                                               },



                                              child: Text('Gửi'),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                // padding: EdgeInsets.symmetric(vertical: 5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Visibility(
                                visible: cError!=null,
                                replacement: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Bạn chưa nhập bình luận",
                                      style: TextStyle(
                                        color: Colors.red
                                      ),
                                      ),
                                    ],
                                  ),
                                ),

                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: imageComment.length,
                                  itemBuilder: (context,index){
                                    return  image!=null ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.file(imageComment[index],
                                            width: MediaQuery.of(context).size.width*.2,
                                          ),
                                        ],
                                      ),
                                    ):Center();
                                  },
                                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    childAspectRatio: 4 / 4,
                                  ),


                                )
                                ,
                              ),


                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<CommentResponse?>(
                          future: getComment(widget.id),
                          builder: (context,snaphot){
                            return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snaphot.data?.comment?.length??0,
                                itemBuilder: (context,index){
                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  snaphot.data?.comment?[index].avatar??''),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              snaphot.data?.comment?[index].fullname??'',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  snaphot.data?.comment?[index].comment??''),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Visibility(
                                          visible: snaphot.data?.comment?[index].img?.length!=0,
                                          child: Row(
                                            children: [
                                              Image.network(snaphot.data?.comment?[index].img??'',
                                                width: MediaQuery.of(context).size.width*.3,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              snaphot.data?.comment?[index].time??'',
                                              style:  TextStyle(
                                                  fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                                  return  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey.shade300,
                                  );
                            },
                            );
                          },

                        )

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 7,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 10,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .95,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sản phẩm tương tự",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.to(AllProductsScreen(
                                      id_category: widget.idCategory,
                                    ));
                                  },
                                  child: Text(
                                    "Xem thêm >>",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue.shade700),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       topRight: Radius.circular(20)
                  //   ),
                  //   child:
                  // ),
                ],
              ),
            ),
            FutureBuilder<ProdCategoryRes?>(
                future: getCategoryProduct(widget.idCategory),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, int index) {
                          return AspectRatio(
                            aspectRatio: 3 / 4.5,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(ProductDetailScreen(
                                  idCategory: widget.idCategory,
                                  id: snapshot.data?.prodCategory?[index].id.toString(),
                                  name: snapshot.data?.prodCategory?[index].name,
                                  price: snapshot.data?.prodCategory?[index].price.toString(),
                                  descript: snapshot.data?.prodCategory?[index].descript,
                                  image: snapshot.data?.prodCategory?[index].imgLink,
                                ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GlobalProduct(
                                  imageLink: snapshot
                                      .data?.prodCategory?[index].imgLink,
                                  shortDes: snapshot
                                      .data?.prodCategory?[index].shortDes,
                                  // price:NumberFormat("###,###.# đ").format(snapshot.data?.products?[index].price),
                                  price:
                                      '${snapshot.data?.prodCategory?[index].price ?? ''}',
                                  nameProduct:
                                      '${snapshot.data?.prodCategory?[index].name}',
                                  numStar: '5.0',
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 3,
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, int index) {
                        return AspectRatio(
                          aspectRatio: 3 / 4.5,
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width * .3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: Colors.red),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height: 12,
                                        color: Colors.white,
                                      ),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                )),
                                SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .3,
                                                  height: 12,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 3,
                        );
                      },
                    ),
                  );
                }),
            SizedBox(height: 50,),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.transparent,
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if (userID != null) {

                        await postAddCart(
                                userID, widget.id, _itemCount)
                            .then((value) async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black54,
                            width: 200,
                            content: Text(
                              'Đã thêm vào giỏ hàng!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: 1),
                            ),
                            elevation: 3.0,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ));
                          setState(() {});
                        });

                    } else {
                      String refresh = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignInScreen();
                      }));
                      if (refresh == "refresh") {
                        getUser();
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: FaIcon(
                            FontAwesomeIcons.cartPlus,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
                FutureBuilder<GetInfo?>(
                  future: getInfo(userID),
                  builder: (context, snapshot) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (userID != null) {
                              Get.to(OrderProduct(
                                thumnail: widget.image,
                                namePro: widget.name,
                                price: widget.price,
                                amount: _itemCount,
                                idPro: widget.id,
                                userID: int.parse(userID ?? ''),
                                userData: snapshot.data?.user,
                              ));
                            } else {
                              String refresh = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignInScreen();
                              }));
                              if (refresh == "refresh") {
                                getUser();
                              }
                            }
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: Colors.black),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

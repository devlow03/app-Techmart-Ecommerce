import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../api/request/api.dart';
import '../api/response/slider_product_response.dart';
class PhotoView extends StatefulWidget {
  final String? id;
  const PhotoView({Key? key, this.id}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  var path = "";
  void  saveImage()async{

  }
 int  activeIndex = 0;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: FutureBuilder<SliderProductResponse?>(
        future: getSliderProduct(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: CarouselSlider.builder(
                    itemCount: snapshot.data?.slider?.length,
                    options: CarouselOptions(
                      aspectRatio: 20/14,
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
                        onLongPress: (){
                          Get.dialog(
                            AlertDialog(
                              content: InkWell(
                                  onTap: ()async{
                                    await GallerySaver.saveImage(snapshot.data?.slider?[index].linkImg??'',toDcim: true).then((value) {
                                      Get.back();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.black54,
                                            width: 300,
                                            content: Text('Đã tải ảnh!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1
                                              ),
                                            ),
                                            elevation: 3.0,
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                          )

                                      );
                                    });
                                  },
                                  child: Text('Tải ảnh về máy')),
                            )
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 20/14,
                          child: Image.network(
                            snapshot.data?.slider?[index].linkImg ?? '',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
                AnimatedSmoothIndicator(
                  count: snapshot.data?.slider?.length ?? 0,
                  activeIndex: activeIndex,
                  effect: ScrollingDotsEffect(
                      dotWidth: 7,
                      dotHeight: 7,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.white),
                )


              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 4,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_store/api/request/api.dart';
import 'package:smart_store/api/response/new_response.dart';
import 'package:smart_store/widget/global_webview.dart';
class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title:Text('Tin tức công nghệ',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/bell_ico.png")
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        strokeWidth: 3,
        onRefresh: ()async{
          await getNews().then((value) {
            setState((){});
          });

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            FutureBuilder<NewResponse?>(
              future: getNews(),
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.articles?.length??0,
                    itemBuilder: (context, index) {

                      return InkWell(
                        onTap: (){
                          Get.to(GlobalWebview(
                            tittleWeb: snapshot.data?.articles?[index].title??'',
                            linkWeb: snapshot.data?.articles?[index].url??'',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200,width: 1.5),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text(
                                            snapshot.data?.articles?[index].title ?? '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                height: 1.5,

                                                fontSize: 15),
                                            maxLines: 3,
                                            overflow: TextOverflow.visible,
                                          )),
                                      SizedBox(width: 5,),
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.network(
                                            snapshot.data?.articles?[index].urlToImage ?? '',
                                            fit: BoxFit.cover,
                                            width:
                                            MediaQuery.of(context).size.width *
                                                .55,
                                            height: 130,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),
                      );
                    },

                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 250,),
                        Text('Không có kết nối',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('Vui lòng kiểm tra kết nối mạng và thử lại'),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              primary: Colors.blue.shade700
                          ),
                          child: Text('Thử lại'),
                          onPressed: (){
                            setState((){});
                          },
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200,width: 1.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                          width: MediaQuery.of(context).size.width * .25,
                                          child: Container(
                                            height: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          height: 10,
                                          width: MediaQuery.of(context).size.width * .25,
                                          child: Container(
                                            height: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          height: 10,
                                          width: MediaQuery.of(context).size.width * .25,
                                          child: Container(
                                            height: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          height: 120,
                                          width: MediaQuery.of(context).size.width*.55,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  },

                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 15,
                    );
                  },
                );




              },
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),

    );
  }
}

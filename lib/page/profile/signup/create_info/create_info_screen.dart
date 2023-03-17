import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/request/api.dart';
import '../../../../api/response/city_response.dart';
import '../../../../api/response/district_response.dart';
import '../../../../api/response/ward_response.dart';
import '../../../../widget/global_textfield.dart';
class CreateInfoScreen extends StatefulWidget {
 final String? token;
  const CreateInfoScreen({Key? key, this.token,  }) : super(key: key);

  @override
  State<CreateInfoScreen> createState() => _CreateInfoScreenState();
}

class _CreateInfoScreenState extends State<CreateInfoScreen> {
  TextEditingController fullName = TextEditingController();
  // TextEditingController ciTy = TextEditingController();
  // TextEditingController district= TextEditingController();
  // TextEditingController ward = TextEditingController();
  TextEditingController phone = TextEditingController();
  int itemCount=1;
  String? cityChosse;
  String? disChosse;
  String? wardChosse;
  File? image;
  Future selectImage(ImageSource source) async{

    final  selectImg =   await ImagePicker().pickImage(source: source);
    if(selectImg != null){
      File convertFile = File(selectImg.path);

      setState(() {

        image = convertFile;



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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.grey.shade100,

          centerTitle: true,
          title: Text("Thông tin cá nhân",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: ()async{},
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage:
                  image!=null?FileImage(image!) as ImageProvider:NetworkImage("https://cdn-icons-png.flaticon.com/512/4322/4322991.png"),
                  radius: 35,
                  backgroundColor: Colors.white,
                  // child: Image.asset(
                  //   ("resources/images/Item_camera.png"),
                  // ),
                ),
                // ),
              ),
              TextButton(
                  onPressed: ()async{
                    showPhotoOptions();

                  },
                  child: Text("Chọn ảnh đại diện",
                    style: TextStyle(
                        color: Colors.blue
                    ),

                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlobalTextField(
                        controller: fullName,
                        hint: 'Nhập họ tên',
                        requireInput: '',
                        // validator: Validator.fullname,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                      ),
                      SizedBox(height: 15,),

                      Column(
                        children: [

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
                                            cityChosse = null;
                                            disChosse = null;
                                            wardChosse = null;
                                          },
                                          child: Text(e.name ?? ''));
                                    }).toList(),


                                    onChanged: (newValue) {
                                      setState(() {
                                        cityChosse = newValue;


                                      });
                                    },
                                    menuMaxHeight:
                                    MediaQuery.of(context).size.height * .9,
                                    isDense: true,
                                    value: cityChosse,
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
                            future: getDistrict(cityChosse),
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
                                            disChosse = null;
                                            wardChosse = null;
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


                                      });
                                    },

                                    value: disChosse,
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
                            future: getWard(disChosse),
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


                                              wardChosse=null;
                                              // disChosse = null;

                                            });
                                          },
                                          child: Text(e.name ?? ''));
                                    }).toList(),
                                    onChanged: (Value) {
                                      setState(() {
                                        wardChosse = Value;

                                      });
                                    },
                                    value: wardChosse,
                                    isExpanded: true,
                                  ),
                                ],
                              );
                            },
                          ),




                        ],
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
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                              shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                          primary: Colors.blue.shade700,
                          // side: BorderSide(
                          //     color: Colors.blue.shade700,
                          //     width: 1
                          // )
                          ),
                          onPressed: ()async{
                            if(fullName.text=='' && cityChosse=='' && disChosse == '' && wardChosse=='' && phone.text==''){
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
                                      "Thông tin không được để trống!",
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
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                              );
                              await Future.delayed(Duration(seconds: 2));
                              await createInfo(
                                widget.token,
                                  image,
                                  fullName.text,
                                  cityChosse,
                                  disChosse,
                                  wardChosse,
                                  phone.text,
                                  ).then((value)async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState((){
                                  String? token = widget.token;
                                  prefs.setString('token', token!);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context,'refresh');

                                });

                                // Navigator.pop(context,'refresh');
                              }).catchError((e)async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                print(prefs.getString('token'));
                                Get.dialog(AlertDialog(
                                  backgroundColor: Colors.white,
                                  insetPadding: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  contentPadding: EdgeInsets.all(15),

                                  title: Column(
                                    children: [
                                      Text("Tạo thông tin cá nhân thất bại!",style: TextStyle(
                                          fontSize: 17,fontWeight: FontWeight.w700,letterSpacing: 1
                                      ),),
                                      SizedBox(height: 20,),
                                      Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.red)
                                          ),
                                          child: Icon(Icons.close,color: Colors.red,size: 50,)),
                                    ],
                                  ),
                                  // content: Text('Tài khoản này đã tồn tại trên hệ thống!',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),

                                  actions: [
                                    Center(
                                      child: Container(
                                        // padding:EdgeInsets.all(30),
                                        width:MediaQuery.of(context).size.width*.6,
                                        height: 50,
                                        child: ElevatedButton(onPressed: (){
                                          Get.back();
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
                          child: Text('Hoàn tất',
                          style: TextStyle(
                            color: Colors.white
                          ),
                          ),
                        ),
                      )


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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/api/request/api.dart';
import '../../../api/response/city_response.dart';
import '../../../api/response/district_response.dart';
import '../../../api/response/user.dart';
import '../../../api/response/ward_response.dart';
import '../../../widget/global_textfield.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  const ProfileDetailScreen({Key? key, this.token, this.userData}) : super(key: key);

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  String? cityCode;
  String? disCode;
  String? wardCode;
  String? cityChosse;
  String? disChosse;
  String? wardChosse;
  int itemCount = 1;
  refreshData() {
    setState(() {});
  }

  void initState() {
    setState(() {
      getUser();
    });
  }

  File? image;
  Future selectImage(ImageSource source) async {
    final selectImg = await ImagePicker().pickImage(source: source);
    if (selectImg != null) {
      File convertFile = File(selectImg.path);

      setState(() {
        image = convertFile;
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Tải ảnh hồ sơ lên"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    // Navigator.pop(context);
                    await selectImage(ImageSource.gallery);
                    Get.back();
                    await updateAvatar(image, widget.token).then((value) {
                      setState(() {});
                    });
                  },
                  leading: Icon(Icons.photo_album_rounded),
                  title: Text('Chọn từ thư viện'),
                ),
                ListTile(
                  onTap: () async {
                    await selectImage(ImageSource.camera);
                    Get.back();
                    await updateAvatar(image, widget.token).then((value) {
                      setState(() {});
                    });
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text('Chụp ảnh'),
                ),
              ],
            ),
          );
        });
  }

  Future getUser() async {
    cityCode = widget.userData?.city.toString();
    disCode = widget.userData?.district.toString();
    wardCode = widget.userData?.ward.toString();
    fullName.text =  widget.userData?.fullname.toString()??'';
    phone.text =  widget.userData?.phone.toString()??'';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.shade200,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "Thông tin tài khoản",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            FutureBuilder<User?>(
              future: getInfo(widget.token),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: image != null
                            ? FileImage(image!) as ImageProvider
                            : NetworkImage(
                                'https://smartstore.khanhnhat.top${snapshot.data?.avatar ?? ''}',
                              ),
                        radius: 35,
                        backgroundColor: Colors.white,
                        // child: Image.asset(
                        //   ("resources/images/Item_camera.png"),
                        // ),
                      ),
                      // ),
                    ),
                    TextButton(
                        onPressed: () async {
                          showPhotoOptions();
                        },
                        child: Text(
                          "Đổi ảnh đại diện",
                          style: TextStyle(color: Colors.blue),
                        )),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    'K${snapshot.data?.userID}H ',
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
                            GlobalTextField(
                              title: 'Họ tên',
                              hint: 'Nhập họ tên',
                              controller: fullName,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Tỉnh / Thành phố',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white),
                                      elevation: 1,
                                      hint: Text('Chọn tỉnh/thành phố'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,
                                            onTap: () {
                                              cityCode = null;
                                              disChosse = null;
                                              disCode = null;
                                              disChosse = null;
                                              wardCode = null;
                                              wardChosse = null;
                                            },
                                            child: Text(e.name ?? ''));
                                      }).toList(),
                                      onChanged: (newCity) {
                                        setState(() {
                                          cityChosse = newCity;
                                          cityCode == null;
                                        });
                                      },
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height *
                                              .9,
                                      isDense: true,
                                      value: cityCode != null
                                          ? cityCode
                                          : cityChosse,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Quận / Huyện',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FutureBuilder<DistrictResponse?>(
                              future: getDistrict(
                                  cityCode != null ? cityCode : cityChosse),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white),
                                      elevation: 1,
                                      hint: Text('Chọn quận/huyện'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,
                                            onTap: () {
                                              setState(() {
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
                                      onChanged: (newDis) {
                                        setState(() {
                                          disChosse = newDis;
                                          disCode = null;
                                          wardCode = null;
                                          wardChosse = null;
                                        });
                                      },

                                      value:
                                          disCode != null ? disCode : disChosse,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Phường / Xã',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FutureBuilder<WardResponse?>(
                              future: getWard(
                                  disCode != null ? disCode : disChosse),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white),
                                      elevation: 1,
                                      hint: Text('Chọn phường/xã'),
                                      items: snapshot.data?.results?.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.code,
                                            onTap: () {
                                              setState(() {
                                                wardCode = null;
                                                wardChosse = null;
                                                // disChosse = null;
                                              });
                                            },
                                            child: Text(e.name ?? ''));
                                      }).toList(),
                                      onChanged: (newWard) {
                                        setState(() {
                                          wardChosse = newWard;
                                          wardCode = null;
                                        });
                                      },
                                      value: wardCode != null
                                          ? wardCode
                                          : wardChosse,
                                      isExpanded: true,
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            GlobalTextField(
                              title: 'Điện thoại',
                              hint: 'Nhập số điện thoại',
                              controller: phone,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),

                            //don't delete

                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .55,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await postUser(
                                      widget.token,
                                          fullName.text,
                                          cityCode != null
                                              ? cityCode
                                              : cityChosse,
                                          disCode != null ? disCode : disChosse,
                                          wardCode != null
                                              ? wardCode
                                              : wardChosse,
                                          phone.text
                                          )
                                      .then((value) {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.blue.shade700,
                                        content: Text('Cập nhật thành công'),
                                        duration: Duration(seconds: 2),
                                      ));
                                    });
                                  });
                                },
                                child: Text('Cập nhật thông tin'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    primary: Colors.blue.shade700),
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

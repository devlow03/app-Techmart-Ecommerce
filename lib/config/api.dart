import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class API{
  String? baseApi = "https://store356.000webhostapp.com";
  getApi(String? link,)async{
    Dio dio = Dio();
    Response response = await dio.get('$baseApi/$link');
    // debugPrint('$response.data.toString()');
    return response.data;
  }
  Future getApiParam(String? link) async{

    Dio dio = Dio();
    Response response = await dio.get('$baseApi + $link');
    debugPrint('data: $response.toString()');
    return response;
  }

}


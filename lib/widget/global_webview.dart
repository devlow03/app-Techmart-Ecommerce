import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
class GlobalWebview extends StatefulWidget {
  final String? tittleWeb;
  final String? linkWeb;
  const GlobalWebview({Key? key, this.tittleWeb, this.linkWeb}) : super(key: key);

  @override
  State<GlobalWebview> createState() => _GlobalWebviewState();
}

class _GlobalWebviewState extends State<GlobalWebview> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.tittleWeb??'',style: const TextStyle(color: Colors.black),maxLines: 1,overflow: TextOverflow.ellipsis,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Get.back();
          },
        ),


      ),
      body: WebView(
        initialUrl: widget.linkWeb??'',
        // initialUrl: "https://www.thegioididong.com/",
        javascriptMode: JavascriptMode.unrestricted,

      ),
    );
  }
}

import 'package:flutter/material.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin ứng dụng',
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Text("Ứng dụng thương mại điện tử Tech Mart",
            style: TextStyle(
              color: Colors.black
            ),
            ),
            SizedBox(height: 10,),
            Text("Nhà phát triển : Thiendev",
              style: TextStyle(
                  color: Colors.black
              ),
            )
          ],
        ),
      ),
    );
  }
}


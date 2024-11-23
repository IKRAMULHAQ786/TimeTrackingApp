import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final String text;
  const Loader({super.key, this.text = 'Loading ..'});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitFadingCircle(color: Colors.blueGrey),
            const SizedBox(height: 10),
            Text(text, style: TextStyle(fontSize: 10.sp))
          ],
        ));
  }
}

import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyContainer extends StatelessWidget {
  const MyContainer(
      {required this.child, this.width, this.height, this.padding, super.key});
  final Widget child;
  final double? width;
  final double? height;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding == null
          ? const EdgeInsets.only(left: 30, top: 15, right: 30, bottom: 15)
          : EdgeInsets.all(padding!),
      width: width ??
          ((Device.screenType == ScreenType.mobile)
              ? Adaptive.w(80)
              : Adaptive.w(60)),
      height: height,
      decoration: const BoxDecoration(
        color: Vzhled.dialogColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(255, 74, 74, 74).withOpacity(0.25),
        //     spreadRadius: 3,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Padding(padding: const EdgeInsets.all(15), child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Předloha pro widgety, které se mění podle druhu zařízení
abstract class DeviceWidget<D extends Widget, M extends Widget>
    extends StatelessWidget {
  const DeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (Device.screenType == ScreenType.mobile) {
      return buildProMobily(context);
    } else {
      return buildProDesktop(context);
    }
  }

  M buildProMobily(BuildContext context);

  D buildProDesktop(BuildContext context);
}

class DeviceContainer extends DeviceWidget<Row, Column> {
  final MainAxisAlignment mainAxisAlignmentMobile;
  final MainAxisAlignment mainAxisAlignmentDesktop;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  /// Vytvoří kontejner, kde na mobilech je [Column] a na ostatních [Row]
  const DeviceContainer(
      {super.key,
      this.children = const [],
      this.mainAxisAlignmentMobile = MainAxisAlignment.center,
      this.mainAxisAlignmentDesktop = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center});

  @override
  Row buildProDesktop(BuildContext context) => Row(
        mainAxisAlignment: mainAxisAlignmentDesktop,
        children: children,
      );

  @override
  Column buildProMobily(BuildContext context) => Column(
        mainAxisAlignment: mainAxisAlignmentMobile,
        children: children,
      );
}

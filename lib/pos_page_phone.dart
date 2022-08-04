import 'package:flutter/material.dart';
import 'package:foodable/layout/panel-left/pos_panel_left_lg.dart';
import 'package:foodable/layout/panel_right/panel_right.dart';
import 'package:foodable/pages/pos/generate_bill.dart';

class PosPagePhone extends StatelessWidget {
  PosPagePhone({Key? key}) : super(key: key);
  final PageController controller = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      scrollDirection: Axis.horizontal,
      controller: controller,
      onPageChanged: (int page) {
        FocusScope.of(context).unfocus();
      },
      children: <Widget>[
        PosPanelLeftLgPage(),
        PanelRightPage(),
        GenerateBill(),
      ],
    );
  }
}

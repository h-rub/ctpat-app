import 'package:ctpat/src/providers/navegacion_info.dart';
import 'package:ctpat/src/screens/history/history_page.dart';
import 'package:ctpat/src/screens/inicio/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pages extends StatefulWidget {
  const Pages({Key key}) : super(key: key);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  Widget build(BuildContext context) {
    final navegacionInfo = Provider.of<NavegacionInfo>(context);
    return PageView(
      controller: navegacionInfo.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Home(),
        HistoryPage(),
      ],
    );
  }
}

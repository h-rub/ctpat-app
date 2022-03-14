import 'package:ctpat/src/providers/navegacion_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../screens.dart';

import '../../services/theme_service.dart';
import '../../../src/themes/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: NavigationBar(),
      appBar: appBar(context),
      body: Pages(),
    );
  }
}

Widget appBar(context) {
  return AppBar(
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/nidec-embraco.png')),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/me');
          },
          child: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/default-profile.png"),
                    fit: BoxFit.cover)),
          ),
        ),
      ],
    ),
  );
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navegacionInfo = Provider.of<NavegacionInfo>(context);

    return BottomNavigationBar(
      currentIndex: navegacionInfo.currentPage,
      onTap: (index) {
        if (index == 2) {
          print("Cerrar sesión");
        } else {
          navegacionInfo.currentPage = index;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historial"),
        BottomNavigationBarItem(
            icon: Icon(Icons.logout), label: "Cerrar sesión")
      ],
    );
  }
}

import 'dart:convert';

import 'package:ctpat/src/providers/navegacion_info.dart';
import 'package:ctpat/src/providers/shipping_info.dart';
import 'package:ctpat/src/providers/user_info.dart';
import 'package:ctpat/src/themes/theme.dart';
import 'package:ctpat/src/tokens/colors.dart';
import 'package:ctpat/src/tokens/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List data = [];

  loadDataHome() async {
    setState(() {
      isLoading = true;
    });
    print("Cargando datos");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'apikey': 'cFmS80yo.noGef99U2EGqhARloqbE1qEhDFKVLIih'
    };

    String url = "https://api.embraco.com/ctpat/forms/forms/all";
    print(url);
    var jsonResponse;
    var res = await http.get(url, headers: requestHeaders);

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      print("Response JSON ${jsonResponse}");
      setState(() {
        data = new List.from(jsonResponse.reversed);
      });
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDataHome();
  }

  @override
  Widget build(BuildContext context) {
    final navegacionInfo = Provider.of<NavegacionInfo>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final userInfo = Provider.of<UserInfo>(context);
    final shippingInfo = Provider.of<ShippingInfo>(context);
    return isLoading
        ? HomeLoading(
            height: _height,
            width: _width,
            navegacionInfo: navegacionInfo,
          )
        : Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 17.0, left: 14.0, right: 14.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            // TODO: Hacerlo dinámico
                            "Bienvenido ${userInfo.firstName}",
                            style: body),
                        GestureDetector(
                          onTap: () {
                            print("Actualizar data");
                            loadDataHome();
                            // TODO Implementar la navegación a historial
                          },
                          child: Row(
                            children: [
                              IconButton(
                                color: primaryClr,
                                tooltip: "Actualizar datos",
                                icon: const Icon(Icons.update),
                                onPressed: () {
                                  loadDataHome();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 11),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Reportes",
                          style: GoogleFonts.poppins(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      //TODO: Implementar el acceso al formulario
                      print("Registrar embarque");
                      Navigator.of(context).pushNamed('create');
                    },
                    child: Container(
                      height: _height / 7.5,
                      width: _width - 5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    color: primaryClr,
                                    iconSize: 70,
                                    icon: SvgPicture.asset(
                                      'assets/truck.svg',
                                      color: primaryClr,
                                    ),
                                    onPressed: () {
                                      //TODO: Implementar el acceso al formulario
                                      print("Registrar embarque");
                                      Navigator.of(context).pushNamed('create');
                                    }),
                                Text(
                                  "Registrar embarque",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Recientemente creado",
                          style: GoogleFonts.poppins(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Ir a historial");
                            navegacionInfo.currentPage = 1;
                            // TODO Implementar la navegación a historial
                          },
                          child: Text(
                            "Ver todo",
                            style: GoogleFonts.poppins(
                              color: primaryClr,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, position) {
                            var report = data[position];
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {
                                  final _box = GetStorage();
                                  _box.write("shipmentID", report['pk']);
                                  shippingInfo.id = report['pk'];
                                  Navigator.pushNamed(
                                      context, '/shipping-details');
                                },
                                leading: Icon(Icons.list),
                                trailing: report['isOk']
                                    ? Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : Icon(Icons.warning, color: Colors.yellow),
                                title: Text("Destino: \n${report['destino']}"),
                                subtitle: Text(
                                    "${report['placas_tractor']}-${report['placas_caja']}"),
                              ),
                            );
                          })),
                ],
              ),
            ),
          );
  }
}

class HomeLoading extends StatelessWidget {
  const HomeLoading({
    Key key,
    @required double height,
    @required double width,
    @required this.navegacionInfo,
  })  : _height = height,
        _width = width,
        super(key: key);

  final double _height;
  final double _width;
  final NavegacionInfo navegacionInfo;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 3), //Default value
      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
      color: Colors.white, //Default value
      enabled: true, //Default value
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        child: Column(
          children: [
            Column(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                ),
              ],
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                //TODO: Implementar el acceso al formulario
                print("Registrar embarque");
                Navigator.of(context).pushNamed('create');
              },
              child: Container(
                height: _height / 7.5,
                width: _width - 5,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: 8,
                    itemBuilder: (BuildContext context, position) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/shipping-details');
                          },
                          title: Text(""),
                          subtitle: Text(""),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}

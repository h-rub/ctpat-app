import 'dart:convert';

import 'package:ctpat/src/providers/navegacion_info.dart';
import 'package:ctpat/src/screens/homepage/home_page.dart';
import 'package:ctpat/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../details/data_shipping.dart';

import '../screens.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails>
    with TickerProviderStateMixin {
  // TickerProviderStateMixin allows the fade out/fade in animation when changing the active button

  // this will control the button clicks and tab changing
  TabController _controller;

  // this will control the animation when a button changes from an off state to an on state
  AnimationController _animationControllerOn;

  // this will control the animation when a button changes from an on state to an off state
  AnimationController _animationControllerOff;

  // this will give the background color values of a button when it changes to an on state
  Animation _colorTweenBackgroundOn;
  Animation _colorTweenBackgroundOff;

  // this will give the foreground color values of a button when it changes to an on state
  Animation _colorTweenForegroundOn;
  Animation _colorTweenForegroundOff;

  // when swiping, the _controller.index value only changes after the animation, therefore, we need this to trigger the animations and save the current index
  int _currentIndex = 0;

  // saves the previous active tab
  int _prevControllerIndex = 0;

  // saves the value of the tab animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
  double _aniValue = 0.0;

  // saves the previous value of the tab animation. It's used to figure the direction of the animation
  double _prevAniValue = 0.0;

  // these will be our tab icons. You can use whatever you like for the content of your buttons
  List _icons = ["Resumen", "CheckList", "Revisión Canina"];

  // active button's foreground color
  Color _foregroundOn = Colors.white;
  Color _foregroundOff = Colors.black;

  // active button's background color
  Color _backgroundOn = primaryClr;
  Color _backgroundOff = Colors.grey[300];

  // scroll controller for the TabBar
  ScrollController _scrollController = new ScrollController();

  // this will save the keys for each Tab in the Tab Bar, so we can retrieve their position and size for the scroll controller
  List _keys = [];

  // regist if the the button was tapped
  bool _buttonTap = false;

  List data;
  List resumen = [];
  List checkList = [];

  bool isLoading = true;

  loadDataShipment() async {
    List resumenListAPITemp = [];
    List checklistAPITemp = [];
    var thirdMap = {};
    var checkMap = {};
    setState(() {
      isLoading = true;
    });
    final _box = GetStorage();
    final shipmentID = _box.read("shipmentID");
    print("Cargando detalles del Shipment");

    String url =
        "http://ctpat.syncronik.com/api/v1/forms/details?shipment=${shipmentID}";
    print(url);
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {
        //'Authorization': "Token ${token}",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      //print("Response JSON ${jsonResponse}");
      var mydata = jsonResponse;
      for (var x in mydata) {
        thirdMap.addAll(x['resumen']);
        checkMap.addAll(x['checklist']);
        //print(x['ingreso']);
        //print(x['checklist']);
        //print(x['revision_canina']);
      }
      thirdMap.forEach((k, v) => resumenListAPITemp.add(ResumenData(k, v)));
      checkMap.forEach((k, v) => checklistAPITemp.add(ResumenData(k, v)));
      print(resumenListAPITemp);
      setState(() {
        resumen = resumenListAPITemp;
        checkList = checklistAPITemp;
        data = new List.from(jsonResponse);
      });
      print(resumen);
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

    loadDataShipment();

    for (int index = 0; index < _icons.length; index++) {
      // create a GlobalKey for each Tab
      _keys.add(new GlobalKey());
    }

    // this creates the controller with 6 tabs (in our case)
    _controller = TabController(vsync: this, length: _icons.length);
    // this will execute the function every time there's a swipe animation
    _controller.animation.addListener(_handleTabAnimation);
    // this will execute the function every time the _controller.index value changes
    _controller.addListener(_handleTabChange);

    _animationControllerOff =
        AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);
    _colorTweenForegroundOff =
        ColorTween(begin: _foregroundOn, end: _foregroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    _colorTweenForegroundOn =
        ColorTween(begin: _foregroundOff, end: _foregroundOn)
            .animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  formatDate(date) {
    if (date != 'null') {
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
      String finalDate = new DateFormat("dd/MM/yyyy").format(tempDate);
      String stringDate = finalDate.toString();
      return "${stringDate}";
    } else {
      return "-----------";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: isLoading
          ? ScreenLoading(width: _width, height: _height)
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: _width,
                        height: _height / 3.71,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Factura ${resumen[15].value}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  resumen[6].value
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : Icon(Icons.warning,
                                          color: Colors.yellow),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1.5, color: primaryClr)),
                                      ),
                                      Dash(
                                          direction: Axis.vertical,
                                          length: 50,
                                          dashLength: 15,
                                          dashColor: Colors.grey),
                                      Container(
                                        height: 25,
                                        width: 25,
                                        child: Expanded(
                                            child: FittedBox(
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: Colors.red,
                                                ),
                                                fit: BoxFit.fill)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 16, left: 0),
                                        child: Text("Apodaca"),
                                      ),
                                      SizedBox(
                                        height: 35,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 16, left: 15),
                                        child: Text("${resumen[19].value}"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Revisión realizada por ${resumen[2].value} el:",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          formatDate("${resumen[4].value}"),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 2.0),
                    child: Container(
                        height: 49.0,
                        // this generates our tabs buttons
                        child: ListView.builder(
                            // this gives the TabBar a bounce effect when scrolling farther than it's size
                            physics: BouncingScrollPhysics(),
                            controller: _scrollController,
                            // make the list horizontal
                            scrollDirection: Axis.horizontal,
                            // number of tabs
                            itemCount: _icons.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  // each button's key
                                  key: _keys[index],
                                  // padding for the buttons
                                  padding: EdgeInsets.all(6.0),
                                  child: ButtonTheme(
                                      child: AnimatedBuilder(
                                    animation: _colorTweenBackgroundOn,
                                    builder: (context, child) => FlatButton(
                                        // get the color of the button's background (dependent of its state)
                                        color: _getBackgroundColor(index),
                                        // make the button a rectangle with round corners
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(7.0)),
                                        onPressed: () {
                                          setState(() {
                                            _buttonTap = true;
                                            // trigger the controller to change between Tab Views
                                            _controller.animateTo(index);
                                            // set the current index
                                            _setCurrentIndex(index);
                                            // scroll to the tapped button (needed if we tap the active button and it's not on its position)
                                            _scrollTo(index);
                                          });
                                        },
                                        child: Text("${_icons[index]}",
                                            style: TextStyle(
                                                color: _getForegroundColor(
                                                    index)))),
                                  )));
                            })),
                  ),
                  Flexible(
                      // this will host our Tab Views
                      child: TabBarView(
                    // and it is controlled by the controller
                    controller: _controller,
                    children: <Widget>[
                      // our Tab Views
                      Column(children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: ListView.separated(
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider(
                                                    height: 5,
                                                    color: Colors.grey[300]);
                                              },
                                              itemCount: resumen.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      position) {
                                                print("Data length: ");
                                                var resumenShip =
                                                    resumen[position];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: ListTile(
                                                    onTap: () {},
                                                    leading:
                                                        Icon(Icons.list_alt),
                                                    title: Text(
                                                        "${resumenShip.title}"),
                                                    subtitle: Text(
                                                        "${resumenShip.value}"),
                                                  ),
                                                );
                                              })),
                                    ])))
                      ]),

                      Column(children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: ListView.separated(
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider(
                                                    height: 5,
                                                    color: Colors.grey[300]);
                                              },
                                              itemCount: checkList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      position) {
                                                print("Data length: ");
                                                var check = checkList[position];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: ListTile(
                                                    onTap: () {},
                                                    leading: check.value
                                                        ? Icon(Icons.check,
                                                            color: Colors.green)
                                                        : Icon(
                                                            Icons.close,
                                                          ),
                                                    title:
                                                        Text("${check.title}"),
                                                    subtitle: check.value
                                                        ? Text("Si")
                                                        : Text("No"),
                                                  ),
                                                );
                                              })),
                                    ])))
                      ]),

                      Text("Ventana tab 3"),
                    ],
                  )),
                ],
              ),
            ),
    );
  }

  // runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller.animation.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(_controller.index);

    // this resets the button tap
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    double screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(Offset.zero).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext.findRenderObject();
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[_icons.length - 1].currentContext.findRenderObject();
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated ammount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 30), curve: Curves.easeIn);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      // if it's active button
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      // if it's the previous active button
      return _colorTweenBackgroundOff.value;
    } else {
      // if the button is inactive
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    // the same as the above
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }
}

class ResumenData {
  String title;
  var value;

  ResumenData(this.title, this.value);

  @override
  String toString() {
    return '{ ${this.title}, ${this.value} }';
  }
}

class ResumenAPI {
  List data;

  ResumenAPI({this.data});
}

Widget _appBar(context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: primaryClr),
      onPressed: () => Navigator.of(context).pop(),
    ),
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

class ScreenLoading extends StatelessWidget {
  const ScreenLoading({
    Key key,
    @required double height,
    @required double width,
  })  : _height = height,
        _width = width,
        super(key: key);

  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 1), //Default value
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

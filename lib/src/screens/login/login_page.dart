import 'dart:convert';

import 'package:ctpat/src/providers/user_info.dart';
import 'package:ctpat/src/screens/homepage/home_page.dart';
import 'package:ctpat/src/themes/theme.dart';
import 'package:ctpat/src/utils/alert_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers form
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  // Shared Preferencess
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  // Login API Call section
  signIn(String email, String password, userInfo) async {
    //final SharedPreferences prefs = await _prefs;
    final _box = GetStorage();
    String url = "http://ctpat.syncronik.com/api/v1/auth/login/";
    Map body = {"email": email, "password": password};
    var jsonResponse;
    var res = await http.post(
      url,
      body: body,
      headers: {
        //'Authorization': "Token ${token}",
        'Authorization': 'Api-Key TzMKJVoE.1bcN3fRTRZnDSO4IlJ6gvblHl2J7KBf5',
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");

      if (jsonResponse != Null) {
        setState(() {
          _isLoading = false;
        });

        _box.write("user_id", jsonResponse['id']);
        _box.write("email", jsonResponse['email']);
        _box.write("token", jsonResponse['token']);

        userInfo.uid = jsonResponse['id'];
        userInfo.firstName = jsonResponse['first_name'];
        userInfo.lastName = jsonResponse['last_name'];
        userInfo.email = jsonResponse['email'];
        // userInfo.company = jsonResponse['company'];

        // String urlPhoto =
        //     "http://rotary.syncronik.com/api/v1/profile-pic/${userInfo.uid}";
        // var res_photo = await http.get(urlPhoto);
        // try {
        //   var jsonResponsePicture = json.decode(res_photo.body);
        //   userInfo.urlPicture = jsonResponsePicture['picture'];
        //   print("Picture User info: ${userInfo.urlPicture}");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
        // } catch (e) {
        //   Navigator.of(context).pushNamed('/wait');
        // }
      }
    } else if (res.statusCode == 401) {
      setState(() {
        _isLoading = false;
      });
      print("No existe el usuario");
      showAlertDialog("Error", "Email o contraseña incorrectos", context);
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final heightContainerTop = height / 2.8;
    final width = MediaQuery.of(context).size.width;
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: primaryClr,
                height: heightContainerTop,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/embraco-nidec-color.png')),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Control CTPAT',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[200],
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  color: Colors.grey[100],
                  width: MediaQuery.of(context).size.width,
                  height: height - heightContainerTop,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Bienvenido',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            color: Color(0xfff5f5f5),
                            child: TextFormField(
                              controller: _emailController,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.mail_outline),
                                labelStyle: GoogleFonts.poppins(fontSize: 17),
                              ),
                            ),
                          ),
                          Container(
                            color: Color(0xfff5f5f5),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  labelStyle:
                                      GoogleFonts.poppins(fontSize: 17)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: MaterialButton(
                              onPressed: () {
                                _emailController.text == "" ||
                                        _passwordController.text == ""
                                    ? showAlertDialog(
                                        "Error",
                                        "Todos los campos son requeridos",
                                        context)
                                    :
                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => HomePage()),
                                    //     ModalRoute.withName("/Home"));
                                    // // Call login service
                                    // signIn(_emailController.text,
                                    //     _passwordController.text, userInfo);
                                    print("Login");
                                signIn(_emailController.text,
                                    _passwordController.text, userInfo);
                              },
                              child: Text(
                                'Iniciar sesión',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              color: primaryClr,
                              elevation: 0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage())),
                                      text: "¿Olvidaste tu contraseña?",
                                      style: GoogleFonts.poppins(
                                        color: primaryClr,
                                        fontSize: 17,
                                      ))
                                ]),
                              ),
                            ),
                          ),
                        ]),
                  ))
            ]),
      ),
    );
  }
}
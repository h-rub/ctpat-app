import 'dart:convert';

import 'package:ctpat/src/providers/user_info.dart';
import 'package:ctpat/src/screens/homepage/home_page.dart';
import 'package:ctpat/src/themes/theme.dart';
import 'package:ctpat/src/tokens/colors.dart';
import 'package:ctpat/src/tokens/typography.dart';
import 'package:ctpat/src/utils/alert_dialog.dart';
import 'package:ctpat/src/widgets/input_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

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
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'apikey': 'cFmS80yo.noGef99U2EGqhARloqbE1qEhDFKVLIih'
    };
    //final SharedPreferences prefs = await _prefs;
    final _box = GetStorage();
    String url = "https://api.embraco.com/ctpat/forms/auth/login/";
    Map body = {"email": email, "password": password};
    EasyLoading.show(status: "Cargando...");
    var jsonResponse;
    var res = await http.post(url, body: body, headers: requestHeaders
        // headers: {
        //   //'Authorization': "Token ${token}",
        //   'Authorization': 'Api-Key TzMKJVoE.1bcN3fRTRZnDSO4IlJ6gvblHl2J7KBf5',
        //   'Content-Type': 'application/json; charset=utf-8'
        // },
        );

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");
      EasyLoading.showSuccess("Bienvenido");

      EasyLoading.dismiss();

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
      EasyLoading.showError("Ups! Ocurrió un error...",
          duration: const Duration(milliseconds: 3000));
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
                        'T-Compliance NGApp',
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
                          Text(
                            'Bienvenido',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Input(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHint: [AutofillHints.email],
                              label: "Correo electrónico / Usuario",
                              hintText: "Correo electrónico / Usuario",
                              prefixIcon: Icon(Icons.person_sharp),
                              autoFocus: true,
                              validator: (value) => !isEmail(value)
                                  ? "Ingrese un email valido"
                                  : null),
                          SizedBox(height: 10),
                          PasswordField(
                              label: "Contraseña",
                              hintText: "Escriba su contraseña",
                              controller: _passwordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Este campo es requerido";
                                }
                              }),
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
                                style: subHeading2White,
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
                          // Padding(
                          //   padding: EdgeInsets.only(top: 25),
                          //   child: Center(
                          //     child: RichText(
                          //       text: TextSpan(children: [
                          //         TextSpan(
                          //             recognizer: TapGestureRecognizer()
                          //               ..onTap = () =>
                          //                   Navigator.pushReplacement(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               HomePage())),
                          //             text: "¿Olvidaste tu contraseña?",
                          //             style: bodyLink)
                          //       ]),
                          //     ),
                          //   ),
                          // ),
                        ]),
                  ))
            ]),
      ),
    );
  }
}

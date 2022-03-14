import 'package:ctpat/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showAlertDialog(String title, String message, context) {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              color: primaryClr,
              child: Text(
                "Cerrar",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

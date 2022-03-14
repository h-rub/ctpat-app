import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ctpat/src/themes/theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 320,
                  child: TextField(
                    autocorrect: false,
                    style: GoogleFonts.poppins(color: Colors.white),
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.search, color: primaryClr),
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.black),
                        hintText: "Buscar reporte..."),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.filter_alt, color: primaryClr),
                    onPressed: () {
                      print("Filtrando");
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

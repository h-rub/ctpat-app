import 'package:flutter/material.dart';

class ShippingInfo with ChangeNotifier {
  int id;
  String factura;

  int get getId => this.id;
  set setId(int id) => this.id = id;

  String get getFactura => this.factura;
  set setFactura(String factura) => this.factura = factura;
}

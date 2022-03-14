import 'package:ctpat/src/providers/navegacion_info.dart';
import 'package:ctpat/src/providers/user_info.dart';
import 'package:ctpat/src/screens/details/shipping_details.dart';
import 'package:ctpat/src/screens/login/login_page.dart';
import 'package:flutter/material.dart';

// Screens
import 'package:ctpat/src/screens/homepage/home_page.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

// Plugins
import 'package:provider/provider.dart';

import 'src/providers/shipping_info.dart';
import 'src/services/theme_service.dart';
import 'src/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _box = GetStorage();
    final token = _box.read("token");
    print(token);
    return MultiProvider(
      providers: [
        //TODO: Add providers (users)
        ChangeNotifierProvider(create: (context) => UserInfo()),
        ChangeNotifierProvider(create: (context) => NavegacionInfo()),
        ChangeNotifierProvider(create: (context) => ShippingInfo()),
      ],
      child: GetMaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/shipping-details': (context) => ShippingDetails()
        },
      ),
    );
  }
}

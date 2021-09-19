import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/login_screen.dart';
import 'package:booking_app_client/screens/splash_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthProvider()),
      ChangeNotifierProxyProvider<AuthProvider, MainProvider>(
          create: (context) => MainProvider(),
          update: (context, value, previous) =>
              previous!..getReservedDevicesByUserId(value.employeeModel!.id)),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) => Consumer<AuthProvider>(
        builder: (context, valueAuth, child) => MaterialApp(
          title: 'Booking App Employee',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                titleSpacing: 0,
              )),
              
          home: snapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : valueAuth.isAuth
                  ? HomeScreen()
                  : FutureBuilder(
                      future: valueAuth.tryAutoLogIn(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : LoginScreen(),
                    ),
        ),
      ),
    );
  }
}

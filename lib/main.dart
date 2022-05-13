import 'package:booking_app_client/firebase_options.dart';
import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/login_screen.dart';
import 'package:booking_app_client/screens/splash_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:booking_app_client/util/langs/translate_controller.dart';
import 'package:booking_app_client/util/langs/translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthProvider()),
      ChangeNotifierProxyProvider<AuthProvider, MainProvider>(
          create: (context) => MainProvider(),
          update: (context, value, previous) =>
              previous!..getReservedDevicesByUserId(value.employeeModel!.id)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) => Consumer<AuthProvider>(
        builder: (context, valueAuth, child) => GetMaterialApp(
          //initialBinding: AppBindings(),
          translations: Translation(),
          locale: Translation.local,
          fallbackLocale: Translation.fallbackLocal,
          title: 'Booking App Employee',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              titleSpacing: 0,
              centerTitle: true,
            ),
          ),
          textDirection: Get.put(TranslateController()).selectedLang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          home: snapshot.connectionState == ConnectionState.waiting
              ? const SplashScreen()
              : valueAuth.isAuth
                  ? HomeScreen()
                  : FutureBuilder(
                      future: valueAuth.tryAutoLogIn(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : LoginScreen(),
                    ),
        ),
      ),
    );
  }
}

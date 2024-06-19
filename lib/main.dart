import 'package:chatify_app/pages/home_page.dart';
import 'package:chatify_app/pages/login_page.dart';
import 'package:chatify_app/pages/register_page.dart';
import 'package:chatify_app/pages/splash_page.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(const MainApp());
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => AuthenticationProvider(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
            // backgroundColor:const Color.fromRGBO(36, 35, 49, 1.0),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
            )),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => const RegisterPage(),
          '/home': (BuildContext context) => const HomePage(),


        },
      ),
    );
  }
}

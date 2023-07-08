import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
   final mySystemTheme= SystemUiOverlayStyle.light.copyWith(
       systemNavigationBarColor:const Color(0xff1F1D36),
       statusBarColor:const Color(0xff1F1D36));
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade700),
        useMaterial3: true,
        fontFamily: 'Nunito_Regular',
      ),
      home: const HomePage(),
    );
  }
}

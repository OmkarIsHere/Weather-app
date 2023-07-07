
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade700),
        useMaterial3: true,
        fontFamily: 'Nunito_Regular',
      ),
      // appBar: AppBar( systemOverlayStyle: SystemUiOverlayStyle(
      //   systemNavigationBarColor: Colors.blue, // Navigation bar
      //   statusBarColor: Colors.pink, // Status bar
      // ),),
      home: const HomePage(),
    );
  }
}

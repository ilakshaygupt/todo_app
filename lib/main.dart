import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/home_page.dart';
import 'package:get/get.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 60, 59, 47));
// for checking
var kDarkColorTheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: Color.fromARGB(255, 253, 255, 255));

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('todo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return (GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black54))),
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(),
          cardTheme: const CardTheme().copyWith(
            color: Colors.black26,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black26,
                foregroundColor: Colors.black26),
          ),
          inputDecorationTheme:
              const InputDecorationTheme(fillColor: Colors.black26),
          checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(Colors.white)),
          appBarTheme: const AppBarTheme()
              .copyWith(backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18))),
      theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Colors.yellow,
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 244, 227, 81)))),
          useMaterial3: true,
          colorScheme: const ColorScheme.light(),
          appBarTheme:
              const AppBarTheme().copyWith(backgroundColor: Colors.yellow),
          cardTheme: const CardTheme().copyWith(
            color: Colors.yellow,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(Colors.black)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
          ),
          inputDecorationTheme:
              const InputDecorationTheme(fillColor: Colors.yellow),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18))),
      home: const HomePage(),
    ));
  }
}

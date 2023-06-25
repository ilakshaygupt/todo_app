import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/home_page.dart';
import 'package:get/get.dart';

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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00)),
        cardTheme: const CardTheme().copyWith(
          color: ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
              .secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:
              ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
                  .primaryContainer,
          foregroundColor:
              ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
                  .onPrimaryContainer,
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00)),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor:
              ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
                  .onPrimaryContainer,
          foregroundColor:
              ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
                  .primaryContainer,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                ColorScheme.fromSeed(seedColor: const Color(0xFFFFBF00))
                    .primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorScheme.fromSeed(
                        seedColor: const Color.fromARGB(255, 4, 4, 4))
                    .onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      home: const HomePage(),
    ));
  }
}

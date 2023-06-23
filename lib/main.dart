import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/home_page.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('todo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E1E1E)),
        cardTheme: const CardTheme().copyWith(
          color: ColorScheme.fromSeed(seedColor: const Color(0xFF1E1E1E))
              .secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1E1E1E))
                    .primaryContainer,
            foregroundColor:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1E1E1E))
                    .onPrimaryContainer,
          ),
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
                ColorScheme.fromSeed(seedColor: const Color(0xFFE0E0E0))
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
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

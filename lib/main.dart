import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 147, 229, 250),
        brightness: Brightness.dark,
        surface: const Color.fromARGB(255, 42, 51, 59)),
    scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
    textTheme: GoogleFonts.nunitoTextTheme());

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        home: const GroceryList());
  }
}

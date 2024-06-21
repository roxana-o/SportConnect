// TODO Implement this library.


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Themes extends ChangeNotifier{
  bool _dark = false;
  bool get dark => _dark;

  late SharedPreferences preferences;

  final darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.orange, // Primary color (mainly orange)
    //primaryVariant: Colors.orange.shade700, // Darker variant of primary
    secondary: Colors.teal, // Secondary color (teal)
    //secondaryVariant: Colors.teal.shade700, // Darker variant of secondary
    background: const Color.fromARGB(176, 33, 33, 33), // Background color (dark grey)
    surface: const Color.fromARGB(61, 66, 66, 66), // Surface color (darker grey)
    onPrimary: Colors.white, // Text color on primary color (white)
    onSecondary: Colors.white, // Text color on secondary color (white)
    onBackground: Colors.white70, // Text color on background (light grey)
    onError: Colors.white, // Text color on error (white)
  )
  );

  final lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.orange, // Main primary color (orange)
    //primaryVariant: Colors.orange.shade700, // Darker variant of primary
    secondary: Colors.teal, // Secondary color (teal)
    //secondaryVariant: Colors.teal.shade700, // Darker variant of secondary
    background: Colors.white, // Background color (white)
    surface: const Color.fromARGB(220, 238, 238, 238), // Surface color (light grey)
    onPrimary: Colors.black, // Text color on primary color (black)
    onSecondary: Colors.black, // Text color on secondary color (black)
    onBackground: Colors.black87, // Text color on background (dark grey)
    onError: Colors.white, // Text color on error (white)
  ).copyWith(
    // Additional colorful modifications
    error: Colors.red, // Error color (red)
    onSurface: Colors.purple, // Text color on surface (purple)
    onPrimary: Colors.white, // Text color on primary color (white)
    onSecondary: Colors.white, // Text color on secondary color (white)
  ),
);

changeTheme(){
  _dark = !dark;

  preferences.setBool('darkMode', _dark);
  notifyListeners();
}

init() async{
  preferences = await SharedPreferences.getInstance();
  _dark = preferences.getBool('darkMode')??false;
  notifyListeners();
}
}
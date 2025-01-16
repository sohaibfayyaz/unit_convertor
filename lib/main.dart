import 'package:application_3/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(UnitConverterApp());

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only numbers and one decimal point
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^\d*\.?\d*$');
    if (regex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue; // Discard invalid input
  }
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      // Default light theme
      darkTheme: ThemeData.dark(),
      // Dark theme
      themeMode: ThemeMode.system,
      // Use system theme mode
      home: SplashScreen(),
    );
  }
}


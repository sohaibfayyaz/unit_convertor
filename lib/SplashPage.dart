import 'package:application_3/main.dart';
import 'package:application_3/unit_converter_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UnitConverterScreen()));
    });

    return Scaffold(
      backgroundColor: Colors.blue, // Choose your splash background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your logo here
            Image.asset('assets/images/unit_converter1.jpg'), // Ensure you have the image in your assets
            SizedBox(height: 20),
            Text(
              'Unit Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}

import 'package:application_3/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:units_converter/units_converter.dart';

import 'debouncer.dart';
import 'decimal_text_input_formatter.dart';

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  double _inputValue = 0.0;
  String _fromUnit = 'Millimeters (mm)';
  String _toUnit = 'Centimeters (cm)';
  String _result = '0.00';
  ThemeMode _themeMode = ThemeMode.system;
  List<String> _conversionHistory = [];

  void _convert() {
    if (_inputValue == 0.0) {
      setState(() {
        _result = '0.00';
      });
      return;
    }

    double? convertedValue =
        _inputValue.convertFromTo(lengthMap[_fromUnit], lengthMap[_toUnit]);

    setState(() {
      _result =
          convertedValue!.toString().replaceAll(RegExp(r'\.?0+$'), '').length >
                  7
              ? convertedValue.toStringAsFixed(5)
              : convertedValue.toString().replaceAll(RegExp(r'\.?0+$'), '');
      _conversionHistory.add('$_inputValue $_fromUnit = $_result $_toUnit');
    });
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Conversion History'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _conversionHistory.isEmpty
                  ? [Text('No conversion history available.')]
                  : _conversionHistory.map((entry) => Text(entry)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Unit Converter'),
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () => _showHistoryDialog(),
            ),
            IconButton(
              icon: Icon(_themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _themeMode = _themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'Input Value', border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter()],
                onChanged: (value) {
                  _inputValue =
                      value.isNotEmpty ? double.tryParse(value) ?? 0.0 : 0.0;
                  _debouncer.run(() {
                    _convert();
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _fromUnit,
                onChanged: (newValue) {
                  setState(() {
                    _fromUnit = newValue!;
                  });
                  _convert();
                },
                items:
                    lengthMap.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _toUnit,
                onChanged: (newValue) {
                  setState(() {
                    _toUnit = newValue!;
                  });
                  _convert();
                },
                items:
                    lengthMap.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '$_result $_toUnit'));
                },
                child: Text('Copy Result', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              Text(
                'Result: $_result $_toUnit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

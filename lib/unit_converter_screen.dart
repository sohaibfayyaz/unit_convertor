import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'decimal_text_input_formatter.dart';
import 'debouncer.dart';

class LENGTH {
  final double factor;

  LENGTH(this.factor);

  // Factory constructor for custom units
  factory LENGTH.custom(double customFactor) {
    return LENGTH(customFactor);
  }
}

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

  Map<String, LENGTH> lengthMap = {
    'Millimeters (mm)': LENGTH(0.001),
    'Centimeters (cm)': LENGTH(0.01),
    'Meters (m)': LENGTH(1.0),
    'Kilometers (km)': LENGTH(1000.0),
    // Add more predefined units as needed
  };

  void _convert() {
    if (_inputValue == 0.0) {
      setState(() {
        _result = '0.00';
      });
      return;
    }

    double fromFactor = lengthMap[_fromUnit]?.factor ?? 1.0;
    double toFactor = lengthMap[_toUnit]?.factor ?? 1.0;

    double convertedValue = (_inputValue * fromFactor) / toFactor;

    setState(() {
      _result = convertedValue.toStringAsFixed(2);
      _conversionHistory.add('$_inputValue $_fromUnit = $_result $_toUnit');
    });
  }

  void _showCustomUnitDialog() {
    String customUnitName = '';
    double customUnitFactor = 1.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Custom Unit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Unit Name'),
                  onChanged: (value) {
                    customUnitName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Conversion Factor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [DecimalTextInputFormatter()],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      customUnitFactor = double.tryParse(value) ?? 1.0;
                    } else {
                      customUnitFactor = 1.0; // Reset to default if empty
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (customUnitName.isNotEmpty) {
                  setState(() {
                    lengthMap[customUnitName] = LENGTH.custom(customUnitFactor);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unit name cannot be empty')),
                  );
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
              icon: Icon(Icons.add),
              onPressed: () => _showCustomUnitDialog(),
            ),
            IconButton(
              icon: Icon(_themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
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
                decoration: InputDecoration(labelText: 'Input Value', border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter()],
                onChanged: (value) {
                  _inputValue = value.isNotEmpty ? double.tryParse(value) ?? 0.0 : 0.0;
                  _convert();
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
                items: lengthMap.keys.map<DropdownMenuItem<String>>((String key) {
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
                items: lengthMap.keys.map<DropdownMenuItem<String>>((String key) {
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

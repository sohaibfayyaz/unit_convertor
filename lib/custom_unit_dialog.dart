import 'package:flutter/material.dart';

void showCustomUnitDialog(BuildContext context, Function(String, double) onAdd) {
  String customUnitName = '';
  double customUnitFactor = 1.0;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Custom Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Unit Name'),
              onChanged: (value) => customUnitName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Conversion Factor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                customUnitFactor = double.tryParse(value) ?? 1.0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              onAdd(customUnitName, customUnitFactor);
              Navigator.of(context).pop();
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

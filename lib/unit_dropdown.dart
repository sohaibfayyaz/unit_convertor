import 'package:flutter/material.dart';

class UnitDropdown extends StatelessWidget {
  final String label;
  final String value;
  final Function(String?) onChanged;

  UnitDropdown({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      isExpanded: true,
      onChanged: onChanged,
      items: ['Unit 1', 'Unit 2'] // Replace with your units list
          .map<DropdownMenuItem<String>>((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
    );
  }
}

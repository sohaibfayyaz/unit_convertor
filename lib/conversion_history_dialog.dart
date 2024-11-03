import 'package:flutter/material.dart';

void showHistoryDialog(BuildContext context, List<String> history) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Conversion History'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(history[index]),
              );
            },
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

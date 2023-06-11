import 'package:flutter/material.dart';

import '../models/graph.dart';

class EmailPopup extends StatelessWidget {
  final String emailText;
  final List<ChartData> chartData;

  EmailPopup({required this.emailText, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Email Content'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(emailText),
            Text("Following are the explainable outputs"),
            ...chartData.map((e) => Column(children: [
              Text(e.x + ": " + e.y.toString()),
              SizedBox(height: 10,),
            ],)).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
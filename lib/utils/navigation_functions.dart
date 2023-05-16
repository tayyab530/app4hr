import 'package:app4hr/screens/dashboard.dart';
import 'package:flutter/material.dart';

gotoDashboard(BuildContext context){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute (
      builder: (BuildContext context) => const Dashboard(),
    ),
  );
}
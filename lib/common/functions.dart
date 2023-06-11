import 'package:flutter/material.dart';

Color getChipColor(String status) {
  return status == "pending"
      ? Colors.blue
      : status == "rejected"
      ? Colors.red
      : Colors.green;
}
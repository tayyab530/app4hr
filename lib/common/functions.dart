import 'package:flutter/material.dart';

Color getChipColor(String status) {
  return status == "pending"
      ? Colors.blue
      : status == "rejected"
          ? Colors.red
          : Colors.green;
}

String getDecisionStatus(String status, bool value) {
  if (status != "pending") {
    if (value) {
      return "accepted";
    } else {
      return "rejected";
    }
  } else {
    return "pending";
  }
}

String getDecisionStatusForAI(bool value) {
  if (value) {
    return "accepted";
  } else {
    return "rejected";
  }
}

bool showGraphButtons(String status) {
  if (status != "pending") {
    return false;
  }
  return true;
}

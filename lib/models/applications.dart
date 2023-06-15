import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Application {
  final String id;
  final String candidateId;
  final String positionId;
  final String status;
  final bool aiDecision;
  final bool hrDecision;
  final DateTime date;
  final String email;
  final Map<String, dynamic> explanation;
  final String downloadableResumeLink;

  Application({
    required this.id,
    required this.candidateId,
    required this.positionId,
    required this.status,
    required this.date,
    required this.aiDecision,
    required this.hrDecision,
    required this.email,
    required this.explanation,
    required this.downloadableResumeLink,
  });

  factory Application.fromQuerySnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Application(
      id: doc.id,
      candidateId: data['candidateId'],
      positionId: data['positionId'],
      status: data['status'],
      date: (data['appliedAt'] as Timestamp).toDate(),
      aiDecision: data['aiDecision'],
      hrDecision: data['hrDecision'],
      email: data["email_content"],
      explanation: Map<String,double>.from(data["explanation"],),
      downloadableResumeLink: data["downloadableResumeLink"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'candidateId': candidateId,
      'positionId': positionId,
      'status': status,
      "appliedAt": Timestamp.fromDate(date),
      "aiDecision": aiDecision,
      "hrDecision": hrDecision,
      "email_content": email,
      "explanation": explanation,
      "downloadableResumeLink": downloadableResumeLink,
    };
  }

// Timestamp _getTimeStamp() => ;
}

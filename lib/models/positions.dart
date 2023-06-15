import 'package:cloud_firestore/cloud_firestore.dart';

class PositionData {
  final String id;
  final String title;
  final String shortDescription;
  final String description;

  PositionData({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
  });

  factory PositionData.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return PositionData(
      id: snapshot.id,
      title: data['title'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  final String id;
  final String title;
  final String shortDescription;
  final String description;

  Position({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
  });

  factory Position.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Position(
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
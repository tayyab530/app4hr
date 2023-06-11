class Candidate {
  final String id;
  final String name;
  final String email;

  Candidate({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
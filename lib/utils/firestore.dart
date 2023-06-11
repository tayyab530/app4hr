import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/applications.dart';
import '../models/candidate.dart';
import '../models/positions.dart';

class FirestoreService {
  final CollectionReference candidatesCollection =
      FirebaseFirestore.instance.collection('candidates');
  final CollectionReference applicationsCollection =
      FirebaseFirestore.instance.collection('applications');
  final CollectionReference positionsCollection =
      FirebaseFirestore.instance.collection('positions');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addCandidate(Candidate candidate) async {
    try {
      await candidatesCollection.doc().set(candidate.toMap());
    } catch (e) {
      print('Error adding candidate: $e');
    }
  }

  Future<void> addApplication(Application application) async {
    try {
      await applicationsCollection.doc().set(application.toMap());
    } catch (e) {
      print('Error adding application: $e');
    }
  }

  Future<void> addPosition(Position position) async {
    try {
      await positionsCollection.doc().set(position.toMap());
    } catch (e) {
      print('Error adding position: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      await userCollection.doc(user.uid).set({
        "isAdmin": false,
        "email": user.email,
      });
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserById(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        return null; // User not found
      }
    } catch (error) {
      print('Error retrieving user: $error');
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getAllUsers() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .get();

    return querySnapshot.docs;
  }

  Future<List<Application>> getApplicationsByCandidateId(
      String candidateId) async {
    try {
      QuerySnapshot snapshot = await applicationsCollection
          .where('candidateId', isEqualTo: candidateId)
          .get();

      List<Application> applications = [];

      for (var doc in snapshot.docs) {
        Application application = Application.fromQuerySnapshot(doc);
        applications.add(application);
      }

      return applications;
    } catch (e) {
      print('Error retrieving applications: $e');
      return [];
    }
  }

  Future<List<Application>> getApplicationsByPositionIds(List<String> positionIds) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('positionId', whereIn: positionIds)
        .get();
    return querySnapshot.docs.map((app) => Application.fromQuerySnapshot(app)).toList();
  }

  Future<List<Application>> getAllApplications() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('applications')
        .get();
    return querySnapshot.docs.map((app) => Application.fromQuerySnapshot(app)).toList();
  }

  Future<List<Position>> getAllPositions() async {
    try {
      QuerySnapshot snapshot = await positionsCollection.get();

      List<Position> positions = [];
      for (var doc in snapshot.docs) {
        Position position = Position(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          shortDescription: doc["shortDescription"],
        );
        positions.add(position);
      }

      return positions;
    } catch (e) {
      print('Error retrieving positions: $e');
      return [];
    }
  }



  Future<void> addDemoPositions() async {
    // Adding positions
    Position position1 = Position(
      id: 'positionId1',
      title: 'Software Engineer',
      shortDescription:
          'Develop software applications using various technologies.',
      description:
          'Responsible for designing, developing, testing, and maintaining software applications using programming languages and frameworks. Collaborate with cross-functional teams to analyze requirements and deliver high-quality software solutions.',
    );
    addPosition(position1);

    Position position2 = Position(
      id: 'positionId2',
      title: 'Data Scientist',
      shortDescription:
          'Analyze data and extract insights for informed decision-making.',
      description:
          'Responsible for collecting, cleaning, and analyzing large datasets to identify patterns, trends, and insights. Develop statistical models and algorithms to solve complex business problems. Communicate findings to stakeholders and contribute to data-driven decision-making processes.',
    );
    addPosition(position2);

    Position position3 = Position(
      id: 'positionId3',
      title: 'Product Manager',
      shortDescription:
          'Manage product development lifecycle and drive business success.',
      description:
          'Responsible for defining product vision, strategy, and roadmap. Collaborate with cross-functional teams to gather requirements, prioritize features, and ensure timely delivery. Conduct market research, analyze user feedback, and identify growth opportunities. Drive product success by aligning business goals with customer needs.',
    );
    addPosition(position3);
  }


  Future<String?> getCandidateName(String candidateId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(candidateId)
          .get();
      if (snapshot.exists) {
        // Access the candidate name field
        String candidateName = snapshot['name'];
        return candidateName;
      }
      return null;
    } catch (e) {
      // Handle any errors that occur
      print('Error: $e');
      return null;
    }
  }


}

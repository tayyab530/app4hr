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
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  Future<void> updateApplication(Application application) async {
    try {
      await applicationsCollection
          .doc(application.id)
          .update(application.toMap());
    } catch (e) {
      print('Error updating application: $e');
    }
  }

  Future<void> addPosition(PositionData position) async {
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserById(
      String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
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

  Future<List<Application>> getApplicationsByPositionIds(
      List<String> positionIds) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('positionId', whereIn: positionIds)
        .get();
    return querySnapshot.docs
        .map((app) => Application.fromQuerySnapshot(app))
        .toList();
  }

  Future<List<Application>> getAllApplications() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('applications').get();
    return querySnapshot.docs
        .map((app) => Application.fromQuerySnapshot(app))
        .toList();
  }

  Future<List<PositionData>> getAllPositions() async {
    try {
      QuerySnapshot snapshot = await positionsCollection.get();

      List<PositionData> positions = [];
      for (var doc in snapshot.docs) {
        PositionData position = PositionData(
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
    PositionData position1 = PositionData(
      id: 'positionId1',
      title: 'Accountant',
      shortDescription: 'Accounts manager.',
      description:
          '''Summary: We are seeking a detail-oriented Staff Accountant to join our team. The Staff Accountant will be responsible for a range of accounting activities, including general ledger reconciliations, account analysis, financial reporting, and assisting with audits.

Key Responsibilities: • Prepare and maintain accounting records and general ledger reconciliations • Assist in month-end close activities, including preparation of journal entries and account reconciliations • Prepare and analyze financial statements to ensure accuracy and compliance with GAAP • Assist with audits and provide support for external auditors • Perform ad-hoc analysis and reporting as required by management • Collaborate with other departments to ensure timely and accurate financial reporting • Ensure compliance with internal accounting policies and procedures • Participate in process improvement initiatives to increase efficiency and effectiveness of accounting operations • Assist in the preparation and filing of various tax returns

Qualifications: • Bachelor's degree in accounting, finance, or related field • Minimum of 2-3 years of accounting experience • Knowledge of GAAP and financial reporting • Strong analytical and problem-solving skills • Excellent attention to detail and accuracy • Proficient in Microsoft Excel and other accounting software • Ability to work independently and prioritize multiple tasks • Excellent written and verbal communication skills • Ability to maintain confidentiality and exercise discretion

Salary • Competitive salary based on experience and qualifications •

If you meet the qualifications and are interested in this opportunity, please submit your resume and cover letter for consideration. We are an equal opportunity employer and welcome candidates from diverse backgrounds.

Note: Fluency in English is required

This is an Remote based 3rd shift night job and the timing of this job is from 5:00 pm till 2:00 am (Mon to Fri).

Night Shift (Required)

Bachelor's (Preferred)

International Accounting and Bookkeeping: 2 to 3 years (Preferred)

Proficient English - Verbal - Written (Preferred)

Job Type: Full-time

Pay: Rs75,000.00 - Rs100,000.00 per month

''',
    );
    addPosition(position1);

    PositionData position2 = PositionData(
      id: 'positionId2',
      title: 'Android Developer',
      shortDescription:
          'Develop and Deploy applications.',
      description:
          '''[9:41 PM, 6/13/2023] Moiz Farooq BHU: Reporting to: Chief Technology Officer

Location: Karachi, Pakistan

Employment Type: Full Time

Job Summary

We are seeking an experienced Technical Product Manager with a strong development background to join our dynamic team. As a Technical Product Manager, you will be responsible for driving the development and execution of our technical product roadmap. You will work closely with cross-functional teams, including engineering, design, and marketing, to define product requirements and ensure the successful delivery of innovative solutions. The ideal candidate has a solid technical foundation, excellent project management skills, and a passion for building cutting-edge products.

Responsibilities
• Collaborate with stakeholders to define the strategic vision and roadmap for technical product development.
• Conduct market research and competitive analysis to identify user needs and market trends.
• Define product requirements, including feature prioritization, user stories, and acceptance criteria.
• Work closely with engineering teams to ensure the successful implementation of product features and functionality.
• Leverage your development experience to provide technical guidance and support to internal teams and external stakeholders.
• Collaborate with design teams to create intuitive and user-friendly interfaces.
• Conduct user testing and gather feedback to iterate and improve the product.
• Drive product launches, including coordinating with marketing, sales, and customer support teams.
• Monitor and analyze product performance metrics, identify areas for improvement, and make data-driven recommendations.
• Stay up to date with industry trends and emerging technologies to drive innovation and maintain a competitive edge.
• Provide regular updates on product plans, progress, and outcomes to senior management and key stakeholders.

Requirements
• Bachelor's degree in computer science, Engineering, or a related technical field. A Master's degree is a plus.
• Proven experience as a Technical Product Manager or similar role, with a strong background in software development.
• Hands-on development experience with expertise in programming languages, frameworks, and technologies.
• Excellent project management skills with the ability to prioritize tasks, meet deadlines, and manage competing priorities effectively.
• Solid analytical and problem-solving abilities with a keen attention to detail.
• Strong interpersonal and communication skills with the ability to collaborate effectively with cross-functional teams and stakeholders at all levels.
• Experience with Agile development methodologies, such as Scrum or Kanban.
• Familiarity with product management tools, such as JIRA, Confluence, or similar.
• Demonstrated ability to thrive in a fast-paced, dynamic environment and adapt to changing business needs.
• Passion for technology and a drive to stay updated with industry trends and emerging technologies.

We offer competitive compensation packages and a stimulating work environment that fosters innovation and growth. If you are passionate about driving the development of cutting-edge products, have a track record of success in technical product management, and possess hands-on development experience, we would love to hear from you
[9:43 PM, 6/13/2023] Moiz Farooq BHU: The ideal candidate will be responsible for designing, developing, testing, and debugging responsive web applications for the company. Using JavaScript, HTML, and CSS, WordPress will be the plus point, this candidate will be able to translate user and business needs into functional front-end design.

Responsibilities
• Designing, developing, and testing UI for mobile and web applications
• Build reusable code and libraries for future use
• Accurately translate user and business needs into functional frontend code
• Develop WordPress websites
• Cross-Browser Compatibility: Ensuring that the website or application functions consistently across different browsers and platforms, addressing any compatibility issues that may arise.
• Optimization and Performance: Optimizing frontend code and assets for improved performance, including minimizing file sizes, reducing load times, and implementing caching techniques.
• Continuous Learning: Staying updated with the latest frontend technologies tools, and best practices, and applying them to enhance development processes and deliver high-quality results.

Requirements
• Bachelor's degree or equivalent in Computer Science
• 1-year experience in frontend development
• Experience building/designing web applications in JavaScript, HTML, and CSS
• Should have good knowledge of WordPress''',
    );
    addPosition(position2);

    PositionData position3 = PositionData(
      id: 'positionId3',
      title: 'Product Manager',
      shortDescription:
          'Manage product development lifecycle and drive business success.',
      description:
          '''Job Title: Digital Marketing Specialist (Full-Time, Morning Shift)

Company Overview: We are UK based company in the I.T industry starting operations in khi, dedicated to delivering exceptional services of E-books and design services to our customers. As part of our growth strategy, we are seeking a talented and experienced Digital Marketing Specialist to join our dynamic team. This is a full-time position with a morning shift, offering an excellent opportunity for career development and growth.

Job Summary: As a Digital Marketing Specialist, you will play a pivotal role in driving our online marketing efforts and implementing effective strategies to enhance our digital presence. You will collaborate closely with the marketing team to develop and execute digital marketing campaigns, optimize our online platforms, and measure the success of our initiatives. This role requires a strong blend of technical expertise, analytical skills, creativity, and a passion for staying up-to-date with the latest digital marketing trends.

Responsibilities:
• Plan, execute, and optimize digital marketing campaigns across various channels, such as social media, search engines, email, and display advertising.
• Conduct market research to identify target audiences and develop customer personas.
• Create compelling and engaging content for digital channels, including website, blog, social media, and email campaigns.
• Monitor and analyze website analytics, user behavior, and campaign performance to identify areas for improvement.
• Optimize SEO strategies to increase organic search rankings and drive targeted traffic to the website.
• Manage social media accounts and develop engaging content to build brand awareness and engage with our audience.
• Collaborate with cross-functional teams to develop and implement digital marketing strategies aligned with business goals.
• Stay up-to-date with industry trends, emerging technologies, and best practices in digital marketing.
• Track and report on key performance metrics, providing insights and recommendations for continuous improvement.

Qualifications:
• Bachelor's degree in Marketing, Communications, or a related field.
• Proven work experience as a Digital Marketing Specialist or similar role.
• In-depth knowledge of digital marketing tactics, including SEO, SEM, social media marketing, email marketing, and content marketing.
• Proficient in using digital marketing tools and platforms, such as Google Analytics, Google AdWords, social media management tools, and marketing automation software.
• Strong analytical skills with the ability to interpret data, generate insights, and make data-driven decisions.
• Excellent written and verbal communication skills.
• Creativity and ability to think outside the box to develop innovative digital marketing strategies.
• Strong project management skills and the ability to multitask and meet deadlines.

Benefits:
• Competitive salary package commensurate with experience and skills.
• Comprehensive health insurance coverage.
• Opportunities for professional development and career growth.
• Collaborative and inclusive work environment.
• Work-life balance with a morning shift schedule.

How to Apply: If you are a motivated and results-driven Digital Marketing Specialist looking for a challenging opportunity to contribute to our company's success, we would love to hear from you. Please submit your resume, along with a cover letter highlighting your relevant experience and achievements, to careers.inovantage@gmail.com. We thank all applicants for their interest, but only those selected for an interview will be contacted.

Job Type: Full-time

Salary: Rs60,000.00 - Rs100,000.00 per month

Ability to commute/relocate:
• Karachi: Reliably commute or planning to relocate before starting work (Required)

Application Deadline: 15/06/2023''',
    );
    addPosition(position3);

    PositionData position4 = PositionData(
      id: 'positionId3',
      title: 'Computer Vision and Machine Learning Engineer',
      shortDescription:
      'Develop and debug algorithms.',
      description:
      '''Location: Onsite

We are seeking a talented and experienced Computer Vision and Machine Learning Expert to join our team. As a key member of our research and development division, you will play a crucial role in designing and implementing advanced algorithms for computer vision tasks and predictive modeling. Your expertise in algorithm design and model prediction will be essential in driving the development of our products.

Responsibilities

Develop and implement state-of-the-art computer vision algorithms for object detection, image classification, segmentation, and tracking.
Design and optimize machine learning models for predictive analysis and pattern recognition.
Collaborating with cross-functional teams, to integrate algorithms and models into our products.
Evaluate the performance of algorithms and models through rigorous testing and analysis.
Source and read relevant computer vision literature.
Research and stay up to date with the latest advancements in computer vision.
Implement appropriate ML algorithms and tools.
Develop machine learning applications according to requirements.
Select appropriate datasets and data representation methods.
Run machine learning tests and experiments.
Perform statistical analysis and fine-tuning using test results.
Train and retrain systems when necessary.
Proof-of-Concept code.
Designing and developing machine learning and deep learning systems.
Running machine learning tests and experiments.
Qualifications

Bachelor's or master's is a plus in Computer Science, Electrical Engineering, AI, Bio Medical Engineering or a related field.
Strong foundation in computer vision, machine learning, and deep learning techniques.
Proficiency in algorithm design, optimization, and implementation.
Experience with popular computer vision frameworks and libraries (e.g., OpenCV, TensorFlow, PyTorch).
Expertise in model prediction and predictive modeling techniques.
Strong programming concept of Python, ability to write robust code.
Familiarity with cloud-based machine learning platforms (e.g., AWS, Azure, Google Cloud) is a plus.
Strong analytical and problem-solving abilities.
Excellent communication and collaboration skills.
Job Type: Full-time

Salary: From Rs100,000.00 per month

Ability to commute/relocate:

Islamabad: Reliably commute or planning to relocate before starting work (Required)
Experience:

Relevant: 1 year (Preferred)''',
    );
    addPosition(position4);
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

  Future<bool?> checkIfUserIsAdmin(String uid) async {
    var user = await getUserById(uid);

    if (user != null && user.exists) {
      if (user.data()!["isAdmin"]) {
        return true;
      }
      return false;
    } else {
      return null;
    }
  }
}

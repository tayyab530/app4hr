import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:app4hr/models/applications.dart';
import 'package:app4hr/utils/authentication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../common/functions.dart';
import '../models/positions.dart';
import '../utils/firestore.dart';
import '../widgets/popups.dart';
import 'package:http/http.dart' as http;


class PositionsScreen extends StatefulWidget {
  const PositionsScreen({super.key});

  @override
  _PositionsScreenState createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  List<PositionData> _positions = []; // Positions list fetched from Firestore
  List<Application>? _applications;
  FirestoreService _fireStoreService = FirestoreService();
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchPositions();
    fetchApplications();
  }

  void fetchPositions() async {
    // Call the getAllPositions function from your FirestoreService
    _positions = await _fireStoreService.getAllPositions();
    setState(() {});
  }

  void fetchApplications() async {
    // Call the getAllPositions function from your FirestoreService
    _applications =
        await _fireStoreService.getApplicationsByCandidateId(user!.uid);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.only(left: 30.0, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Positions",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.32,
                // width: MediaQuery.of(context).size.width * 0.5,
                // padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15),
                child: _buildPositionsList()),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Applications",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              elevation: 3.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: const Text(
                  "Position Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                trailing: LayoutBuilder(
                  builder: (ctx, cons) {
                    return SizedBox(
                      width: cons.maxWidth * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Created at")
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.32,
                // width: MediaQuery.of(context).size.width * 0.5,
                // padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15),
                child: _buildApplicationsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionsList() {
    if (_positions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _positions.length,
        itemBuilder: (context, index) {
          PositionData position = _positions[index];
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () {},
              title: Text(
                position.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position.shortDescription,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  // const SizedBox(height: 8.0),
                  // Text(
                  //   position.description,
                  //   style: const TextStyle(fontSize: 14.0),
                  // ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _applyForPosition(context,position),
                child: const Text('Apply'),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildApplicationsList() {
    if (_applications == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _applications!.length,
        itemBuilder: (context, index) {
          Application application = _applications![index];
          PositionData position = _positions.firstWhere((p) => p.id == application.positionId);
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () {},
              title: Text(
                position.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              // subtitle: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       application.status,
              //       style: const TextStyle(fontSize: 16.0),
              //     ),
              //     // const SizedBox(height: 8.0),
              //     // Text(
              //     //   position.description,
              //     //   style: const TextStyle(fontSize: 14.0),
              //     // ),
              //   ],
              // ),
              trailing: LayoutBuilder(
                builder: (ctx, cons) {
                  return SizedBox(
                    width: cons.maxWidth * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          backgroundColor: getChipColor(application.status),
                          label: Text(
                            application.status,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(DateFormat.yMd().format(application.date))
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _applyForPosition(BuildContext context,PositionData positionData) async {

    Popups.showProgressPopup(context);
    // Show file picker to select resume file
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null && result.files.isNotEmpty) {
      // Get the selected resume file
      PlatformFile resumeFile = result.files.first;

      final pdfDocument = PdfDocument(inputBytes: resumeFile.bytes!);

      // Extract text from all pages
      // final pageCount = pdfDocument.pages.count;
      String extractedText = PdfTextExtractor(pdfDocument).extractText();

//Dispose the document.
      print(extractedText);
      pdfDocument.dispose();

      if (extractedText != null) {
        // var candidateName = FirestoreService().getCandidateName(ca)
        var requestBody = {
          "position": "${positionData.title} ${positionData.description}",
          "resume": extractedText,
          "candidate_name": "Candidate",
          "company_name": "Tayyab, HR at App4HR",
        };

        print(requestBody);

        var url = "api_url_here";
        http.Response? response = await http.post(Uri.parse(url), body: jsonEncode(requestBody),headers: {"Content-Type":"application/json"});
        // response = await Future.delayed(const Duration(seconds: 2),(){
        //   var dummyBody = getMockBody();
        //
        //   return response = http.Response(jsonEncode(dummyBody), 200);
        // });
        // var response = http.Response("Nothing", 200);

        print(response!.body);
        if(response!.statusCode == 200){
          try {
            var decodedBody = jsonDecode(response!.body);
            var email = decodedBody["email"];
            var explanation = decodedBody["explanations"];

            print(explanation);
            var htmlResumeFileBytes = resumeFile.bytes!;

            var resumeLink = await uploadResume(htmlResumeFileBytes, user!.uid);
            var application = Application(
              id: " ",
              candidateId: user!.uid,
              positionId: positionData.id,
              status: "pending",
              date: DateTime.now(),
              aiDecision: decodedBody["call_for_interview"] == 1 ? true : false,
              hrDecision: false,
              email: email,
              explanation: explanation,
              downloadableResumeLink: resumeLink,
            );
            await _fireStoreService.addApplication(application);
            refresh();
            Navigator.of(context).pop();
            Popups.showSuccessPopup(
                context, "Application is submitted. You will receive email.");
          } catch (e) {
            Navigator.of(context).pop();
            print(e.toString());
            Popups.showErrorPopup(
                context,
                "Failed to submit your application. Please try again.");
          }

        }
        else{
          Navigator.of(context).pop();
          Popups.showErrorPopup(
              context,
              "Failed to submit your application. Please try again.");
        }
        Navigator.of(context).pop();

        // if (response!.statusCode == 200) {
        //   // Successful submission
        //   // var body = jsonDecode(response!.body);
        //   // showDialog(
        //   //   context: context,
        //   //   builder: (BuildContext context) {
        //   //     var chartDataList = <ChartData>[];
        //   //     var charData = (body["explanation"] as Map<String,dynamic>).forEach((key, value) {
        //   //
        //   //       chartDataList.add(ChartData(key, value));
        //   //     });
        //   //     return ListView(
        //   //       children: [
        //   //         // BarChartSample1(chartData: chartDataList,),
        //   //
        //   //         EmailPopup(emailText: body["email"],chartData: chartDataList),
        //   //       ],
        //   //     );
        //   //     // return GraphWidget(data: data);
        //   //   },
        //   // );
        //
        //
        //
        // }
        // else {
        //   // Handle submission failure
        // }
      }
      else {
        // Handle PDF to text extraction failure
        Navigator.of(context).pop();
        Popups.showErrorPopup(
            context, "Failed to extract text from the PDF file.");
      }
    }
    else{
      Navigator.of(context).pop();
    }
  }

  refresh(){
    html.window.location.reload();
    // setState(() {
    // });
  }

  Map<String,dynamic> getMockBody(){
    return {
      "call_for_interview": 1,
      "explanation": {
        "years_of_experience": -0.8853568083020611,
        "functional_competency_score": 0.6573970613693698,
        "top1_skills_score": 0.7760398985713431,
        "top2_skills_score": 0.2913224859960165,
        "top3_skills_score": 0.512360781856845,
        "behavior_competency_score": 0.4479469427336262,
        "top1_behavior_skill_score": 0.4158701856646951,
        "top2_behavior_skill_score": 0.34224433521619113,
        "top3_behavior_skill_score": 0.4946814623648258
      },
      "email": "\n\nDear Mr. Muhammad Jawad,\n\nThank you for applying for the position of Software Engineer at 10Pearls Pakistan. We appreciate your interest in our company and your application.\n\nAfter evaluating your application, we regret to inform you that we are unable to offer you a position at this time. We will keep your application on file for future opportunities.\n\nWe would like to offer you some constructive feedback to help you prepare for future opportunities.\n\n1. We noticed that your resume does not mention your skills in web development. We would like to suggest that you include this in your resume to increase your chances of success in future applications.\n\n2. We noticed that you have a strong background in computer science. We would like to suggest that you include some of your technical skills in your resume. This will help us understand your technical background better.\n\n3. We noticed that you have an excellent academic background. We would like to suggest that you include your GPA in your resume. This will help us understand your academic performance better.\n\nWe wish you the best of luck in your future endeavors.\n\nRegards,\n\nHR Team\n\n10Pearls Pakistan\n\n"
    };
  }

  Future<String> uploadResume(Uint8List fileBytes,String uid) async {
    // Create a unique filename for the resume
    String fileName = '$uid.pdf';

    try {
      // Get a reference to the file in Firebase Storage
      Reference reference = storage.ref().child(fileName);

      // Upload the file to Firebase Storage
      await reference.putData(fileBytes);

      // Get the download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      // Return the download URL to save it in the Firestore or use it as needed
      return downloadURL;
    } catch (e) {
      print('Error uploading resume: $e');
      return '';
    }
  }

  // Future<File> convertPlatformFileToWebFile(PlatformFile platformFile) async {
  //   final bytes = html.File(platformFile.bytes!, platformFile.name);
  //   return File.fromRawPath(bytes);
  // }
}

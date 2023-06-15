import 'dart:convert';

import 'package:app4hr/common/functions.dart';
import 'package:app4hr/utils/firestore.dart';
import 'package:app4hr/widgets/popups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../common/constants.dart';
import '../../models/applications.dart';
import '../../models/positions.dart';
import '../../utils/navigation_functions.dart';
import '../../widgets/Graph.dart';
import '../../widgets/pieGraph.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  _ApplicationsState createState() => _ApplicationsState();
}


class _ApplicationsState extends State<Applications> {
  FirestoreService firestoreService = FirestoreService();
  List<PositionData> positions = [];
  List<Application> applications = [];
  List<DocumentSnapshot<Object?>> users = [];

  @override
  Widget build(BuildContext context) {
    var rightContentMargin =
        EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<List<List<dynamic>>> ss) {
            if (ss.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            positions = ss.data![1] as List<PositionData>;
            applications = ss.data![0] as List<Application>;
            users = ss.data![2] as List<DocumentSnapshot<Object?>>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                margin: rightContentMargin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    const Text(
                      'Applications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Position',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Date Of Application',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'AI Decision',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'HR Decision',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.5,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        Application application = applications[index];
                        PositionData position = positions
                            .firstWhere((p) => p.id == application.positionId);
                        Map<String, dynamic> user = users
                            .firstWhere((u) => u.id == application.candidateId)
                            .data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () => showGraph(application),
                          child: Padding(
                            padding: EdgeInsets.only(top: height * 0.03),
                            child: LayoutBuilder(builder: (context, cons) {
                              return Container(
                                width: cons.maxWidth,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(user!["email"])),
                                        Expanded(
                                            flex: 1,
                                            child: Text(position.title)),
                                        Expanded(
                                            flex: 1,
                                            child: Text(DateFormat.yMd()
                                                .format(application.date))),
                                        Expanded(
                                          flex: 1,
                                          child: getChip(getDecisionStatusForAI(application.aiDecision)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: getChip(getDecisionStatus(
                                              application.status,
                                              application.hrDecision)),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: getChip(application.status)),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Chip getChip(String status) {
    return Chip(
      label: Text(
        status,
        style: chipTextStyle,
      ),
      backgroundColor: getChipColor(status),
    );
  }

  showGraph(Application application) {
    List<GraphPoint> points = [];
    double xIndex = 0;
    int mul = 10;
    application.explanation.forEach((key, value) {
      xIndex = xIndex + 2;
      points.add(GraphPoint(
          xIndex, (value * mul).round().toDouble(), key.substring(0, 7)));
    });
    // application.explanation.forEach((key, value) {
    //   xIndex = xIndex + 2;
    //   points.add(RawDataSet(title: key, color: , values: value));
    // });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: [
            SingleChildScrollView(child: Column(children: [

              // RadarChartSample1(),
              BarChartWidget(points: points),
            ],)),
            const SizedBox(
              height: 40,
            ),
            if (showGraphButtons(application.status)) buttons(application),
          ]);
        });
  }

  Widget buttons(Application application) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () async {
              Popups.showProgressPopup(context);
              var app = Application(
                  id: application.id,
                  candidateId: application.candidateId,
                  positionId: application.positionId,
                  status: "accepted",
                  date: application.date,
                  aiDecision: application.aiDecision,
                  hrDecision: true,
                  email: application.email,
                  explanation: application.explanation,
                  downloadableResumeLink: application.downloadableResumeLink,
              );
              var user = await firestoreService.getUserById(app.candidateId);
              var pos = positions.firstWhere((p) => p.id == app.positionId);
              await firestoreService.updateApplication(app);

              await sendEmail(user!.data()!["email"], app.email, pos.title);
            },
            child: const Text("Accept")),
        const SizedBox(
          width: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () async {
                Popups.showProgressPopup(context);
                var app = Application(
                    id: application.id,
                    candidateId: application.candidateId,
                    positionId: application.positionId,
                    status: "rejected",
                    date: application.date,
                    aiDecision: application.aiDecision,
                    hrDecision: false,
                    email: application.email,
                    explanation: application.explanation,
                    downloadableResumeLink: application.downloadableResumeLink,
                );
                var user = await firestoreService.getUserById(app.candidateId);
                var pos = positions.firstWhere((p) => p.id == app.positionId);

                await firestoreService.updateApplication(app);
                await sendEmail(user!.data()!["email"], app.email, pos.title);
              },
              child: const Text("Reject"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(width: 200,),
            ElevatedButton(
              onPressed: () async {
                gotoPDFViewer(context,application.downloadableResumeLink);
              },
              child: const Text("View Resume"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        ),

      ],
    );
  }

  Future<List<List<dynamic>>> getData() async {
    var positions = await firestoreService.getAllPositions();
    var applications = await firestoreService.getAllApplications();
    var users = await firestoreService.getAllUsers();

    return [applications, positions, users];
  }

  Future<void> sendEmail(
      String toEmail, String emailMessage, String positionName) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final emailParams = {
      "to_email": toEmail,
      "from_name": "App4HR",
      "subject": "Application Response for the Position $positionName",
      "message": emailMessage,
    };

    final payload = {
      "service_id": "",
      "template_id": "",
      "user_id": "",
      "accessToken": "",
      "template_params": emailParams,
    };
    var encodedPayload = jsonEncode(payload);
    print(encodedPayload);
    final response = await http.post(url,
        body: encodedPayload, headers: {"Content-Type": "application/json"});
    // http.Response response = http.Response("Hello", 200);
    if (response.statusCode == 200) {
      var message = 'Email is sent successfully!';
      print(message);
      Navigator.pop(context);
      Navigator.pop(context);
      Popups.showSuccessPopup(context, message);
    } else {
      print('Failed to send email. Error: ${response.body}');
    }
  }
}

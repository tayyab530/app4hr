import 'package:app4hr/common/functions.dart';
import 'package:app4hr/utils/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/applications.dart';
import '../../models/positions.dart';
import '../../widgets/Graph.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  _ApplicationsState createState() => _ApplicationsState();
}

FirestoreService firestoreService = FirestoreService();

class _ApplicationsState extends State<Applications> {
  List<Position> positions = [];
  List<Application> applications = [];
  List<DocumentSnapshot<Object?>> users = [];

  @override
  Widget build(BuildContext context) {
    var rightContentMargin =
        EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.4);
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<List<List<dynamic>>> ss) {
            if (ss.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            positions = ss.data![1] as List<Position>;
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
                    const SizedBox(height: 15.0),
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
                        Position position = positions
                            .firstWhere((p) => p.id == application.positionId);
                        Map<String, dynamic> user = users
                            .firstWhere((u) => u.id == application.candidateId)
                            .data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () => showGraph(application),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: LayoutBuilder(builder: (context, cons) {
                              return Container(
                                width: cons.maxWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 1, child: Text(user!["email"])),
                                    Expanded(
                                        flex: 1, child: Text(position.title)),
                                    Expanded(
                                        flex: 1,
                                        child: Text(DateFormat.yMd()
                                            .format(application.date))),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            application.aiDecision.toString())),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            application.hrDecision.toString())),
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

  showGraph(Application application) {
    List<GraphPoint> points = [];
    double xIndex = 0;
    int mul = 10;
    application.explanation.forEach((key, value) {
      xIndex = xIndex + 2;
      points.add(GraphPoint(
          xIndex, (value * mul).round().toDouble(), key.substring(0, 7)));
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: [
            BarChartWidget(points: points),
            SizedBox(
              height: 40,
            ),
            buttons
          ]);
        });
  }

  Widget get buttons => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Accept")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Reject"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      );

  Future<List<List<dynamic>>> getData() async {
    var positions = await firestoreService.getAllPositions();
    var applications = await firestoreService.getAllApplications();
    var users = await firestoreService.getAllUsers();

    return [applications, positions, users];
  }
}

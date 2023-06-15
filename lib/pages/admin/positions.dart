import 'package:app4hr/pages/admin/positionForm.dart';
import 'package:app4hr/utils/firestore.dart';
import 'package:flutter/material.dart';

import '../../models/applications.dart';
import '../../models/positions.dart';

class Positions extends StatefulWidget {
  @override
  _PositionsState createState() => _PositionsState();
}

FirestoreService firestoreService = FirestoreService();

class _PositionsState extends State<Positions> {
  List<PositionData> positions = [];
  List<Application> applications = [];

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
            positions = ss.data![0] as List<PositionData>;
            applications = ss.data![1] as List<Application>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                margin: rightContentMargin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: (ctx){
                          return const AddPositionScreen();
                        }).then((value) => setState((){}));
                      },
                      child: const Text('Add New Position'),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Positions',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Position Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Applications',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.5,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: positions.length,
                      itemBuilder: (context, index) {
                        PositionData position = positions[index];
                        List<Application> listOfApp = applications
                            .where((app) => app.positionId == position.id)
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LayoutBuilder(builder: (context, cons) {
                            return Container(
                              width: cons.maxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1, child: Text(position.title)),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            listOfApp.length.toString())),
                                    // child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: listOfApp
                                    //         .map((e) => Chip(
                                    //               label: Text(
                                    //                 e.status,
                                    //                 style: const TextStyle(
                                    //                   color: Colors.white,
                                    //                 ),
                                    //               ),
                                    //               backgroundColor:
                                    //                   getChipColor(e.status),
                                    //             ))
                                    //         .toList()),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          }),
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

  Future<List<List<dynamic>>> getData() async {
    var positions = await firestoreService.getAllPositions();
    var posIds = positions.map((p) => p.id).toList();
    var applications =
        (await firestoreService.getApplicationsByPositionIds(posIds)).toList();

    return [positions, applications];
  }
}

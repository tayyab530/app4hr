import 'package:app4hr/utils/firestore.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  FirestoreService _fireStoreService = FirestoreService();
  var tileMargin = const EdgeInsets.all(10);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (ctx, AsyncSnapshot<List<List<dynamic>>> ss) {
          if (ss.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var totalPendingApps = ss.data![0];
          var totalRejectedApps = ss.data![1];
          var totalAcceptedApps = ss.data![2];

          return Container(
            height: size.height * 0.17,
            width: size.width * 0.6,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildTile(totalPendingApps.length.toString(), "Pending Applications", Icons.file_copy_outlined),
                _buildTile(totalRejectedApps.length.toString(), "Rejected Applications", Icons.cancel_outlined),
                _buildTile(totalAcceptedApps.length.toString(), "Accepted Applications", Icons.check_box_outlined),
                ]
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(String num,String subTitle,IconData iconData){
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 3,
        margin: tileMargin,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    num,
                    style: homeTileNumberTextStyle,
                  ),
                  Icon(iconData,size: homeTileIconSize,),
                ],
              ),
              SizedBox(height: 10,),
              Text(subTitle,style: homeTileSubtitleTextStyle,)
            ],
          ),
        ),
      ),
    );
  }

  Future<List<List<dynamic>>> getData() async {
    var posIds =
        (await _fireStoreService.getAllPositions()).map((e) => e.id).toList();
    var totalPendingApps =
        (await _fireStoreService.getApplicationsByPositionIds(posIds))
            .where((element) => element.status == "pending")
            .toList();
    var totalRejectedApps =
        (await _fireStoreService.getApplicationsByPositionIds(posIds))
            .where((element) => element.status == "rejected")
            .toList();
    var totalAcceptededApps =
        (await _fireStoreService.getApplicationsByPositionIds(posIds))
            .where((element) => element.status == "accepted")
            .toList();
    return [totalPendingApps, totalRejectedApps, totalAcceptededApps];
  }
}

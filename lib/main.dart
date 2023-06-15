import 'package:app4hr/screens/admin_dashboard.dart';
import 'package:app4hr/screens/client_dashboard.dart';
import 'package:app4hr/utils/firestore.dart';
import 'package:app4hr/utils/navigation_functions.dart';
import 'package:app4hr/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/applications.dart';
import 'models/candidate.dart';
import 'models/positions.dart';
import 'utils/authentication.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();

  FirestoreService fireStoreService = FirestoreService();

  // await fireStoreService.addDemoPositions();

  // var list = (await fireStoreService.getAllPositions()).map((e) => e.id).toList();
  // print(list);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App4HR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginScreen(),
      home: checkUserLoggedIn() ? DashboardSelector():LoginScreen(),
    );
  }
}

class DashboardSelector extends StatelessWidget {
  DashboardSelector({Key? key}) : super(key: key);
  final fireStoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fireStoreService.checkIfUserIsAdmin(user!.uid),
          builder: (ctx,AsyncSnapshot<bool?> ss){
            if(ss.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            else if(ss.data == null){
              return LoginScreen();
            }
            else if(ss.data!){
              return const AdminDashboard();
            }
            else{
              return const ClientDashboard();
            }
          }),
    );
  }
}







import 'package:app4hr/screens/admin_dashboard.dart';
import 'package:app4hr/screens/client_dashboard.dart';
import 'package:app4hr/widgets/login_screen.dart';
import 'package:flutter/material.dart';

gotoClientDashboard(BuildContext context){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute (
      builder: (BuildContext context) => const ClientDashboard(),
    ),
  );
}

gotoAdminDashboard(BuildContext context){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute (
      builder: (BuildContext context) => const AdminDashboard(),
    ),
  );
}

gotoLogin(BuildContext context){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute (
      builder: (BuildContext context) => LoginScreen(),
    ),
  );
}


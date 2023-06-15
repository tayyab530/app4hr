import 'package:app4hr/screens/admin_dashboard.dart';
import 'package:app4hr/screens/client_dashboard.dart';
import 'package:app4hr/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../pages/admin/pdfViewer.dart';

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

gotoPDFViewer(BuildContext context,String url){
  html.window.open(url,"_blank");
  // Navigator.of(context).pushReplacement(
  //   MaterialPageRoute (
  //     builder: (BuildContext context) => PDFViewer(pdfPath: url,),
  //   ),
  // );
}


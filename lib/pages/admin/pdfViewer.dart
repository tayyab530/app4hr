import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PDFViewer extends StatelessWidget {
  final String pdfPath;

  const PDFViewer({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFile(),
        builder: (context,AsyncSnapshot<PdfController?> ss) {
          if(ss.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          PdfController pdfController = ss.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Resume Viewer'),
            ),
            body: PdfView(
              controller: pdfController,
            ),
          );
        }
    );
  }

  Future<PdfController?> getFile() async {
    try{
    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child("$pdfPath.pdf");
    Uint8List? data = await ref.getData(1024*1024);
    var document = PdfDocument.openData(data!);

    return PdfController(document: document);

    }
    catch(e){
      print("Error" + e.toString());
      return null;
    }
  }
}

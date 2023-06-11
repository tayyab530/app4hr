import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class ResumeUploadPopup extends StatefulWidget {
  const ResumeUploadPopup({super.key});

  @override
  _ResumeUploadPopupState createState() => _ResumeUploadPopupState();
}

class _ResumeUploadPopupState extends State<ResumeUploadPopup> {
  File? _resumeFile;

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _resumeFile = File.fromRawPath(result.files.single.bytes!);
          // _resumeFile?.rename(result.files.single.name);
        });
      }
    } on PlatformException catch (e) {
      print("Error while picking the file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Resume'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_resumeFile != null) ...[
              Text('Resume.pdf', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickResume,
              child: Text('Select Resume'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Perform resume upload logic here
            if (_resumeFile != null) {
              // Perform the upload process using _resumeFile
              // You can access the file path using _resumeFile.path
              // For example, you can upload it to a server or process it further.
              // Replace the logic below with your own implementation.
              print('Uploading resume: ${_resumeFile!.path.toString()}');
            }
            Navigator.of(context).pop();
          },
          child: Text('Upload'),
        ),
      ],
    );
  }
}
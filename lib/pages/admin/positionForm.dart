import 'package:app4hr/models/positions.dart';
import 'package:app4hr/pages/admin/applications.dart';
import 'package:app4hr/utils/firestore.dart';
import 'package:app4hr/widgets/popups.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPositionScreen extends StatefulWidget {
  const AddPositionScreen({super.key});

  @override
  _AddPositionScreenState createState() => _AddPositionScreenState();
}

class _AddPositionScreenState extends State<AddPositionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _shortDescriptionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createPosition() {
    if (_formKey.currentState!.validate()) {
      Popups.showProgressPopup(context);
      // Get the entered values
      String title = _titleController.text;
      String shortDescription = _shortDescriptionController.text;
      String description = _descriptionController.text;

      PositionData positionData = PositionData(id: "", title: title, shortDescription: shortDescription, description: description);

      FirestoreService fireStoreService = FirestoreService();
      // Create a new document in Firestore
      fireStoreService.addPosition(positionData).then((_) {
        Navigator.pop(context);
        // Clear the form fields after successful creation
        _titleController.clear();
        _shortDescriptionController.clear();
        _descriptionController.clear();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Position created successfully')),
        );
      }).catchError((error) {
        Navigator.pop(context);
        // Show an error message if creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create position')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Position'),
      content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _shortDescriptionController,
                    decoration: InputDecoration(labelText: 'Short Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a short description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _createPosition,
                    child: Text('Create'),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahul_sir_test/sqf_db_helper.dart';
import 'package:rahul_sir_test/user_model.dart';

class UpdateForm extends StatefulWidget {
  final UserModel user;
  final VoidCallback onUpdate;

  const UpdateForm({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.user.title);
    _descriptionController = TextEditingController(text: widget.user.description);
    _image = widget.user.image != null ? File(widget.user.image!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _image != null
                      ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                  )
                      : Placeholder(
                    fallbackHeight: 100,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Update your title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Update your description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.brown),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateUser() {
    final updatedNote = UserModel(
      id: widget.user.id,
      title: _titleController.text,
      description: _descriptionController.text,
      image: _image?.path,
    );
    DbHelper().updateData(updatedNote).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note updated')),
      );
      widget.onUpdate();
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update note: $error')),
      );
    });
  }
}

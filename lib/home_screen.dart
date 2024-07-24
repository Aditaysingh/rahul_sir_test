import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahul_sir_test/sqf_db_helper.dart';
import 'package:rahul_sir_test/user_model.dart';

import 'data_show_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper? dbHelper;
  final nameController = TextEditingController();
  final desController = TextEditingController();
  File? _image;

  @override
  void initState() {
    dbHelper = DbHelper();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _image!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Enter your title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: desController,
                decoration: InputDecoration(
                    labelText: 'Enter your description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  UserModel userModel = UserModel(
                    title: nameController.text,
                    description: desController.text,
                    image: _image!.path,
                  );
                  dbHelper?.addNote(userModel);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowData()));
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.brown),
                minimumSize: WidgetStatePropertyAll(Size(mediaQuery.width * 0.95, 40)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

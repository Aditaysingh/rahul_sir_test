import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rahul_sir_test/home_screen.dart';
import 'package:rahul_sir_test/sqf_db_helper.dart';
import 'package:rahul_sir_test/update_screen.dart';
import 'package:rahul_sir_test/user_model.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<UserModel> taskList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    DbHelper().getAllData().then((value) {
      setState(() {
        taskList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Data'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: taskList[index].image != null && taskList[index].image!.isNotEmpty
                  ? CircleAvatar(
                radius: 30,
                backgroundImage: FileImage(File(taskList[index].image!)),
              )
                  : CircleAvatar(
                radius: 25,
                child: Icon(Icons.image),
              ),
              title: Text(taskList[index].title.toString()),
              subtitle: Text(taskList[index].description.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        _navigateToUpdateScreen(taskList[index]);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(taskList[index]);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddScreen() {
   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
  }

  void _navigateToUpdateScreen(UserModel user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateForm(user: user, onUpdate: _fetchData)),);
  }

  void _showDeleteDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DbHelper().deleteData(user.id!).then((_) {
                  setState(() {
                    taskList.remove(user);
                  });
                  Navigator.of(context).pop();
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

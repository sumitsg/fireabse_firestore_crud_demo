import 'package:fireabse_firestore_crud_demo/main.dart';
import 'package:fireabse_firestore_crud_demo/pages/add_student.dart';
import 'package:fireabse_firestore_crud_demo/pages/list_student.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Firestore '),
      ),
      body: const ListStudentPage(),
      bottomSheet: Padding(
        padding: EdgeInsets.only(bottom: 40, left: 30, right: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              fixedSize: const Size(double.maxFinite, 40),
              primary: Colors.blue[600]),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddStudentPage())),
          child: const Text(
            'ADD STUDENT',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

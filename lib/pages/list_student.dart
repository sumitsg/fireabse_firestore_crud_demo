import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireabse_firestore_crud_demo/pages/updateinfo.dart';
import 'package:flutter/material.dart';

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({Key? key}) : super(key: key);

  @override
  _ListStudentPageState createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  // ! for deleting user
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  Future<void> deleteUser(id) {
    // print('user deleted $id');
    return students
        .doc(id)
        .delete()
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Data Deleted...!'),
            ),
          ),
        )
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print('failed to Delete : $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: studentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Error in listing');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ! storing firebase data into list to show

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot doc) {
          Map a = doc.data() as Map<String, dynamic>;
          storedocs.add(a);
          // ? storing id to delete from database
          a['id'] = doc.id;
        }).toList();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                1: FixedColumnWidth(200),
                0: FixedColumnWidth(80),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: Center(
                          child: tableHeadline(title: 'Name'),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: Center(
                          child: tableHeadline(title: 'Email'),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: Center(
                          child: tableHeadline(title: 'Action'),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < storedocs.length; i++) ...[
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            "${storedocs[i]['name']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            "${storedocs[i]['email']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateInfoPage(
                                    id: storedocs[i]['id'],
                                  ),
                                ),
                              ),
                              tooltip: 'Edit Data',
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                deleteUser(storedocs[i]['id']);
                              },
                              tooltip: 'Delete Record',
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Text tableHeadline({required String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_tugas/list_data.dart';
import 'package:responsi_tugas/side_menu.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();

  Future postData(String title, String description, String deadline) async {
    // print(title);
    String url = 'https://responsi1b.dalhaqq.xyz/api/assignments';

    // String url = 'http://localhost/api-flutter/index.php';

    // String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"title": "$title", "description": "$description", "deadline": "$deadline"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Task'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title Pekerjaan',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                hintText: 'Deadline',
              ),
            ),
            
            ElevatedButton(
              child: const Text('Tambah task'),
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                String deadline = deadlineController.text;
                // print(title);
                postData(title, description, deadline).then((result) {
                  //print(result['message']);
                  if (result['message'] == 'Assignment created') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var titleuser2 = titleuser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text(''),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        //     ],
        //   ),
        // ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsi_tugas/list_data.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  const EditData(
      {Key? key, required this.title, required this.description, required this.deadline, required this.id})
      : super(key: key);
  final String title;
  final String description;
  final String deadline;
  final String id;

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();

  Future updateData(String title, String description, String deadline) async {
    String url = 'https://responsi1b.dalhaqq.xyz';

    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}","title": "$title", "description": "$description"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Gagal memperbarui data');
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
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
            ElevatedButton(
              child: const Text('Update Pekerjaan'),
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                updateData(title, description).then((result) {
                  if (result['message'] == 'Assignment updated') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Data berhasil di update'),
                          content: const Text('OK'),
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
                      },
                    );
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_tugas/edit_data.dart';
import 'package:responsi_tugas/side_menu.dart';
import 'package:responsi_tugas/tambah_data.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataPekerjaan = [];
  String url = 'https://responsi1b.dalhaqq.xyz/api/assignments';

  // String url = 'http://localhost/api-flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataPekerjaan = List<Map<String, String>>.from(data.map((item) {
          return {
            'title': item['title'] as String,
            'description': item['description'] as String,
            'deadline': item['deadline'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Task'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Task Baru'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataPekerjaan.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataPekerjaan[index]['title']!),
                subtitle: Text('Description: ${dataPekerjaan[index]['description']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        lihatPekerjaan(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editPekerjaan(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataPekerjaan[index]['id']!))
                            .then((result) {
                          if (result['message'] == 'Assignment deleted') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text(''),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  void editPekerjaan(BuildContext context, int index) {
    final Map<String, dynamic> pekerjaan = dataPekerjaan[index];
    final String id = pekerjaan['id'] as String;
    final String title = pekerjaan['title'] as String;
    final String description = pekerjaan['description'] as String;
    final String deadline = pekerjaan['deadline'] as String;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditData(id: id, title: title, description: description, deadline:deadline),
    ));
  }

  void lihatPekerjaan(BuildContext context, int index) {
    final pekerjaan = dataPekerjaan[index];
    final title = pekerjaan['title'] as String;
    final description = pekerjaan['description'] as String;
    final deadline = pekerjaan['deadline'] as String;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          title: const Center(child: Text('Detail Task')),
          content: SizedBox(
            height: 50,
            child: Column(
              children: [
                Text('Title : $title'),
                Text('Description: $description'),
                Text('Deadline: $deadline'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

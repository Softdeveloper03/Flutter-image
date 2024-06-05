import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Viewimg extends StatefulWidget {
  const Viewimg({super.key});

  @override
  State<Viewimg> createState() => _ViewimgState();
}

class _ViewimgState extends State<Viewimg> {
  List record = [];

  Future<void> imgfromdb() async {
    try {
      String uri = 'http://192.168.1.106/flutter-api/view-image.php';
      var response = await http.get(Uri.parse(uri));
      setState(() {
        record = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    imgfromdb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surat gor"),
      ),
      body: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: record.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    child: Expanded(
                      child: Image.network('http://192.168.1.106/flutter-api/' +
                          record[index]['image_path']),
                    ),
                  ),
                  Container(
                    child: Text(record[index]['caption']),
                  )
                ],
              ),
            );
          }),
    );
  }
}

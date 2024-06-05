import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:lesson_image/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController caption = TextEditingController();
  File? imagepath;
  String? imagename;
  String? imagedata;
  ImagePicker imagePicker = new ImagePicker();

  Future<void> img() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (getImage != null) {
        imagepath = File(getImage.path);
        imagename = getImage.path.split('/').last;
        imagedata = base64Encode(imagepath!.readAsBytesSync());
        print(imagepath);
        print(imagename);
        print(imagedata);
        yuklesur();
      }
    });
  }

  Future<void> yuklesur() async {
    try {
      String uri = 'http://192.168.1.106/flutter-api/image.php';
      var request = http.MultipartRequest('POST', Uri.parse(uri));
      request.fields['caption'] = caption.text;
      request.files.add(await http.MultipartFile.fromPath(
          'image', imagepath!.path,
          filename: imagename));
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.transform(utf8.decoder).join();
        var responseData = jsonDecode(responseBody);
        if (responseData['success'] == "true") {
          print('well done');
        } else {
          print("!!!");
        }
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Image"),
          backgroundColor: Colors.deepPurple[300],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: caption,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    label: Text("Enter")),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            imagepath == null
                ? Text('')
                : Image.file(
                    imagepath!,
                    height: 250,
                    width: 250,
                  ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  img();
                },
                child: Text("Surat saylan")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    yuklesur();
                  });
                },
                child: Text("Upload")),
            const SizedBox(
              height: 20,
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Viewimg()));
                  },
                  child: Text('View'));
            }),
          ],
        ),
      ),
    );
  }
}

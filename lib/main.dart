import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This wid get is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter sharing',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var imageUrl = 'https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Share in flutter App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl),
            CupertinoButton(
                child: const Text("Share"),
                onPressed: () async {
                  final uri = Uri.parse(imageUrl);
                  final response = await http.get(uri);
                  final bytes = response.bodyBytes;
                  final temp = await getTemporaryDirectory();

                  final path = '${temp.path}/image.jpeg';
                  File(path).writeAsBytesSync(bytes);
                  await Share.shareFiles([
                    path
                  ], text: 'This is data');
                }),
            CupertinoButton(
                child: Text("Next Page"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => SecondPage()));
                })
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var image;
  _pickImage(String source) async {
    if (source == 'gallary') {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      await Share.shareFiles([
        image.path
      ]);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      await Share.shareFiles([
        image.path
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Image from Gallary'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
              child: const Text("from gallary"),
              onPressed: () async {
                _pickImage('gallary');
              }),
          CupertinoButton(
              child: const Text("from camera"),
              onPressed: () {
                _pickImage('camera');
              })
        ],
      )),
    );
  }
}

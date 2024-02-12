import 'dart:convert';
import 'dart:io';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true, // optional: set false to disable printing logs to console
  );
  runApp(wallpaperApp());
}

class wallpaperApp extends StatefulWidget {
  const wallpaperApp({Key? key}) : super(key: key);

  @override
  State<wallpaperApp> createState() => _wallpaperAppState();
}

class _wallpaperAppState extends State<wallpaperApp> {
  List data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var imgData = await http.get(Uri.parse(
        'https://api.unsplash.com/photos?page=1&client_id=VHFW5Her3S17W9z06s8n7Ll_1Ka8PVbRCeAWHVIKZeo'));
    var jData = jsonDecode(imgData.body);
    setState(() {
      data = jData;
    });
  }

  saveimage(String  url) async {
    var response = await http.get(Uri.parse(url));
    // Get temporary directory
    final dir = await getTemporaryDirectory();
    // Create an image name
    var filename = '${dir.path}/image.png';
    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);
    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("4K HD Wallpaper"),
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
        ),
        body: GridView.builder(
          itemCount: data.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle onTap event if needed
              },
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      data[index]['urls']['small'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveimage(data[index]['urls']['full']);
                    },
                    child: Text('Download'),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

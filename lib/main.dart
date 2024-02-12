import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

main() {
  runApp(wallpaperApp());
}

class wallpaperApp extends StatefulWidget {
  const wallpaperApp({super.key});

  @override
  State<wallpaperApp> createState() => _wallpaperAppState();
}

class _wallpaperAppState extends State<wallpaperApp> {
  List data = [];

  void initstate() {
    print("rammm");
    getData();
    super.initState();

  }

   getData() async {
    var imgData = await http.get(Uri.parse(
        'https://api.unsplash.com/photos?page=1&client_id=VHFW5Her3S17W9z06s8n7Ll_1Ka8PVbRCeAWHVIKZeo')).then((value) {
          print(value);});

    var jData = jsonDecode(imgData.body);
    print(jData['urls']);
    setState(() {
        data = jData['urls'];
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("4K HD Wallpaper"),
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
        ),
        body: GridView.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index){
              return Container(
                height: 300,

                padding: const EdgeInsets.all(10),
                child: Image.network(
                  data[index]['urls']['regular'],


                ),
              );
            }
        ),
      ),


    );
  }
}
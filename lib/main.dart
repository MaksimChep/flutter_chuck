import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_network/chuck.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var chuckJoke = ChuckJoke();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: NetworkImage(chuckJoke.iconUrl)),
            Text(chuckJoke.joke),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var dialogContext;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return const Center(
                    child: SpinKitRing(color: Colors.black),
                  );
                });
            final response = await http
                .get(Uri.parse('https://api.chucknorris.io/jokes/random'));
            setState(() {
              if (response.statusCode == 200) {
                var jsoneRespose =
                    jsonDecode(response.body) as Map<String, dynamic>;
                chuckJoke.joke = jsoneRespose['value'];
                chuckJoke.iconUrl =
                    'https://api.chucknorris.io/img/chucknorris_logo_coloured_small.png';
              }
            });
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }
}

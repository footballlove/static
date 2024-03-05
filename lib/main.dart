// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_application_1/pub_card.dart';
import 'package:flutter/material.dart';

import 'models/pubs.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

void main() => runApp(EverisFridayApp());

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({super.key});
  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = <Pubs>[];

  late Future<String> futurePubs;

  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Everis Fridays Pub'),
          backgroundColor: const Color(0xff9aae04),
        ),
        body: Center(
          child: _buildPubs(),
        ),
      ),
    );
  }

  Widget _buildPubs() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        }
        return ListView.builder(
          itemCount: _listPubs.length,
          itemBuilder: (context, index) {
            return PubCard(_listPubs[index]);
          },
        );
      },
      future: futurePubs,
    );
  }
}

Future<String> getPubs(listPubs) async {
  final Response response =
      await http.get(Uri.parse('http://192.168.1.29:1337/api/pubs'));

  if (response.statusCode == 200) {
    List<dynamic> pubsListRaw = jsonDecode(response.body);
    for (var i = 0; i < pubsListRaw.length; i++) {
      listPubs.add(Pubs.fromJson(pubsListRaw[i]));
    }

    return "Success!";
  } else {
    throw Exception('Failed to load data');
  }
}

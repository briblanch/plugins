// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(new MaterialApp(title: 'Firestore Example', home: new MyHomePage()));
}

class BookList extends StatelessWidget {
  final List<String> books;

  BookList({Key key, @required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: books
          .map(
            (String b) => new ListTile(
                  title: new Text(b),
                ),
          )
          .toList(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> books = <String>[];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<Null> _addMessage() async {
    Firestore.instance
        .collection('books')
        .document()
        .setData(<String, String>{'message': 'Hello world!'});
    _fetchBooks();
  }

  Future<Null> _fetchBooks() async {
    final QuerySnapshot snap =
        await Firestore.instance.collection('books').getDocuments();
    setState(() {
      books = snap.documents
          .map<String>((DocumentSnapshot d) => d['message'])
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Firestore Example'),
      ),
      body: new BookList(
        books: books,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

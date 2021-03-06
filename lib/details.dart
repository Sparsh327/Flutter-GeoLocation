import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart' as cf;

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, @required this.id}) : super(key: key);
  final String id;
  // DetailPage(this.id);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String name, email, url, location;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final DocumentSnapshot documents = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.id)
        .get();
    setState(() {
      name = documents.data()["N"].toString();
      email = documents.data()["E"].toString();
      url = documents.data()["I"].toString();
      location = documents.data()["L"].toString();
    });

    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: url == null
                              ? NetworkImage(
                                  "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                )
                              : NetworkImage(url))),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                location,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}

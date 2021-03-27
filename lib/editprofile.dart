import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_internship/details.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  TextEditingController textEditingController3 = new TextEditingController();
  TextEditingController textEditingController4 = new TextEditingController();
  final db = FirebaseFirestore.instance;
  File _image;
  String id;
  final picker = ImagePicker();
  FirebaseStorage _storage = FirebaseStorage.instance;
  String url;
  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Reference reference = _storage.ref().child("images/");
    UploadTask uploadTask = reference
        .child('image1' + DateTime.now().toString())
        .putFile(_image)
        .whenComplete(() async {
      var Url = (await FirebaseStorage.instance
              .ref('images/image12021-03-26 11:17:37.406468')
              .getDownloadURL())
          .toString();
      setState(() {
        url = Url;
        print("URL:$url");
      });
      // print(url);
      // return url;
    });
  }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    var currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    // print(
    //     ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    textEditingController4.text =
        ' ${first.featureName} ${first.subLocality}  ${first.addressLine}, ';

    return first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Create Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
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
                              image: _image == null
                                  ? NetworkImage(
                                      "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                    )
                                  : FileImage(_image))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: textEditingController1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Full Name",
                    labelStyle: TextStyle(fontSize: 18.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: textEditingController2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: 'E-mail',
                    labelStyle: TextStyle(fontSize: 18.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: textEditingController3,
                  obscureText: true ? showPassword : false,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 18.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: textEditingController4,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        getUserLocation();
                      },
                      icon: Icon(
                        Icons.location_searching_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 3),
                    hintText: "ff",
                    labelText: 'Location',
                    labelStyle: TextStyle(fontSize: 18.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ignore: deprecated_member_use

                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () {
                      uploadDetails();
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        var Id = id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailPage(id: Id)));
                      });
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  uploadDetails() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    var now = new DateTime.now();
    var format = new DateFormat('yyyyMMddHHmmss');
    String dt = formatter.format(now);
    id = format.format(now);

    db.collection("Users").doc(id).set({
      "N": textEditingController1.text.trim(),
      "D": dt,
      "E": textEditingController2.text.trim(),
      "L": textEditingController4.text.trim(),
      "I": url
    }).then((value) {
      Toast.show("Amount added", context);
    });
  }
}

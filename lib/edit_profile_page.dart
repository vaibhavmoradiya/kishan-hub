import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/custom_app_bar.dart';

import 'auth/auth.dart';

class EditProfile extends StatefulWidget {
  EditProfile({this.auth, this.uid});

  final BaseAuth auth;
  final String uid;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String user = 'User';
  String userEmail = 'Email';
  String id;

  @override
  void initState() {
    super.initState();
    widget.auth.infoUser().then((onValue) {
      setState(() {
        user = onValue.displayName;
        userEmail = onValue.email;
        id = onValue.uid;

        print('ID $id');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.greenAccent[400],
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              var doc = snapshot.data;
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.greenAccent[400], Colors.greenAccent[400]],
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                CircleAvatar(
                                  radius: 65.0,
                                  child: Text(user[0].toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50)),
                                ),
                                // SizedBox(
                                //   height: 10.0,
                                // ),
                                // Text(doc['Name'],
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 20.0,
                                //     )),
                                // SizedBox(
                                //   height: 10.0,
                                // ),
                                // Text(
                                //   doc['City'],
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 15.0,
                                //   ),
                                // )
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Card(
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                              child: Container(
                                  width: 310.0,
                                  height: 290.0,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Information",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.user,
                                                color: Colors.purple,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(doc['Name'],
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.mail,
                                                color: Colors.redAccent,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(doc['Email'],
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: Colors.green,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(doc['MobileNo'],
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.place,
                                                color: Colors.blueAccent,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(doc['City'],
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.27,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("Total Product",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0)),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(doc['count'].toString(),
                                      style: TextStyle(fontSize: 15.0))
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text("Active Product",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0)),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(doc['active'].toString(),
                                      style: TextStyle(fontSize: 15.0))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/widgets/list_body.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  String userID;

  @override
  void initState() {
    super.initState();

    setState(() {
      Auth().currentUser().then((onValue) {
        userID = onValue;
        print('User $userID');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
         
          Expanded(
            child: StoreBody(),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Text("Top"),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     child: Text(
          //       '',
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: Text("Body"),
          // ),
        ],
      ),
    );
  }
}
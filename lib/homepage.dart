import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/edit_profile_page.dart';
import 'package:kishan_hub/widgets/home_page.dart';
import 'package:random_color/random_color.dart';

import 'login/content_page.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String user = 'User';
  String userEmail = 'Email';
  String id;
  Content page = ContentPage();

  Widget contentPage = MainHomePage();

  void _signOut() {
    try {
      widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

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
    return Scaffold(
      
      drawer: Drawer(
          elevation: 30.0,
          child: Container(
            color: Colors.greenAccent[100],
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    
                    child: Text(user[0].toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    maxRadius: 10.0,
                    // backgroundImage: AssetImage("images/abc.png"),
                    //backgroundImage: NetworkImage('https://www.atmeplay.com/images/users/avtar/avtar.png'),
                    //  backgroundColor: Colors.white,
                  ),
                  accountName: 
                     
                      
                        Text('$user',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                     
                        //   IconButton(
                        //     icon: Icon(FontAwesomeIcons.edit),
                        //     onPressed: (){
                        //       Navigator.of(context).pop();

                        //   page.editProfile().then((value) {
                        //   print(value);
                        //   setState(() {
                        //     contentPage = value;
                        //   });
                        // });
                        //     },
                        //   )
                      
                    
                  accountEmail:
                  GestureDetector(
                     onTap:(){
                           Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => 
                                      EditProfile(
                                          uid: id,
                                          auth: widget.auth,
                                          )
                                          ));
                          },
                    child: Row(
                      children: [
                         Text('$userEmail', style: TextStyle(color: Colors.black)),
                           Padding(
                            padding: const EdgeInsets.only(left: 90),
                            child: Icon(FontAwesomeIcons.userAlt,size: 16,),
                          ),
                      ],
                    ),
                  ),
                     
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],

                    //     image: DecorationImage(
                    //       alignment: Alignment(1.0, 0),
                    //       image: AssetImage(
                    //         'assets/images/misanplas.jpg',
                    //       ),
                    //       fit: BoxFit.scaleDown, //BoxFit.fitHeight
                    //     )
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.store().then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(
                    Icons.store,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Store',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.admin(id).then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Add Product',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.marketprice().then((value) { 
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(
                    FontAwesomeIcons.chartLine,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Market Price',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    FontAwesomeIcons.newspaper,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Latest News',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _signOut();
                  },
                ),
              ],
            ),
          )),
      appBar: AppBar(
        title: Text('Kishan Hub'),
      ),
      body: contentPage,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

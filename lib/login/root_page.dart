import 'package:flutter/cupertino.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/login/login_page.dart';

import '../homepage.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;
  _RootPageState createState() => _RootPageState();

}

enum AuthStatus{ notSignIn, signIn}

class _RootPageState extends State<RootPage>{
  AuthStatus _authStatus = AuthStatus.notSignIn;
  
  @override
  void initState() { 
    super.initState();
    widget.auth.currentUser().then((value) {
      setState((){
        print(value);
        _authStatus = 
        value == 'no_login' ? AuthStatus.notSignIn : AuthStatus.signIn;
      });
    });
  }

  void _signIn(){
    setState(() {
      _authStatus = AuthStatus.signIn;
    });
  }

  void _signOut() {
    setState(() {
      _authStatus = AuthStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    switch(_authStatus){
      case AuthStatus.notSignIn:
        return LoginPage(auth: widget.auth, onSignIn: _signIn);
        break;
      case AuthStatus.signIn:
        return HomePage(auth: widget.auth,onSignedOut: _signOut);
        break;
    }

    return _widget;
  }
}
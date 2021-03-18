import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/model/user_model.dart';

import '../homepage.dart';

class LoginPage extends StatefulWidget{
  LoginPage({this.auth, this.onSignIn});

  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, Register }
enum SelectSource {camera, gallery}

class _LoginPageState extends State<LoginPage> {

   @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      
      body: Stack(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("images/ab1.jpg"),
            //     fit: BoxFit.cover
            //   )
            // ),
            color: Colors.greenAccent[400],
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  Flexible(
                    flex: 3,
                    child: AuthCard(auth:widget.auth,onSignIn:widget.onSignIn),
                  ),
                ],
              ),
            )
          )
        ],
      )
    
    );
  }



}

class AuthCard extends StatefulWidget{
  AuthCard({this.auth, this.onSignIn});

  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
   final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  String _mobileno;
  String _city;
  String user;
  String countryValue;
  String stateValue;
  String cityValue;

  bool _obscureText = true;
  FormType _formType = FormType.login;
 // List<DropdownMenuItem<String>> _cityItems;

  @override
  void initState() { 
    super.initState();
    // setState(() {
    //   _cityItems = getCityItems();
    //   _itemCity = _cityItems[0].value;
    // });
  }

  getData() async {
    return await Firestore.instance.collection('cities').getDocuments();
  }

   //Dropdownlist from firestore
  // List<DropdownMenuItem<String>> getCityItems() {
  //   List<DropdownMenuItem<String>> items = List();
  //   QuerySnapshot dataCiudades;
  //   getData().then((data) {

  //     dataCiudades = data;
  //     dataCiudades.documents.forEach((obj) {
  //       print('${obj.documentID} ${obj['name']}');
  //       items.add(DropdownMenuItem(
  //         value: obj.documentID,
  //         child: Text(obj['name']),
  //       ));
  //     });
  //   }).catchError((error) => print(' error.....' + error));

  //   items.add(DropdownMenuItem(
  //     value: '0',
  //     child: Text('- Select city -'),
  //   ));

  //   return items;
  // }

  bool _validatesave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

   //we create a method validate and send
  void _validateSubmit() async {
    if (_validatesave()) {
      try {
        String userId = await widget.auth.signInEmailPassword(_email, _password);
        print('User logged in: $userId ');//ok
        widget.onSignIn();
        //return menu_page.dart
        //Navigator.of(context).pop();
        HomePage(auth: widget.auth);  
      } catch (e) {
        print('Error .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Error in Autenticación'),
          title: Text('Error'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }

  //Now create a method validate and register
  void _validateRegister() async {
    if (_validatesave()) {
      try{
        User usuario = User(//model/user_model.dart instance usuario
            name: _name,
            city: _city,
            email: _email,
            password: _password,
            mobileno: _mobileno,
           );
        String userId = await widget.auth.signUpEmailPassword(usuario);
        print('User logged in : $userId');//ok
        widget.onSignIn();
          //menu_page.dart
       // Navigator.of(context).pop();
        HomePage(auth: widget.auth);
      }catch (e){
        print('Error .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Error in register'),
          title: Text('Error'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }

//method go register
  void _isRegister() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.Register;
    });
  }

  //method go Login
  void _irLogin() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.login;
    });
  }

   void _switchAuthMode() {
    if (_formType == FormType.login) {
      setState(() {
        _formType = FormType.Register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        
        height: _formType == FormType.Register ? 480 : 290,
        constraints: BoxConstraints(minHeight: _formType == FormType.Register ? 480 : 290), 
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
        
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
            if(_formType == FormType.login)
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(FontAwesomeIcons.envelope),
              ),
              validator: (value) =>
              value.isEmpty ? 'Email field is empty' : null,
              onSaved: (value) => _email = value.trim(),
            ),
      if(_formType == FormType.login)
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
      if(_formType == FormType.login)
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: _obscureText,
          decoration: InputDecoration(
              labelText: 'Password',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
          ),
          validator: (value) => value.isEmpty
              ? 'The password field must be \n at least 6 characters'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
      if(_formType == FormType.login)
        Padding(
          padding: EdgeInsets.all(10.0),
        ),

       

      if(_formType == FormType.Register)
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Full Name', icon: Icon(FontAwesomeIcons.user)),
          validator: (value) =>
          value.isEmpty ? 'The Name field is empty' : null,
          onSaved: (value) => _name = value.trim(),
        ),
      if(_formType == FormType.Register)
        Padding(
          padding: EdgeInsets.all(4.0),
        ),
      if(_formType == FormType.Register)
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Mobile No.',
            icon: Icon(FontAwesomeIcons.mobile),
          ),
          validator: (value) =>
          value.isEmpty ? 'Mobile No. field is empty' : null,
          onSaved: (value) => _mobileno = value.trim(),
        ),
      if(_formType == FormType.Register)
        Padding(
          padding: EdgeInsets.all(4.0),
        ),
     
      if(_formType == FormType.Register)
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'City',
            icon: Icon(FontAwesomeIcons.city),
          ),
          validator: (value) =>
          value.isEmpty ? 'The City field is empty' : null,
          onSaved: (value) => _city = value.trim(),
        ),
      if(_formType == FormType.Register)
        Padding(
          padding: EdgeInsets.all(4.0),
        ),
        // TextFormField(
        //     keyboardType: TextInputType.text,
        //     decoration: InputDecoration(
        //       labelText: 'Address',
        //       icon: Icon(Icons.person_pin_circle),
        //     ),
        //     validator: (value) =>
        //     value.isEmpty ? 'The Address field is empty' : null,
        //     onSaved: (value) => _Address = value.trim()),
        // Padding(
        //   padding: EdgeInsets.all(8.0),
        // ),
      if(_formType == FormType.Register)
         TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
          value.isEmpty ? 'The Email field is empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
      if(_formType == FormType.Register)
        Padding(
          padding: EdgeInsets.all(4.0),
        ),
      if(_formType == FormType.Register)
        TextFormField(
          obscureText: _obscureText,//password
          decoration: InputDecoration(
                labelText: 'Password',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) => value.isEmpty
              ? 'The password field must be \n nal least 6 characters'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
      if(_formType == FormType.Register)
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
               
                  RaisedButton(
                    child:
                        Text(_formType == FormType.login ? 'LOGIN' : 'SIGN UP',style: TextStyle(color: Colors.white),),
                    onPressed: _formType == FormType.login ? _validateSubmit : _validateRegister,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_formType == FormType.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
            ],
          )
        )
        ),
      ),
    );
  }

  // List<Widget> buildInputs() {
  //   if (_formType == FormType.login) {
  //     return [ //list or array
  //       TextFormField(
  //         keyboardType: TextInputType.emailAddress,
  //         decoration: InputDecoration(
  //           labelText: 'Email',
  //           icon: Icon(FontAwesomeIcons.envelope),
  //         ),
  //         validator: (value) =>
  //         value.isEmpty ? 'Email field is empty' : null,
  //         onSaved: (value) => _email = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //       ),
  //       TextFormField(
  //         keyboardType: TextInputType.text,
  //         obscureText: _obscureText,
  //         decoration: InputDecoration(
  //             labelText: 'Password',
  //             icon: Icon(FontAwesomeIcons.key),
  //             suffixIcon: GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _obscureText = !_obscureText;
  //                 });
  //               },
  //               child: Icon(
  //                 _obscureText ? Icons.visibility : Icons.visibility_off,
  //               ),
  //             )
  //         ),
  //         validator: (value) => value.isEmpty
  //             ? 'The password field must be \n at least 6 characters'
  //             : null,
  //         onSaved: (value) => _password = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(10.0),
  //       ),
  //     ];
  //   } if(_formType == FormType.Register) {
  //     return [
  //       Row(mainAxisAlignment: MainAxisAlignment.center,),
  //       Text('User Registration', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
  //       TextFormField(
  //         keyboardType: TextInputType.text,
  //         decoration: InputDecoration(
  //             labelText: 'Name', icon: Icon(FontAwesomeIcons.user)),
  //         validator: (value) =>
  //         value.isEmpty ? 'The Name field is empty' : null,
  //         onSaved: (value) => _name = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //       ),
  //       TextFormField(
  //         keyboardType: TextInputType.phone,
  //         decoration: InputDecoration(
  //           labelText: 'Mobile No.',
  //           icon: Icon(FontAwesomeIcons.mobile),
  //         ),
  //         validator: (value) =>
  //         value.isEmpty ? 'Mobile No. field is empty' : null,
  //         onSaved: (value) => _mobileno = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //       ),
  //       DropdownButtonFormField(
  //         validator: (value) =>
  //         value == '0' ? 'You must select a city' : null,
  //         decoration: InputDecoration(
  //             labelText: 'city', icon: Icon(FontAwesomeIcons.city)),
  //         value: _itemCity,
  //         items: _cityItems,
  //         onChanged: (value) {
  //           setState(() {
  //             _itemCity = value;
  //           });
  //         }, //seleccionarCiudadItem,
  //         onSaved: (value) => _itemCity = value,
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //       ),
  //       // TextFormField(
  //       //     keyboardType: TextInputType.text,
  //       //     decoration: InputDecoration(
  //       //       labelText: 'Address',
  //       //       icon: Icon(Icons.person_pin_circle),
  //       //     ),
  //       //     validator: (value) =>
  //       //     value.isEmpty ? 'The Address field is empty' : null,
  //       //     onSaved: (value) => _Address = value.trim()),
  //       // Padding(
  //       //   padding: EdgeInsets.all(8.0),
  //       // ),
  //        TextFormField(
  //         keyboardType: TextInputType.emailAddress,
  //         decoration: InputDecoration(
  //           labelText: 'Email',
  //           icon: Icon(FontAwesomeIcons.envelope),
  //         ),
  //         validator: (value) =>
  //         value.isEmpty ? 'The Email field is empty' : null,
  //         onSaved: (value) => _email = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //       ),
  //       TextFormField(
  //         obscureText: _obscureText,//password
  //         decoration: InputDecoration(
  //               labelText: 'Password',
  //             icon: Icon(FontAwesomeIcons.key),
  //             suffixIcon: GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _obscureText = !_obscureText;
  //                 });
  //               },
  //               child: Icon(
  //                 _obscureText ? Icons.visibility : Icons.visibility_off,
  //               ),
  //             )),
  //         validator: (value) => value.isEmpty
  //             ? 'The password field must be \n nal least 6 characters'
  //             : null,
  //         onSaved: (value) => _password = value.trim(),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(10.0),
  //       ),
  //     ];
  //   }
  // }

  // List<Widget> buildSubmitButtons() {
  //   if (_formType == FormType.login) {
  //     return [
  //       RaisedButton(
  //         onPressed: _validateSubmit,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               "Log In",
  //               style: TextStyle(color: Colors.white, fontSize: 15.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(left: 10.0),
  //             ),
  //           ],
  //         ),
  //         color: Colors.orangeAccent,
  //         shape: BeveledRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(7.0)),
  //         ),
  //         elevation: 8.0,
  //       ),
  //       FlatButton(
  //         child: Text(
  //           'Create New Account',//create new acount
  //           style: TextStyle(fontSize: 20.0, color: Colors.grey),
  //         ),
  //         onPressed: _isRegister,
  //       ),
  //     ];
  //   } else {
  //     return [
  //       RaisedButton(
  //         onPressed:  _validateRegister,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               "Register New account",//register new acount
  //               style: TextStyle(color: Colors.white, fontSize: 15.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(left: 10.0),
  //             ),
  //             Icon(
  //               FontAwesomeIcons.plusCircle,
  //               color: Colors.white,
  //             )
  //           ],
  //         ),
  //         color: Colors.orangeAccent,
  //         shape: BeveledRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(7.0)),
  //         ),
  //         elevation: 8.0,
  //       ),
  //       FlatButton(
  //         child: Text(
  //           'Do you already have an account?',
  //           style: TextStyle(fontSize: 20.0, color: Colors.grey),
  //         ),
  //         onPressed: _irLogin,
  //       )
  //     ];
  //   }
  // }
  }
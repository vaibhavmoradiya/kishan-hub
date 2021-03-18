import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/login/login_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//formateo hora

class CommonThings {
  static Size size; //size screen
}

class MyAddPage extends StatefulWidget {
  final String id;
  const MyAddPage({this.id});
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  //we declare the variables

  File _foto;
  String urlFoto;
  bool _isInAsyncCall = false;
  // String recipes;
  Auth auth = Auth();

  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String productName;
  String uid;
  String price;
  String userName;
  String mobileNo;
  String productDesc;
  String address;
  String city;

  //we create a method to obtain the image from the camera or the gallery

  Future captureImage(SelectSource opcion) async {
    File image;

    opcion == SelectSource.camera
        ? image = await ImagePicker.pickImage(source: ImageSource.camera)
        : image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _foto = image;
    });
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Select where you want to capture the image from'),
      title: Text('Select Image'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.camara;
            captureImage(SelectSource.camera);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Camera'), Icon(Icons.camera)],
          ),
        ),
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.galeria;
            captureImage(SelectSource.gallery);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Gallery'), Icon(Icons.image)],
          ),
        )
      ],
    );
    showDialog(context: context, child: alerta);
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  //crated a method validate
  bool _validarlo() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //create a method send and create recipe in Cloud Firestore
  void _enviar() {
    if (_validarlo()) {
      setState(() {
        _isInAsyncCall = true;
      });
      auth.currentUser().then((onValue) {
        setState(() {
          uid = onValue;
        });
        if (_foto != null) {
          final StorageReference fireStoreRef = FirebaseStorage.instance
              .ref()
              .child('products')
              .child(uid)
              .child('uid')
              .child('$productName.jpg');
          final StorageUploadTask task = fireStoreRef.putFile(
              _foto, StorageMetadata(contentType: 'image/jpeg'));

          task.onComplete.then((onValue) {
            onValue.ref.getDownloadURL().then((onValue) {
              setState(() {
                urlFoto = onValue.toString();

                var x =
                    Firestore.instance.collection('users').document(widget.id);
                x.updateData({'count': FieldValue.increment(1),'active':FieldValue.increment(1)});
                Firestore.instance
                    .collection('products')
                    .add({
                      'uid': uid,
                      'productName': productName,
                      'image': urlFoto,
                      'price': int.parse(price),
                      'uname': userName,
                      'mobilNo': int.parse(mobileNo),
                      'productDesc': productDesc,
                      'address': address,
                      'city': city,
                    })
                    .then((value) => Navigator.of(context).pop())
                    .catchError((onError) =>
                        print('Error in registering the user in the database'));

                _isInAsyncCall = false;
              });
            });
          });
        } else {
           var x =
                    Firestore.instance.collection('users').document(widget.id);
                x.updateData({'count': FieldValue.increment(1),'active':FieldValue.increment(1)});
          Firestore.instance
              .collection('products')
              .add({
                'uid': uid,
                'productName': productName,
                'image': urlFoto,
                'price': int.parse(price),
                'uname': userName,
                'mobilNo': int.parse(mobileNo),
                'productDesc': productDesc,
                'address': address,
                'city': city,
              })
              .then((value) => Navigator.of(context).pop())
              .catchError((onError) =>
                  print('Error in registering the user in the database'));

          _isInAsyncCall = false;
        }
      }).catchError((onError) => _isInAsyncCall = false);

      //

    } else {
      print('object not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
print(widget.id);
    return Scaffold(
      
        appBar: AppBar(
          title: Text('Add Product'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          dismissible: false,
          progressIndicator: CircularProgressIndicator(),
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10, right: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: getImage,
                        ),
                        margin: EdgeInsets.only(top: 20),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: _foto == null
                                    ? AssetImage('images/ab.jpg')
                                    : FileImage(_foto))),
                      )
                    ],
                  ),
                  Text('click to change photo'),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      //  border: InputBorder.none,
                      labelText: 'Name of Seller',
                      // fillColor: Colors.grey[300],
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => userName = value.trim(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      labelText: 'Name of Product',
                      //fillColor: Colors.grey[300],
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => productName = value.trim(),
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      labelText: 'Enter Product Description',
                      //fillColor: Colors.grey[300],
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => productDesc = value,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      labelText: 'Enter Product Price',
                      //fillColor: Colors.grey[300],
                      //filled: ,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter price ';
                      }
                    },
                    onSaved: (value) => price = value,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      labelText: 'Enter Seller City',
                      //fillColor: Colors.grey[300],
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => city = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      //border: OutlineInputBorder(),
                      labelText: 'Enter Address',
                      //fillColor: Colors.grey[300],
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => address = value.trim(),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      //   border: InputBorder.none,
                      labelText: 'Enter Seller mobile number',
                      // fillColor: Colors.grey[300],
                      // filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter number';
                      }
                      if (value.length > 10) {
                        return 'Enter Valid number';
                      }
                    },
                    onSaved: (value) => mobileNo = value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _enviar,
                        child: Text('Create',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/model/product_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class EditProduct extends StatefulWidget {

  EditProduct({this.product, this.idProduct, this.uid});
  final String idProduct;
  final String uid;
  final Product product;

  @override
  _EditProductState createState() => _EditProductState();
}

enum SelectSource { camara, galeria }

class _EditProductState extends State<EditProduct> {

  final formKey = GlobalKey<FormState>();
  String _productName;
  String _productDesc;
  String _username;
  String _city;
  String _address;
  String _mobileno;
  String _price;
  
  File _image; //
  String urlFoto = '';
  Auth auth = Auth();
  bool _isInAsyncCall = false;
  String usuario;

  BoxDecoration box = BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black),
      shape: BoxShape.circle,
      image: DecorationImage(
          fit: BoxFit.fill,
          image:AssetImage('images/ab.jpg') ));

  @override
  void initState() {
    setState(() {
      this._productName = widget.product.productName;
      this._productDesc = widget.product.productDesc;
      this._username = widget.product.username;
      this._mobileno = widget.product.mobileNo;
      this._city = widget.product.city;
      this._address = widget.product.address;
      this._price = widget.product.price;
    
      captureImage(null, widget.product.image);
    });

    print('uid recipe : '+widget.idProduct);
    super.initState();
  }

  //create method for download url image
  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future captureImage(SelectSource opcion, String url) async {
    File image;
    if (url == null) {
      print('image');
      opcion == SelectSource.camara
          ? image = await img.ImagePicker.pickImage(
          source: img.ImageSource.camera) //source: ImageSource.camera)
          : image =
      await img.ImagePicker.pickImage(source: img.ImageSource.gallery);

      setState(() {
        _image = image;
        box = BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image:FileImage(_image) ));

      });
    } else {
      print('download the image');
      _downloadFile(url, widget.product.productName).then((onValue) {
        _image = onValue;
        setState(() {
          box = BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:FileImage(_image) ));
          ////  imageReceta = FileImage(_foto);
        });

        // : FileImage(_imagen)))

      });
    }
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Select to capture the image'),
      title: Text('Select Image'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.camara;
            captureImage(SelectSource.camara, null);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Camera'), Icon(Icons.camera)],
          ),
        ),
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.galeria;
            captureImage(SelectSource.galeria, null);
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

  bool _validar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _enviar() { //send the information to firestore
    if (_validar()) {
      setState(() {
        _isInAsyncCall = true;
      });
      auth.currentUser().then((onValue) {
        setState(() {
          usuario = onValue;
        });
        if (_image != null) {
          final StorageReference fireStoreRef = FirebaseStorage.instance
              .ref()
              .child('products')
              
              .child('$_productName.jpg');
          final StorageUploadTask task = fireStoreRef.putFile(
              _image, StorageMetadata(contentType: 'image/jpeg'));

          task.onComplete.then((onValue) {
            onValue.ref.getDownloadURL().then((onValue) {
              setState(() {
                urlFoto = onValue.toString();
                Firestore.instance
                    .collection('products')
                    .document(widget.idProduct).updateData({
                 

                   'productName': _productName,
                      'image': urlFoto,
                      'price': int.parse(_price),
                      'uname': _username,
                      'mobilNo': int.parse(_mobileno),
                      'productDesc': _productDesc,
                      'address': _address,
                      'city':_city,
                }).then((value) => Navigator.of(context).pop())
                    .catchError((onError) =>
                    print('Error editing the recipe in the database'));
                _isInAsyncCall = false;
              });
            });
          });
        } else {
          Firestore.instance
              .collection('products')
              .add({
                    'productName': _productName,
                      'image': urlFoto,
                      'price': int.parse(_price),
                      'uname': _username,
                      'mobilNo': int.parse(_mobileno),
                      'productDesc': _productDesc,
                      'address': _address,
                      'city':_city,
          })
              .then((value) => Navigator.of(context).pop())
              .catchError(
                  (onError) => print('Error editing the recipe in the database'));
          _isInAsyncCall = false;
        }
      }).catchError((onError) => _isInAsyncCall = false);
    } else {
      print('object not validated');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Edit'),
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
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                      Container(
                          child: GestureDetector(
                            onDoubleTap: getImage,
                          ),
                          margin: EdgeInsets.only(top: 20),
                          height: 120,
                          width: 120,
                          decoration: box
                      )
                    ]),
                    Text('Double click to change image'),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _username,
                      decoration: InputDecoration(
                        labelText: 'Seller Name',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _username = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _productName,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _productName = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _productDesc,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _productDesc = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _price,
                      decoration: InputDecoration(
                        labelText: 'Product Price',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _price = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _mobileno,
                      decoration: InputDecoration(
                        labelText: 'Seller Mobile No.',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _mobileno = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _city,
                      decoration: InputDecoration(
                        labelText: 'City',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _city = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _address,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _address = value.trim(),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    )
                  ],
                ),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.greenAccent[400],
            onPressed: _enviar,
            child: Icon(Icons.edit)),
        bottomNavigationBar: BottomAppBar(
          elevation: 20.0,
          color: Colors.blue,
          child: ButtonBar(),
        ));
  }
}
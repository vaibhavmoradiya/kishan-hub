import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as img;
import 'package:kishan_hub/custom_app_bar.dart';
import 'package:kishan_hub/page/admin/full_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/model/product_model.dart';
import 'package:url_launcher/url_launcher.dart';

//create stf with the name ViewRecipe
class ViewProduct extends StatefulWidget {
  ViewProduct({this.product, this.idProduct, this.uid});
  final String idProduct;
  final String uid;
  final Product product;
  _ViewProductState createState() => _ViewProductState();
}

enum SelectSource { camara, galeria }

class _ViewProductState extends State<ViewProduct> {
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
      border: Border.all(width: 1.0, color: Colors.white),
      shape: BoxShape.rectangle,
      image: DecorationImage(
          fit: BoxFit.fill, image: AssetImage('images/ab.jpg')));

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

    print('uid recipe : ' + widget.idProduct);
    super.initState();
  }

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
            border: Border.all(width: 1.0, color: Colors.white),
            shape: BoxShape.rectangle,
            image: DecorationImage(fit: BoxFit.fill, image: FileImage(_image)));
      });
    } else {
      print('download the image');
      _downloadFile(url, widget.product.productName).then((onValue) {
        _image = onValue;
        setState(() {
          box = BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              image:
                  DecorationImage(fit: BoxFit.fill, image: FileImage(_image)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 10.0))
              ]);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          dismissible: false,
          progressIndicator: CircularProgressIndicator(),
          color: Colors.greenAccent[100],
          
          child: SingleChildScrollView(
            
            padding: EdgeInsets.only(left: 10, right: 15),
            child: Form(
              
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen(image:widget.product.image);
          }));
                          },
                          child:  SizedBox(
                            
                          child: AspectRatio(
                            
                            aspectRatio: 1,
                            child: Hero(
                              tag: widget.idProduct,
                              
                              child: Image.network(
                                widget.product.image,
                                loadingBuilder:
                                    (context, child, loadingProcess) {
                                  if (loadingProcess == null) {
                                    return child;
                                  }
                                  return CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Text('Some errors occurred!'),
                              ),
                            ),
                            //onDoubleTap: getImage,
                          ),
                          // margin: EdgeInsets.only(top: 10),
                          height: 250,
                          width: 330,
                          //  decoration: box,
                        ),

                        )
                       
                      ]),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _productName,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ])),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            _productDesc,
                            maxLines: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Row(children: [
                            Icon(FontAwesomeIcons.mapMarkerAlt, size: 14),
                            Text(" City: " + _city)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Row(children: [
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: 14,
                              color: Colors.greenAccent[700],
                            ),
                            Text(" " + _price)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Row(children: [
                            Icon(
                              FontAwesomeIcons.user,
                              size: 14,
                              color: Colors.blueAccent[700],
                            ),
                            Text(" " + _username)
                          ]),
                        ),
                        GestureDetector(
                          //padding: EdgeInsets.only(top: 10),
                          onTap: () {
                            launch('tel:$_mobileno');
                          },
                          child: Row(children: [
                            Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 14,
                                      color: Colors.greenAccent[700],
                                    ),
                                    Text(" " + _mobileno)
                                  ],
                                ))
                          ]),
                        ),
                      ],
                    ),
                  ),
                  // TextFormField(
                  //   enabled: false,
                  //   keyboardType: TextInputType.text,
                  //   initialValue: _productName,
                  //   decoration: InputDecoration(
                  //     labelText: 'Name',
                  //   ),
                  //   validator: (value) =>
                  //       value.isEmpty ? 'The Name field is empty' : null,
                  //   onSaved: (value) => _productName = value.trim(),
                  // ),
                  // TextFormField(
                  //   maxLines: 10,
                  //   enabled: false,
                  //   keyboardType: TextInputType.text,
                  //   initialValue: _productDesc,
                  //   decoration: InputDecoration(
                  //     labelText: 'Recipe',
                  //   ),
                  //   validator: (value) =>
                  //       value.isEmpty ? 'The Name field is empty' : null,
                  //   onSaved: (value) => _productDesc = value.trim(),
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.share),
                  //   onPressed: () {
                  //     // share(context,_name,_recipe);
                  //   },
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 5),
                  // )
                ],
              ),
            ),
          )),
     // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

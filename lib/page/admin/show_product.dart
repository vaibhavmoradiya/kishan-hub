import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/model/product_model.dart';
import 'package:kishan_hub/page/admin/add_product.dart';
import 'package:kishan_hub/page/admin/edit_product.dart';
import 'package:kishan_hub/page/admin/view_product.dart';

class CommonThings {
  static Size size;
}

TextEditingController nameInputController;
String id;
final db = Firestore.instance;
String name;

class ProductPage extends StatefulWidget {
  final String id;
  ProductPage({this.auth, this.onSignedOut, this.id});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String userID;
  

  //Widget content;

  @override
  void initState() {
    super.initState();

    setState(() {
      Auth().currentUser().then((onValue) {
        userID = onValue;

        print('user id $userID');
      });
     
    });
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    //print('Width of the screen: ${CommonThings.size.width}');

    return new Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('products')
            .where('uid', isEqualTo: widget.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            print(snapshot.data.documents.length);
         
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(15),
                      shape: BeveledRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '\nAdd a Product.\n',
                            style: TextStyle(fontSize: 24, color: Colors.blue),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              //print("from the streamBuilder: "+ snapshot.data.documents[]);
              // print(length.toString() + " doc length");

              return ListView(
                children: snapshot.data.documents.map((document) {
                  return Card(
                    elevation: 5.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              placeholder: AssetImage('images/ab.jpg'),
                              image: NetworkImage(document["image"]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              document['productName'].toString().toUpperCase(),
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 17.0,
                              ),
                            ),
                            subtitle: Row(children: [
                              Icon(
                                //  Icons.supervised_user_circle,
                                FontAwesomeIcons.rupeeSign,
                                size: 10,
                              ),
                              Text(
                                document['price'].toString().toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                              ),
                            ]),
                            //editar la receta
                            onTap: () {

 Product product = Product(
                              productName: document['productName'].toString(),
                              productDesc: document['productDesc'].toString(),
                              image: document['image'].toString(),
                              username: document['uname'].toString(),
                              address: document['address'].toString(),
                              city: document['city'].toString(),
                              mobileNo: document['mobilNo'],
                              price: document['price'],
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProduct(
                                        product: product,
                                        idProduct: document.documentID,
                                        uid: userID)));

                              
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            document.data.remove('key');
                            Firestore.instance
                                .collection('users/$userID/myproducts')
                                .document(document.documentID)
                                .delete();
                            print(document.documentID);

                            Firestore.instance
                                .collection('products')
                                .document(document.documentID)
                                .delete()
                                .then((value) => print("Deleted"));
                            FirebaseStorage.instance
                                .ref()
                                .child(
                                    'products/$userID/uid/${document['productName'].toString()}.jpg')
                                .delete()
                                .then((onValue) {
                              print('deleted photo');
                            });
                            var x = Firestore.instance.collection('users').document(widget.id);
                               x.updateData({'active':FieldValue.increment(-1)});
                          }, //funciona
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.share
                        //   ),
                        //   onPressed: (){
                        //    // share(context,document['name'].toString(),document['product'].toString());
                        //   },
                        //  Recipe recipe = Recipe(
                        //       name: document['name'].toString(),
                        //       image: document['image'].toString(),
                        //       recipe: document['recipe'].toString(),
                        //     );
                        // List<Alligator> alligators = [
                        //       Alligator(name: document['name'].toString(), description: document['recipe'].toString()),
                        // ];
                        // share(context,)

                        //     ),

                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),

                          //Visualizar la receta,
                          onPressed: () {
                          Product product = Product(
                                productName: document['productName'].toString(),
                                productDesc: document['productDesc'].toString(),
                                image: document['image'].toString(),
                                username: document['uname'].toString(),
                                address: document['address'].toString(),
                                city: document['city'].toString(),
                                mobileNo: document['mobilNo'],
                                price: document['price'],
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProduct(
                                          product: product,
                                          idProduct: document.documentID,
                                          uid: userID)));
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.greenAccent[400],
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => MyAddPage(id: userID,));
          Navigator.push(context, route);
        },
      ),
    );
  }
// share(BuildContext context, String s, String s1) {
//   final RenderBox box = context.findRenderObject();

//   Share.share("${s} - ${s1}",
//       subject: s1,
//       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
// }
}

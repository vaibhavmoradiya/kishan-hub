import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:kishan_hub/page/admin/view_product.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/model/product_model.dart';

class StoreBody extends StatefulWidget {
  @override
  _StoreBodyState createState() => _StoreBodyState();
}

class _StoreBodyState extends State<StoreBody> {
  String userID;
  //Widget content;

  @override
  void initState() {
    super.initState();

    setState(() {
      Auth().currentUser().then((onValue) {
        userID = onValue;
        print('el futuro Cheft $userID');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: StreamBuilder(
          stream: Firestore.instance.collection("products").snapshots(),
          // ignore: missing_return
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text("loading....");
            } else {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text("No data available"),
                );
              } else {
                return Container(
                    child: ListView(
                        children: snapshot.data.documents.map((document) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // height: 220,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.greenAccent[100],
                                  child: Text(
                                      document['uname'][0].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  maxRadius: 20.0,
                                  // backgroundImage: AssetImage("images/abc.png"),
                                  //backgroundImage: NetworkImage('https://www.atmeplay.com/images/users/avtar/avtar.png'),
                                  //  backgroundColor: Colors.white,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    document["uname"].toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      //   Icon(FontAwesomeIcons.rupeeSign, size: 10),
                                      Text(document["city"].toString())
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.arrowCircleRight,color: Colors.greenAccent[400],),
                                onPressed: () {
                                  Product product = Product(
                                    productName:
                                        document['productName'].toString(),
                                    productDesc:
                                        document['productDesc'].toString(),
                                    image: document['image'].toString(),
                                    username: document['uname'].toString(),
                                    address: document['address'].toString(),
                                    city: document['city'].toString(),
                                    mobileNo: document['mobilNo'].toString(),
                                    price: document['price'].toString(),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProduct(
                                              product: product,
                                              idProduct: document.documentID,
                                              uid: userID)));
                                },
                              )
                            ],
                          ),
                          GestureDetector(
                            child: Card(
                              //  alignment: Alignment.center,

                              child: Image.network(
                                document["image"],
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              
                                  Text(document["productName"],style: TextStyle(fontSize: 20),),
                                 
                                 Row(
                                   children: [
                                     Icon(
                                    FontAwesomeIcons.rupeeSign,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                              Text(
                                document["price"].toString(),
                                style: TextStyle(fontSize: 18,color: Colors.green),
                              ),
                                   ],
                                 )
                                   
                            ],
                          ),
                          )
                          
                        ],
                      ),
                    ),
                  );
                  // return Column(
                  //   children: <Widget>[
                  //     Row(

                  //       children: <Widget>[

                  //         Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Icon(Icons.account_circle, size: 40),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: <Widget>[
                  //             Text(document["uname"].toString(),
                  //             style: Theme.of(context).textTheme.headline
                  //             ),
                  //             Row(
                  //               children: <Widget>[
                  //              //   Icon(FontAwesomeIcons.rupeeSign, size: 10),
                  //                 Text(document["city"].toString())
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         Spacer(),
                  //         IconButton(
                  //           icon: Icon(FontAwesomeIcons.arrowCircleRight),
                  //           onPressed: () => {},
                  //         )
                  //       ],
                  //     ),
                  //     GestureDetector(
                  //       child: Stack(

                  //         alignment: Alignment.center,
                  //         children: <Widget>[
                  //           Padding(

                  //             padding: const EdgeInsets.only(bottom:10.0),
                  //             child: Image.network(document["image"])
                  //           ),

                  //         ],
                  //       ),
                  //     ),

                  //   ],
                  // );
                }).toList()));
              }
            }
          }),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       color: Colors.white,
//       child: StreamBuilder(
//         stream: Firestore.instance.collection("products").snapshots(),
//         // ignore: missing_return
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Text("loading....");
  //  } else {
  //    if (snapshot.data.documents.length == 0) {
  //    } else {
//               return Container(
//                 child: ListView(
//                   children: snapshot.data.documents.map((document) {
//                     return Row(
//                       children: <Widget>[
//                         new Container(
//                           padding: EdgeInsets.only(
//                               top: 2.0, left: 2.0, right: 2.0),
//                           child: ClipRRect(
//                             //recondea borde Foto dentro del Stack
//                             borderRadius: BorderRadius.circular(10.0),
//                             child: InkWell(
//                               onTap: () {
//                                 Product product = Product(
//                                   name: document['name'].toString(),
//                                   image: document['image'].toString(),
//                                   product: document['productName'].toString(),
//                                 );
//                                 //  Navigator.push(
//                                 //      context,
//                                 //      MaterialPageRoute(
//                                 //          builder: (context) => ViewRecipe(
//                                 //              recipe: recipe,
//                                 //              idRecipe:
//                                 //                  document.documentID,
//                                 //              uid: userID)));
//                               },
//                               child: Stack(
//                                 children: <Widget>[
//                                   Container(
//                                     padding: EdgeInsets.all(5.0),
//                                     child: ClipRRect(
//                                       borderRadius:
//                                       BorderRadius.circular(10),
//                                       child: FadeInImage(
//                                         fit: BoxFit.cover,
//                                         width: 340,
//                                         height: 220,
//                                         placeholder: AssetImage(
//                                             'images/ab.jpg'),
//                                         image: NetworkImage(
//                                             document["image"]),
//                                       ),
//                                     ),
//                                   ),
//                                   //borde para poner el la foto estrellas y titulo ...
//                                   // Positioned(
//                                   //   left: 10.0,
//                                   //   bottom: 10.0,
//                                   //   child: Container(
//                                   //     height: 40.0,
//                                   //     width: 325.0,
//                                   //     decoration: BoxDecoration(
//                                   //         gradient: LinearGradient(
//                                   //             colors: [
//                                   //               Colors.black,
//                                   //               Colors.black12
//                                   //             ],
//                                   //             begin: Alignment
//                                   //                 .bottomCenter,
//                                   //             end:
//                                   //             Alignment.topCenter)),
//                                   //   ),
//                                   // ),
//                                   Positioned(
//                                     left: 20.0,
//                                     right: 10.0,
//                                     bottom: 10.0,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment
//                                           .spaceBetween,
//                                       children: <Widget>[
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             Text(
//                                               document["productName"]
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 18.0,
//                                                   fontWeight:
//                                                   FontWeight.bold),
//                                             ), //
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
}

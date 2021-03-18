import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:http/http.dart' as http;

class MarketPricePage extends StatefulWidget {
  @override
  _MarketPricePageState createState() => _MarketPricePageState();
}


class _MarketPricePageState extends State<MarketPricePage> {
  String api;
  final String apiUrl =
      "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd00000157ab5a6b290a4637594fdf7f73eed503&format=json&filters[state]=Gujarat";
  String userID;

  Future<List<dynamic>> fetchData() async {
    // api =
    //     "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd00000157ab5a6b290a4637594fdf7f73eed503&format=json&offset=" +
    //         offset.toString() +
    //         "&limit=" +
    //         limit.toString() +
    //         "&filters[state]=Gujarat";
    var res = await http.get(apiUrl);

    return json.decode(res.body)['records'];

    // var res = await http.get(apiUrl);
    // return json.decode(res.body)['records'];
  }

  

  String _state(dynamic field) {
    return field['state'];
  }

  String _district(dynamic field) {
    return field['district'];
  }

  String _market(dynamic field) {
    return field['market'];
  }

  String _commodity(dynamic field) {
    return field['commodity'];
  }

  String _min_price(dynamic field) {
    return field['min_price'];
  }

  String _max_price(dynamic field) {
    return field['max_price'];
  }

  String _arrival_date(dynamic field) {
    return field['arrival_date'];
  }

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
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(_state(snapshot.data[0]));
              print(snapshot.data.length);
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  Text(_state(snapshot.data[index]),style: TextStyle(fontSize: 17),),
                          Text(
                            _district(snapshot.data[index]) +
                                "  (" +
                                _state(snapshot.data[index]) +
                                ")",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text("Market: " + _market(snapshot.data[index]))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _commodity(snapshot.data[index]),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text("Date: " + _arrival_date(snapshot.data[index]))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: 13,
                              color: Colors.greenAccent[700],
                            ),
                            Text(
                              _min_price(snapshot.data[index]) + " - ",
                              style: TextStyle(
                                color: Colors.greenAccent[700],
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: 13,
                              color: Colors.greenAccent[700],
                            ),
                            Text(
                              _max_price(snapshot.data[index]),
                              style: TextStyle(
                                color: Colors.greenAccent[700],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ));
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

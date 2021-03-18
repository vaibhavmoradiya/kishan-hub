import 'package:flutter/material.dart';
import 'package:kishan_hub/page/market%20price/screen/marketlist.dart';


class MyMarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: MarketPricePage(),
    );
  }
}
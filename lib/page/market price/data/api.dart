import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kishan_hub/page/market%20price/model/market.dart';

class MarketApi {
  Future<Market> getNowPlaying(int offset) async {
    var url =
        'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd00000157ab5a6b290a4637594fdf7f73eed503&format=json&filters[state]=Gujarat&offset='+offset.toString();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Get Data');
      return Market.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }
}
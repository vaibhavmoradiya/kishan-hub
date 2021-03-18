// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Market welcomeFromJson(String str) => Market.fromJson(json.decode(str));

String welcomeToJson(Market data) => json.encode(data.toJson());

class Market {
  Market({
    this.total,
    this.count,
    this.limit,
    this.offset,
    this.records,
  });

  int total;
  int count;
  String limit;
  String offset;
  List<Record> records;

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        total: json["total"],
        count: json["count"],
        limit: json["limit"],
        offset: json["offset"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "limit": limit,
        "offset": offset,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };

  static Market filterList(Market market, String filterString) {
    Market tempRecord;
    List<Record> _record = tempRecord.records
        .where((element) =>
            (element.district.toLowerCase().contains(filterString)) ||
            (element.market.toLowerCase().contains(filterString)))
        .toList();

    market.records = _record;
    return market;
  }
}

class Record {
  Record({
    this.timestamp,
    this.state,
    this.district,
    this.market,
    this.commodity,
    this.variety,
    this.arrivalDate,
    this.minPrice,
    this.maxPrice,
    this.modalPrice,
  });

  String timestamp;
  String state;
  String district;
  String market;
  String commodity;
  String variety;
  String arrivalDate;
  String minPrice;
  String maxPrice;
  String modalPrice;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        timestamp: json["timestamp"],
        state: json["state"],
        district: json["district"],
        market: json["market"],
        commodity: json["commodity"],
        variety: json["variety"],
        arrivalDate: json["arrival_date"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        modalPrice: json["modal_price"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "state": state,
        "district": district,
        "market": market,
        "commodity": commodity,
        "variety": variety,
        "arrival_date": arrivalDate,
        "min_price": minPrice,
        "max_price": maxPrice,
        "modal_price": modalPrice,
      };

  
}

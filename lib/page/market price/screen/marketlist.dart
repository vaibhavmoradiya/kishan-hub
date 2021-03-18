import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kishan_hub/page/market%20price/data/api.dart';
import 'package:kishan_hub/page/market%20price/model/market.dart';



class MarketPricePage extends StatefulWidget {
  @override
  _MarketPricePageState createState() => _MarketPricePageState();
}

class _MarketPricePageState extends State<MarketPricePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: FutureBuilder(
          future: MarketApi().getNowPlaying(0),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return new MovieList(
                market: s.data,
              );
          },
        ));
  }
}

class MovieList extends StatefulWidget {
  final Market market;
  const MovieList({
    this.market,
    Key key,
  }) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  ScrollController scrollController = new ScrollController();
  List<Record> marketData;
  int currentPage = 0;

  bool onNotificatin(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        print('End Scroll');
        currentPage += 1;
        MarketApi().getNowPlaying(currentPage).then((val) {
          setState(() {
            marketData.addAll(val.records);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    marketData = widget.market.records;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotificatin,
      child: ListView.builder(
          itemCount: marketData.length,
          controller: scrollController,
          itemBuilder: (BuildContext c, int i) {
            return Card(
                child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //  Text(_state(snapshot.data[index]),style: TextStyle(fontSize: 17),),
                    Text(marketData[i].district
                       +
                          "  (" +
                          marketData[i].state +
                          ")",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text("Market: " + marketData[i].market)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        marketData[i].commodity,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text("Date: " + marketData[i].arrivalDate)
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
                       marketData[i].minPrice + " - ",
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
                        marketData[i].maxPrice,
                        style: TextStyle(
                          color: Colors.greenAccent[700],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
          }),
    );
  }
}

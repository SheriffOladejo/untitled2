import 'dart:convert';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/adapters/market_adapter.dart';
import 'package:untitled2/models/candle_data.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/utils/db_helper.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();

}

class _MarketScreenState extends State<MarketScreen> {

  List<CandleData> market_list = [];
  List<CandleData> fav_list = [];

  var searchController = TextEditingController();

  bool isSearching = false;

  DbHelper dbHelper = DbHelper();

  bool is_loading = false;
  List<CandleData> search_list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Market", style: TextStyle(
          color: Colors.black,
          fontFamily: 'inter-bold',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15),
        child: is_loading ? Center(child: CircularProgressIndicator(),) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  searchSymbol(value.trim());
                  setState(() {
                    isSearching = true;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: isSearching ? GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.text = "";
                        isSearching  = false;
                      });
                    },
                    child: Icon(Icons.close),
                  ) : Container(width: 0,height: 0,),
                  hintText: 'Search e.g shiba-inu, ethereum-classic',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            isSearching ? Container(width: 0, height: 0,) :  Container(height: 15,),
            isSearching ? Container(width: 0, height: 0,) : fav_list.isEmpty ? Container(width: 0, height: 0,) : Text("Favorites", style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'inter-medium',
              fontWeight: FontWeight.w500,
            ),),
            isSearching ? Container(width: 0, height: 0,) : Container(height: 8,),
            isSearching ? Container(width: 0, height: 0,) : Container(
              height: fav_list.length > 4 ? 240 : double.parse((fav_list.length * 60).toString()),
              child: ListView.builder(
                itemCount: fav_list.length,
                shrinkWrap: true,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  return MarketAdapter(
                      data: fav_list[index],
                      isSearched: true,
                      callback: callback
                  );
                },
              ),
            ),
            isSearching ? Container(width: 0, height: 0,) : Text("All markets", style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'inter-medium',
              fontWeight: FontWeight.w500,
            ),),
            Container(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 45 - (230 + double.parse((fav_list.length * 60).toString())),
              child: ListView.builder(
                itemCount: isSearching ? search_list.length : market_list.length,
                shrinkWrap: true,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  return MarketAdapter(
                    data: isSearching ? search_list[index] : market_list[index],
                    isSearched: isSearching ? true : false,
                    callback: callback
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }

  Future<void> callback() async {
    fav_list = await dbHelper.getFavorites();
    setState(() {

    });
  }

  Future<void> getPrice() async {
    List<String> symbols = [];
    for (var i = 0; i < market_list.length; i++) {
      symbols.add("${market_list[i].symbol}USDT");
    }
    final jsonString = jsonEncode(symbols);
    final params = {
      "symbols": jsonString,
    };
    var url = Uri.https('api.binance.com', '/api/v3/ticker/24hr', params);
    var response = await http.get(url);
    if(response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var json = jsonDecode(response.body.toString());
        for (var i = 0; i < json.length; i++) {
          market_list[i].pct_change = double.parse(json[i]["priceChangePercent"]);
          market_list[i].price = double.parse(json[i]["lastPrice"]);
        }
        setState(() {

        });
      }
      else {
        print("no response");
      }
    }
    else {
      print("error in response: ${response.statusCode}");
    }
  }

  Future<void> init() async {
    market_list.addAll(
        [
          CandleData(
              symbol: "BTC",
              id: "bitcoin",
              name: "Bitcoin",
              image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
              pct_change: 0,
              price: 0
          ),
          CandleData(
            id: "ethereum",
            symbol: "ETH",
            name: "Ethereum",
            image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "ripple",
            symbol: "XRP",
            name: "Ripple",
            image: "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1605778731",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            symbol: "ADA",
            id: "cardano",
            name: "Cardano",
            image: "https://assets.coingecko.com/coins/images/975/large/cardano.png?1547034860",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "litecoin",
            symbol: "LTC",
            name: "Litecoin",
            image: "https://assets.coingecko.com/coins/images/2/large/litecoin.png?1547033580",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "bitcoin-cash",
            symbol: "BCH",
            name: "bitcoin-cash",
            image: "https://assets.coingecko.com/coins/images/780/large/bitcoin-cash-circle.png?1594689492",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "chainlink",
            symbol: "LINK",
            name: "Chainlink",
            image: "https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png?1547034700",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "avalanche-2",
            symbol: "AVAX",
            name: "Avalanche",
            image: "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png?1670992574",
            pct_change: 0,
            price: 0,
          ),
          CandleData(
            id: "solana",
            symbol: "SOL",
            name: "Solana",
            image: "https://assets.coingecko.com/coins/images/4128/large/solana.png?1640133422",
            pct_change: 0,
            price: 0,
          ),
        ]
    );
    setState(() {

    });
    fav_list = await dbHelper.getFavorites();
    await getPrice();
  }

  Future<void> searchSymbol(String symbol) async {
    final params = {
      "vs_currency": "usd",
      "order": "market_cap_desc",
      "ids": symbol,
      "per_page": "1",
      "page": "1",
      "sparkline": "false",
      "locale": "en",
    };
    setState(() {
      is_loading = true;
    });
    search_list.clear();
    var market_cap_url = Uri.https('api.coingecko.com', '/api/v3/coins/markets', params);
    var mResponse = await http.get(market_cap_url);
    if (mResponse.statusCode == 200) {
      if (mResponse.body.isNotEmpty) {
        print(mResponse.body.toString());
        var json = jsonDecode(mResponse.body.toString());
        List<dynamic> market_data = json;
        for (var i = 0; i < market_data.length; i++) {
          double price = double.parse(market_data[i]['current_price'].toString());
          double pct_change = double.parse(market_data[i]['price_change_percentage_24h'].toString());
          String name = market_data[i]['name'].toString();
          String image = market_data[i]['image'].toString();
          String id = market_data[i]['id'].toString();
          String symbol = market_data[i]['symbol'].toString();

          bool isFound = false;
          for (var i = 0; i < fav_list.length; i++) {
            if (fav_list[i].id == id) {
              isFound = true;
            }
          }

          if (!isFound) {
            search_list.add(CandleData(
              symbol: symbol.toUpperCase(),
              id: id,
              name: name,
              image: image,
              pct_change: pct_change,
              price: price,
              candle: Candle(
                  high: 0,
                  low: 0,
                  open: 0,
                  close: 0,
                  volume: 0,
                  date: DateTime.now()
              ),
              favorite: 'false',
              duration: '',
              candle_timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
              trading_vol: 0,
              twentyfour_low: 0,
              twentyfour_high: 0,
              total_supply: 0,
              max_supply: 0,
              market_cap_rank: 0,
              market_cap: 0,
              atl_date: '',
              ath_date: '',
              all_time_high: 0,
              all_time_low: 0,
            ));
          }
        }
        setState(() {
          isSearching = true;
          is_loading = false;
        });

      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}

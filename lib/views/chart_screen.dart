import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/models/candle_data.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/utils/methods.dart';

class ChartScreen extends StatefulWidget {

  CandleData data;

  ChartScreen({this.data});

  @override
  State<ChartScreen> createState() => _ChartScreenState();

}

class _ChartScreenState extends State<ChartScreen> {

  DbHelper db_helper = DbHelper();

  bool is_connected = false;
  bool is_loading = false;

  List<Candle> candle_list = [];
  List<CandleData> candle_data_list = [];

  String selected_symbol = "";
  String selected_duration = "1H";
  String interval = "1m";

  int selected_stat = 0;

  final String background_color = "#323e4c";
  final String selected_duration_color = "#ffffff";

  @override
  Widget build(BuildContext context) {
    print(widget.data.image);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          "${widget.data.name} (${widget.data.symbol})",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'inter-medium',
            fontSize: 24,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              getCandleData();
            },
            child: Icon(Icons.refresh, color: Colors.white, size: 24,),
          ),
          Container(width: 15,),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(widget.data.image, width: 32, height: 32,),
              Container(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "1H";
                        interval = "1m";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "1H" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "1H",
                          style: TextStyle(
                            fontFamily: 'inter-regular',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: selected_duration == "1H" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "24H";
                        interval = "30m";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "24H" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "24H",
                          style: TextStyle(
                              fontFamily: 'inter-regular',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: selected_duration == "24H" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "1W";
                        interval = "2h";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "1W" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "1W",
                          style: TextStyle(
                              fontFamily: 'inter-regular',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: selected_duration == "1W" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "1M";
                        interval = "8h";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "1M" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "1M",
                          style: TextStyle(
                              fontFamily: 'inter-regular',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: selected_duration == "1M" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "6M";
                        interval = "3d";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "6M" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "6M",
                          style: TextStyle(
                              fontFamily: 'inter-regular',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: selected_duration == "6M" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selected_duration = "1Y";
                        interval = "1w";
                      });
                      await getCandleDataSQLite();
                    },
                    child: CircleAvatar(
                      backgroundColor: selected_duration == "1Y" ? HexColor(selected_duration_color) : HexColor(background_color),
                      child: Center(
                        child: Text(
                          "1Y",
                          style: TextStyle(
                              fontFamily: 'inter-regular',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: selected_duration == "1Y" ? Colors.black : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 10,),
              is_loading ? SizedBox(height: 355, child: loadingPage()) : candle_list.isEmpty ? const SizedBox(
                height: 410,
                child: Center(child: Text("No chart data available", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'inter-medium',
                  fontSize: 16,
                ),)),
              ) : Expanded(child: Container(color: HexColor(background_color),child: Candlesticks(candles: candle_list))),
              Container(height: 8,),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 5,),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              selected_stat = 0;
                              setState(() {

                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                color: selected_stat == 0 ? HexColor("#000000") : Colors.white,
                              ),
                              child: Text("Price", style: TextStyle(
                                color: selected_stat == 0 ? Colors.white : Colors.black,
                                fontFamily: 'inter-medium',
                                fontSize: 14,
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selected_stat = 1;
                              setState(() {

                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 110,
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                color: selected_stat == 1 ? HexColor("#000000") : Colors.white,
                              ),
                              child: Text("Market cap", style: TextStyle(
                                color: selected_stat == 1 ? Colors.white : Colors.black,
                                fontFamily: 'inter-medium',
                                fontSize: 14,
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selected_stat = 2;
                              setState(() {

                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 110,
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                color: selected_stat == 2 ? HexColor("#000000") : Colors.white,
                              ),
                              child: Text("Supply", style: TextStyle(
                                color: selected_stat == 2 ? Colors.white : Colors.black,
                                fontFamily: 'inter-medium',
                                fontSize: 14,
                              )),
                            ),
                          ),
                        ]
                    ),
                    Container(height: 15,),
                    Text("Statistics", style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'inter-bold',
                      fontWeight: FontWeight.w600,
                    ),),
                    Container(height: 10,),
                    selected_stat == 0 ? priceWidget() : selected_stat == 1 ? marketCapWidget() : supplyWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Price", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$""${widget.data.price}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'inter-medium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.data.pct_change < 0 ? Icons.arrow_downward : Icons.arrow_upward, color: widget.data.pct_change < 0 ? Colors.red : Colors.green, size: 12,),
                      Text(
                        "${widget.data.pct_change}%",
                        style: TextStyle(
                          color: widget.data.pct_change < 0 ? Colors.red : Colors.green,
                          fontSize: 10,
                          fontFamily: 'inter-bold',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Trading volume", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.trading_vol}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("24h low / 24h high", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("\$${widget.data.twentyfour_low} / \$${widget.data.twentyfour_high}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All time low", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("\$${widget.data.all_time_low}", style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                  ),),
                  Text(
                    "${widget.data.atl_date}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontFamily: 'inter-medium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All time high", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("\$${widget.data.all_time_high}", style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                  ),),
                  Text(
                    "${widget.data.ath_date}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontFamily: 'inter-medium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(height: 10,),
        ],
      ),
    );
  }

  Widget supplyWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Circulating supply", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.circulating_supply}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Max supply", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.max_supply}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total supply", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.total_supply}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
        ],
      ),
    );
  }

  Widget marketCapWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Market cap", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.market_cap}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Market cap rank", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
              Text("${widget.data.market_cap_rank}", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
          Container(height: 10,),
        ],
      ),
    );
  }

  Future<void> getCandleData() async {
    is_connected = await checkConnection();
    if(is_connected){
      setState(() {
        is_loading = true;
      });
      try{
        final params = {
          "symbol": "${widget.data.symbol}USDT",
          "interval": interval,
        };
        //print("home_screen.getCandleData params ${params.toString()}");

        // vs_currency=btc&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en

        double price = 0;
        double pct_change = 0;
        double trading_vol = 0;
        double twentyfour_low = 0;
        double twentyfour_high = 0;
        double all_time_high = 0;
        double all_time_low = 0;
        double circulating_supply = 0;
        double total_supply = 0;
        double max_supply = 0;
        double market_cap = 0;
        int market_cap_rank = 0;
        String atl_date = "null";
        String ath_date = "null";

        final market_params = {
          "vs_currency": "usd",
          "order": "market_cap_desc",
          "ids": widget.data.id,
          "per_page": "1",
          "page": "1",
          "sparkline": "false",
          "locale": "en",
        };
        var market_cap_url = Uri.https('api.coingecko.com', '/api/v3/coins/markets', market_params);
        var mResponse = await http.get(market_cap_url);
        if (mResponse.statusCode == 200) {
          if (mResponse.body.isNotEmpty) {
            print(mResponse.body.toString());
            var json = jsonDecode(mResponse.body.toString());
            List<dynamic> market_data = json;
            price = double.parse(market_data[0]['current_price'].toString());
            pct_change = double.parse(market_data[0]['price_change_percentage_24h'].toString());
            trading_vol = double.parse(market_data[0]['total_volume'].toString());
            twentyfour_low = double.parse(market_data[0]['low_24h'].toString());
            twentyfour_high = double.parse(market_data[0]['high_24h'].toString());
            all_time_low = double.parse(market_data[0]['atl'].toString());
            all_time_high = double.parse(market_data[0]['ath'].toString());
            circulating_supply = double.parse(market_data[0]['circulating_supply'].toString());
            total_supply = double.parse(market_data[0]['total_supply'].toString());
            market_cap = double.parse(market_data[0]['market_cap'].toString());
            market_cap_rank = market_data[0]['market_cap_rank'];
            atl_date = market_data[0]['atl_date'];
            ath_date = market_data[0]['ath_date'];

            final DateTime atl = DateTime.parse(atl_date);
            final DateTime ath = DateTime.parse(ath_date);

            final DateFormat formatter = DateFormat.yMMM();
            final String atl_ = formatter.format(atl);
            final String ath_ = formatter.format(ath);

            atl_date = atl_;
            ath_date = ath_;

            max_supply = market_data[0]['max_supply'];
          }
        }
        else {
          print("chart_screen.getCandleData mResponse error: ${mResponse.body}");
        }

        var url = Uri.https('api.binance.com', '/api/v3/klines', params);
        var response = await http.get(url);
        if(response.statusCode == 200){
          if(response.body.isNotEmpty){
            var json = jsonDecode(response.body.toString());
            List<dynamic> values = json;
            candle_data_list.clear();
            candle_list.clear();
            await db_helper.clearCandleTable();
            print(response.body.toString());
            for(var i = values.length-1; i>0; i--){
              List<dynamic> candle_data = values[i];
              DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(candle_data[6].toString()));
              double open = double.parse(candle_data[1].toString());
              double close = double.parse(candle_data[4].toString());
              double high = double.parse(candle_data[2].toString());
              double low = double.parse(candle_data[3].toString());
              double volume = double.parse(candle_data[5].toString());

              Candle candle = Candle(
                  high: high,
                  low: low,
                  open: open,
                  close: close,
                  volume: volume,
                  date: date
              );
              CandleData data = CandleData(
                candle_timestamp: candle_data[6].toString(),
                candle: candle,
                duration: selected_duration,
                symbol: widget.data.symbol,
                name: widget.data.name,
                image: widget.data.image,
                id: widget.data.id,
                price: price,
                pct_change: pct_change,
                trading_vol: trading_vol,
                twentyfour_high: twentyfour_high,
                twentyfour_low: twentyfour_low,
                all_time_low: all_time_low,
                all_time_high: all_time_high,
                circulating_supply: circulating_supply,
                total_supply: total_supply,
                market_cap: market_cap,
                market_cap_rank: market_cap_rank,
                ath_date: ath_date,
                atl_date: atl_date,
                max_supply: max_supply,
              );
              widget.data = data;
              candle_data_list.add(data);
              await db_helper.saveCandleData(data);
            }
            //print("home_screen.getCandleData candle list is ${candle_data_list.length}");
            if(candle_data_list.isNotEmpty){
              for(var i = 0; i < candle_data_list.length; i++){
                candle_list.add(candle_data_list[i].candle);
              }
            }
            setState(() {
              is_loading = false;
            });
          }
        }
        else{
          setState(() {
            is_loading = false;
          });
          showToast("An error occurred");
          print("chart_screen.getCandleData response error: ${response.body}");
        }
      }
      catch(e){
        print("chart_screen.getCandleData exception error: ${e.toString()}");
        showToast("An error occurred");
        setState(() {
          is_loading = false;
        });
      }
    }
  }

  Future<void> getCandleDataSQLite() async {
    is_connected = await checkConnection();
    setState(() {
      is_loading = true;
    });
    candle_data_list = await db_helper.getCandleData(selected_symbol, selected_duration);
    if(candle_data_list.isNotEmpty){
      candle_list.clear();
      for(var i = 0; i < candle_data_list.length; i++){
        candle_list.add(candle_data_list[i].candle);
      }
    }
    else{
      getCandleData();
    }
    setState(() {
      is_loading = false;
    });
  }

  Future<void> init() async {
      await getCandleDataSQLite();
  }

  @override
  void initState(){
    super.initState();
    init();
  }

}

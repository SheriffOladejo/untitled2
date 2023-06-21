import 'package:candlesticks/candlesticks.dart';

class CandleData{
  Candle candle = Candle(
    high: 0,
    low: 0,
    open: 0,
    close: 0,
    volume: 0,
    date: DateTime.now()
  );
  String favorite = 'false';
  String symbol = '';
  String id = '';
  String name = '';
  String image = '';
  String duration = '';
  String candle_timestamp = '';
  double price = 0;
  double pct_change = 0;
  double trading_vol = 0;
  double twentyfour_low = 0;
  double twentyfour_high = 0;
  double all_time_low = 0;
  double all_time_high = 0;
  String atl_date = '';
  String ath_date = '';
  double max_supply = 0;
  double circulating_supply = 0;
  double total_supply = 0;
  double market_cap = 0;
  int market_cap_rank = 0;


  CandleData({
    this.favorite,
    this.candle,
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.duration,
    this.candle_timestamp,
    this.price,
    this.pct_change,
    this.trading_vol,
    this.twentyfour_low,
    this.twentyfour_high,
    this.all_time_high,
    this.all_time_low,
    this.circulating_supply,
    this.total_supply,
    this.market_cap,
    this.market_cap_rank,
    this.ath_date,
    this.atl_date,
    this.max_supply,
  });

}
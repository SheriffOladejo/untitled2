import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled2/models/candle_data.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/methods.dart';
import 'package:candlesticks/candlesticks.dart';

class DbHelper {
  DbHelper._createInstance();

  String db_name = "walletApp.db";

  static Database _database;
  static DbHelper helper;

  String wallet_table = "wallet_table";
  String col_wallet_id = "id";
  String col_wallet_seed = "seed";
  String col_wallet_passphrase = "passphrase";
  String col_wallet_password = "password";
  String col_wallet_hex = "hex";

  String candle_data_table = "chart_data_table";
  String col_candle_id = "id";
  String col_candle_name = "name";
  String col_candle_fav = "favorite";
  String col_high = "high";
  String col_low = "low";
  String col_open = "open";
  String col_close = "close";
  String col_volume = "volume";
  String col_candle_date = "date";
  String col_candle_symbol = "symbol";
  String col_candle_image = "image";
  String col_candle_duration = "duration";
  String col_candle_price = "price";
  String col_candle_pct_change = "pct_change";
  String col_candle_trading_vol = "trading_vol";
  String col_candle_twentyfour_low = "twentyfour_low";
  String col_candle_twentyfour_high = "twentyfour_high";
  String col_candle_all_time_low = "all_time_low";
  String col_candle_all_time_high = "all_time_high";
  String col_candle_circulating_supply = "circulating_supply";
  String col_candle_total_supply = "total_supply";
  String col_candle_market_cap = "market_cap";
  String col_candle_market_cap_rank = "market_cap_rank";
  String col_candle_ath_date = "ath_date";
  String col_candle_atl_date = "atl_date";
  String col_candle_max_supply = "max_supply";


  Future createDb(Database db, int version) async {
    String create_wallet_table = "create table $wallet_table ("
        "$col_wallet_id integer primary key autoincrement,"
        "$col_wallet_passphrase text,"
        "$col_wallet_hex text,"
        "$col_wallet_password text,"
        "$col_wallet_seed text)";

    String create_candle_table = "create table $candle_data_table ("
        "id text,"
        "high double,"
        "low double,"
        "open double,"
        "close double,"
        "volume double,"
        "symbol varchar(10),"
        "image text,"
        "name text,"
        "ath_date varchar(12),"
        "atl_date varchar(12),"
        "favorite varchar(12),"
        "max_supply double,"
        "duration varchar(10),"
        "date varchar(100),"
        "price double,"
        "pct_change double,"
        "trading_vol double,"
        "twentyfour_low double,"
        "twentyfour_high double,"
        "all_time_low double,"
        "all_time_high double,"
        "circulating_supply double,"
        "total_supply double,"
        "market_cap double,"
        "market_cap_rank integer)";

    await db.execute(create_wallet_table);
    await db.execute(create_candle_table);
  }

  factory DbHelper(){
    if(helper == null){
      helper = DbHelper._createInstance();
    }
    return helper;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    final db_path = await getDatabasesPath();
    final path = join(db_path, db_name);
    return await openDatabase(path, version: 1, onCreate: createDb);
  }

  Future<void> clearCandleTable() async {
    Database db = await database;
    String query = "delete from $candle_data_table where $col_candle_fav != 'true'";
    await db.execute(query);
  }

  Future<void> deleteFavorite(String id) async {
    Database db = await database;
    String query = "delete from $candle_data_table where $col_candle_fav = 'true' and $col_candle_id = '$id'";
    await db.execute(query);
  }

  Future<List<CandleData>> getFavorites() async {
    List<CandleData> list = [];
    Database db = await database;
    String query = "select * from $candle_data_table where $col_candle_fav='true'";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for(var i = 0; i<result.length; i++){
      Candle candle = Candle(
          open: result[i][col_open],
          close: result[i][col_close],
          high: result[i][col_high],
          low: result[i][col_low],
          volume: result[i][col_volume],
          date: DateTime.now()
      );
      CandleData data = CandleData(
        candle: candle,
        id: result[i][col_candle_id].toString(),
        candle_timestamp: result[i][col_candle_date].toString(),
        favorite: result[i][col_candle_fav].toString(),
        duration: result[i][col_candle_duration],
        symbol: result[i][col_candle_symbol],
        name: result[i][col_candle_name],
        image: result[i][col_candle_image],
        price: result[i][col_candle_price],
        pct_change: result[i][col_candle_pct_change],
        trading_vol: result[i][col_candle_trading_vol],
        twentyfour_low: result[i][col_candle_twentyfour_low],
        twentyfour_high: result[i][col_candle_twentyfour_high],
        all_time_high: result[i][col_candle_all_time_high],
        all_time_low: result[i][col_candle_all_time_low],
        circulating_supply: result[i][col_candle_circulating_supply],
        total_supply: result[i][col_candle_total_supply],
        market_cap: result[i][col_candle_market_cap],
        market_cap_rank: result[i][col_candle_market_cap_rank],
        max_supply: result[i][col_candle_max_supply],
        ath_date: result[i][col_candle_ath_date],
        atl_date: result[i][col_candle_atl_date],
      );
      list.add(data);
      //print("db_helper.getCandleData duration ${data.duration} symbol ${data.symbol}");
    }

    return list;
  }

  Future<List<CandleData>> getCandleData(String symbol, String duration) async {
    List<CandleData> list = [];
    Database db = await database;
    String query = "select * from $candle_data_table where $col_candle_symbol='$symbol' and $col_candle_duration='$duration' order by $col_candle_id ASC";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for(var i = 0; i<result.length; i++){
      String date_format = "";
      if(result[i][col_candle_duration] == "1H"){
        date_format = "hh:mm aa";
      }
      else if(result[i][col_candle_duration] == "24H"){
        date_format = "hh:mm aa";
      }
      else if(result[i][col_candle_duration] == "1W"){
        date_format = "MMM dd";
      }
      else if(result[i][col_candle_duration] == "1M"){
        date_format = "MMM dd";
      }
      else if(result[i][col_candle_duration] == "6M"){
        date_format = "MMM dd";
      }
      else if(result[i][col_candle_duration] == "1Y"){
        date_format = "MMM dd YYYY";
      }

      Candle candle = Candle(
          open: result[i][col_open],
          close: result[i][col_close],
          high: result[i][col_high],
          low: result[i][col_low],
          volume: result[i][col_volume],
          date: DateTime.fromMillisecondsSinceEpoch(int.parse(result[i][col_candle_date].toString()))
      );
      CandleData data = CandleData(
        candle: candle,
        id: result[i][col_candle_id].toString(),
        candle_timestamp: result[i][col_candle_date].toString(),
        name: result[i][col_candle_name].toString(),
        duration: result[i][col_candle_duration],
        symbol: result[i][col_candle_symbol],
        image: result[i][col_candle_image],
        price: result[i][col_candle_price],
        pct_change: result[i][col_candle_pct_change],
        trading_vol: result[i][col_candle_trading_vol],
        twentyfour_low: result[i][col_candle_twentyfour_low],
        twentyfour_high: result[i][col_candle_twentyfour_high],
        all_time_high: result[i][col_candle_all_time_high],
        all_time_low: result[i][col_candle_all_time_low],
        circulating_supply: result[i][col_candle_circulating_supply],
        total_supply: result[i][col_candle_total_supply],
        market_cap: result[i][col_candle_market_cap],
        market_cap_rank: result[i][col_candle_market_cap_rank],
        max_supply: result[i][col_candle_max_supply],
        ath_date: result[i][col_candle_ath_date],
        atl_date: result[i][col_candle_atl_date],
        favorite: result[i][col_candle_fav],
      );
      list.add(data);
      //print("db_helper.getCandleData duration ${data.duration} symbol ${data.symbol}");
    }

    return list;
  }

  Future<void> saveCandleData(CandleData candle) async {
    Database db = await database;
    String query = "insert into $candle_data_table ("
        "$col_candle_id, $col_candle_name, $col_open, $col_close, $col_high, $col_low, $col_candle_date, $col_volume, $col_candle_symbol, $col_candle_duration, "
        "$col_candle_price, $col_candle_pct_change, $col_candle_trading_vol, $col_candle_twentyfour_low, "
        "$col_candle_twentyfour_high, $col_candle_all_time_low, $col_candle_all_time_high, "
        "$col_candle_circulating_supply, $col_candle_total_supply, $col_candle_market_cap, $col_candle_market_cap_rank, $col_candle_image, "
        "$col_candle_ath_date, $col_candle_atl_date, $col_candle_max_supply, $col_candle_fav) "
        "values ('${candle.id}', '${candle.name}',  ${candle.candle.open}, ${candle.candle.close}, ${candle.candle.high}, ${candle.candle.low}, "
        "'${candle.candle_timestamp.toString()}', ${candle.candle.volume}, '${candle.symbol}', '${candle.duration}', "
        "${candle.price}, ${candle.pct_change}, ${candle.trading_vol}, ${candle.twentyfour_low}, ${candle.twentyfour_high}, "
        "${candle.all_time_low}, ${candle.all_time_high}, ${candle.circulating_supply}, ${candle.total_supply}, "
        "${candle.market_cap}, ${candle.market_cap_rank}, '${candle.image}', '${candle.ath_date}', "
        "'${candle.atl_date}', ${candle.max_supply}, '${candle.favorite}')";
    await db.execute(query);
  }

  Future<bool> saveWallet(Wallet wallet) async {
    Database db = await database;
    String query = "insert into $wallet_table ($col_wallet_hex, $col_wallet_password, "
        "$col_wallet_seed, $col_wallet_passphrase) values ('${wallet.hex}', '${wallet.password}', "
        "'${wallet.seed}', '${wallet.passphrase}')";
    try {
      await db.execute(query);
      return true;
    }
    catch(e) {
      print("db_helper.saveWallet error: ${e.toString()}");
      showToast("Wallet not saved");
      return false;
    }
  }

  Future<bool> deleteWallet(Wallet wallet) async {
    Database db = await database;
    String query = "delete from $wallet_table where $col_wallet_id = ${wallet.id}";
    try {
      await db.execute(query);
      return true;
    }
    catch(e) {
      print("db_helper.deleteWallet error: ${e.toString()}");
      showToast("Wallet not deleted");
      return false;
    }
  }

  Future<List<Wallet>> getWallets() async {
    List<Wallet> wallets = [];
    Database db = await database;
    String query = "select * from $wallet_table";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for (int i = 0; i < result.length; i++) {
      Wallet w = Wallet(
        id: int.parse(result[i][col_wallet_id].toString()),
        seed: result[i][col_wallet_seed].toString(),
        password: result[i][col_wallet_password].toString(),
        hex: result[i][col_wallet_hex].toString(),
        passphrase: result[i][col_wallet_passphrase].toString(),
      );
      wallets.add(w);
    }
    return wallets;
  }

}
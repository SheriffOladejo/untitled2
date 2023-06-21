import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:untitled2/adapters/wallet_adapter.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/views/secret_phrase.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  PersistentTabController _controller;

  List<Wallet> wallet_list = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Wallets", style: TextStyle(
          color: Colors.black,
          fontFamily: 'inter-bold',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return WalletAdapter(num: index + 1, wallet: wallet_list[index], callback: callback,);
          },
          itemCount: wallet_list.length,
          shrinkWrap: true,
          controller: ScrollController(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SecretPhrase(callback: callback,)));
        },
        backgroundColor: HexColor("#000000"),
        child: Image.asset("assets/images/scan.png", color: Colors.white, width: 24, height: 24,),
      ),
    );
  }

  Future<void> callback() async {
    DbHelper db = DbHelper();
    wallet_list = await db.getWallets();
    setState(() {

    });
  }

  Future<void> init () async {
    _controller = PersistentTabController(initialIndex: 0);
    DbHelper db = DbHelper();
    wallet_list = await db.getWallets();
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}

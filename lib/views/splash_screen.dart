import 'package:flutter/material.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/views/get_started_screen.dart';
import 'package:untitled2/views/bottom_nav.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        color: HexColor("#ffffff"),
        child: Center(
            child: Image.asset("assets/images/trezor.png", width: 200, height: 200,)
        ),
      ),
    );
  }

  Future init() async {
    Future.delayed(const Duration(seconds: 2), () async {
      DbHelper db = DbHelper();
      List<Wallet> l = await db.getWallets();
      if (l.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStartedScreen()));
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
      }
    });
  }

  @override
  void initState(){
    super.initState();
    init();
  }

}

import 'package:flutter/material.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/views/secret_phrase.dart';

class GetStartedScreen extends StatefulWidget {

  const GetStartedScreen({Key key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();

}

class _GetStartedScreenState extends State<GetStartedScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_get_started.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 70,),
            Image.asset("assets/images/_icon.png", width: 100, height: 100,),
            Container(height: MediaQuery.of(context).size.height / 2.2,),
            Text("Trezor wallet", style: TextStyle(
              color: Colors.white,
              fontFamily: 'inter-bold',
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),),
            Container(height: 30,),
            Text("Keep your digital assets secured", style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'inter-medium',
            ),),
            Container(height: 20,),

          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 20),
        child: MaterialButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SecretPhrase(callback: null,)));
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))
          ),
          elevation: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 10,),
              Image.asset("assets/images/scan.png", width: 24, height: 24,),
              Container(width: 10,),
              const Text("Connect Ledger", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-medium',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
              Container(width: 10,),
            ],
          ),
        ),
      ),
    );
  }

}

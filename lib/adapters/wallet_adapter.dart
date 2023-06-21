import 'package:flutter/material.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/utils/methods.dart';
import 'package:untitled2/views/secret_phrase.dart';
import 'package:untitled2/views/view_secret_phrase.dart';

class WalletAdapter extends StatefulWidget {
  int num;
  Wallet wallet;
  Function callback;
  WalletAdapter({this.num, this.wallet, this.callback});

  @override
  State<WalletAdapter> createState() => _WalletAdapterState();
}

class _WalletAdapterState extends State<WalletAdapter> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            useSafeArea: false,
            context: context,
            builder: (ctx) => AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                content: OptionsDialog(wallet: widget.wallet, callback: widget.callback,)));
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: HexColor("#F9F9FE"),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 15,
            ),
            Image.asset(
              "assets/images/wallet.png",
              width: 24,
              height: 24,
            ),
            Container(
              width: 10,
            ),
            Text(
              "Wallet ${widget.num}",
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'inter-regular',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 180,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  useSafeArea: false,
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(0),
                    content: OptionsDialog(wallet: widget.wallet, callback: widget.callback,)));
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionsDialog extends StatefulWidget {

  Wallet wallet;
  Function callback;

  OptionsDialog({this.callback, this.wallet});

  @override
  State<OptionsDialog> createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSecretPhrase(wallet: widget.wallet,)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 88,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: HexColor("#F9F9FE"),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 15,
                  ),
                  Image.asset("assets/images/eye.png"),
                  Container(
                    width: 10,
                  ),
                  const Text(
                    "Secret phrase",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'inter-regular',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 5,
          ),
          InkWell(
            onTap: () async {
              showToast("Deleting");
              DbHelper db = DbHelper();
              await db.deleteWallet(widget.wallet);
              Navigator.pop(context);
              await widget.callback();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 88,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: HexColor("#F9F9FE"),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 15,
                  ),
                  Image.asset("assets/images/unlink.png"),
                  Container(
                    width: 10,
                  ),
                  const Text(
                    "Disconnect wallet",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'inter-regular',
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/utils/methods.dart';

class ViewSecretPhrase extends StatefulWidget {

  Wallet wallet;
  ViewSecretPhrase({this.wallet});

  @override
  State<ViewSecretPhrase> createState() => _ViewSecretPhraseState();

}

class _ViewSecretPhraseState extends State<ViewSecretPhrase> {

  bool is_password_visible = false;
  bool is_password_focus = false;

  TextEditingController seed_controller = TextEditingController();
  TextEditingController private_key_controller = TextEditingController();
  TextEditingController passphrase_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
        body: seed()
    );
  }

  Widget seed() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Secret phrase", style: TextStyle(
            color: Colors.black,
            fontFamily: 'inter-bold',
            fontSize: 24,
          ),),
          Container(height: 8,),
          const Text("", style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'inter-regular',
          ),),
          Container(height: 15,),
          const Text("Seed phrase",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'inter-regular',
            ),),
          Container(height: 8,),
          TextFormField(
            validator: (val){
              if(val != null){
                if(val.toString().isEmpty) {
                  return "Required";
                }
                return null;
              }
              return null;
            },
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'inter-regular'
            ),
            readOnly: true,
            controller: seed_controller,
            minLines: 5,
            maxLines: 7,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              focusedBorder: focusedBorder(),
              enabledBorder: enabledBorder(),
              errorBorder: errorBorder(),
              disabledBorder: disabledBorder(),
              filled: true,
              fillColor: HexColor("#F9F9FE"),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: MaterialButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.wallet.seed));
                showToast("Seed copied to clipboard");
              },
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              color: HexColor("#ECE5FB"),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/copy.png", width: 20, height: 20, color: Colors.black,),
                  Container(width: 5,),
                  const Text(
                    "Copy secret phrase",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'inter-regular'
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> init() async {
    seed_controller.text = widget.wallet.seed;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}

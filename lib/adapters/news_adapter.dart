import 'package:flutter/material.dart';
import 'package:untitled2/models/news.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/utils/methods.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsAdapter extends StatefulWidget {

  News news;

  NewsAdapter({
    this.news,
  });

  @override
  State<NewsAdapter> createState() => _NewsAdapterState();

}

class _NewsAdapterState extends State<NewsAdapter> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.news.image,
              width: MediaQuery.of(context).size.width,
            ),
            Container(height: 5,),
            Text(widget.news.title, style: const TextStyle(
                color: Colors.black,
                fontFamily: 'solata-bold',
                fontSize: 16
            ),),
            Container(height: 5,),
            Text(widget.news.text, style: const TextStyle(
                color: Colors.black,
                fontFamily: 'solata-regular',
                fontSize: 12
            ),),
            Container(height: 8,),
            Text(widget.news.date, style: const TextStyle(
                color: Colors.black,
                fontFamily: 'solata-regular',
                fontSize: 10
            ),),
            Container(height: 8,),
            Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      if(await canLaunch(widget.news.url)){
                        await launch(widget.news.url);
                      }
                      else{
                        showToast("Cannot launch URL");
                      }
                    },
                    child: Image.asset("assets/images/export.png", width: 30, height: 30,)
                ),
                Container(width: 0,),
                GestureDetector(
                  onTap: () async {
                    if(await canLaunch(widget.news.url)){
                      await launch(widget.news.url);
                    }
                    else{
                      showToast("Cannot launch URL");
                    }
                  },
                  child: Text("Read on ${widget.news.source_name}", style: TextStyle(
                      color: HexColor("#8051B4"),
                      fontSize: 10,
                      fontFamily: 'solata-regular'
                  ),),
                )
              ],
            ),
            Container(height: 5,),
            const Divider(),
          ],
        )

    );
  }

}
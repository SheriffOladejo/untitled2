import 'package:flutter/material.dart';
import 'package:untitled2/models/candle_data.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/methods.dart';
import 'package:untitled2/views/chart_screen.dart';

class MarketAdapter extends StatefulWidget {

  CandleData data;
  Function callback;
  bool isSearched = false;
  MarketAdapter({this.data, this.callback, this.isSearched});

  @override
  State<MarketAdapter> createState() => _MarketAdapterState();

}

class _MarketAdapterState extends State<MarketAdapter> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, slideLeft(ChartScreen(data: widget.data,)));
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        elevation: 3,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.isSearched ?
              InkWell(
                onTap: () async {
                  if (widget.data.favorite == 'true') {
                    widget.data.favorite = 'false';
                    DbHelper db = DbHelper();
                    db.deleteFavorite(widget.data.id);
                    setState(() {

                    });
                    await widget.callback();
                  }
                  else {
                    widget.data.favorite = 'true';
                    DbHelper db = DbHelper();
                    db.saveCandleData(widget.data);
                    setState(() {

                    });
                    await widget.callback();
                  }

                },
                child: Icon(widget.data.favorite == 'true' ? Icons.star : Icons.star_border,
                color: widget.data.favorite == 'true' ? Colors.yellow : Colors.grey, size: 18,),
              ) : Container(width: 0, height: 0,),
              widget.isSearched ? Container(width: 8,) : Container(width: 0, height: 0,),
              Image.network(widget.data.image, width: 24, height: 24,),
              Container(width: 5,),
              Text(widget.data.name, style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'inter-medium',
              ),),
              Container(width: 110,),
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
        ),
      ),
    );
  }

}

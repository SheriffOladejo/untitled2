import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:untitled2/adapters/news_adapter.dart';
import 'package:untitled2/models/news.dart';
import 'package:untitled2/utils/methods.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  static const page_size = 20;

  final PagingController<int, News> paging_controller = PagingController(firstPageKey: 1);

  List<News> news_list = [];

  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    if (is_loading) {
      return loadingPage();
    }
    return mainPage();
  }

  Future<void> getNews(int page_key) async {

    try {
      List<News> newItems = [];

      var params = {
        "section": "general",
        "items": "$page_size",
        "page": "$page_key",
        "token": "ehknk7n0mbedffhy3zuh8uo77s8jsuzn6jjhngnb"
      };
      var url = Uri.http("cryptonews-api.com", "api/v1/category", params);
      var response = await http.get(url);
      print(response.body.toString());
      final json = jsonDecode(response.body.toString());
      List<dynamic> data = json["data"];
      for (int i = 0; i < data.length; i++) {
        List<String> list = data[i]["date"].toString().split(" ");
        String date = "";
        for (int i = 0; i < 4; i++) {
          date += "${list[i]} ";
        }
        newItems.add(News(
          image: data[i]["image_url"],
          title: data[i]["title"],
          text: data[i]["text"],
          source_name: data[i]["source_name"],
          url: data[i]["news_url"],
          date: date,
        ));
      }

      news_list.addAll(newItems);

      final isLastPage = newItems.length < page_size;
      if (isLastPage) {
        paging_controller.appendLastPage(newItems);
      } else {
        final nextPageKey = page_key + newItems.length;
        paging_controller.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      paging_controller.error = error;
    }
  }

  void init() async {
    paging_controller.addPageRequestListener((pageKey) {
      getNews(pageKey);
    });
    await getNews(1);
    setState(() {

    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Widget mainPage() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(

            padding: const EdgeInsets.all(15),
            child: Text("Crypto news", style: TextStyle(
      color: Colors.black,
      fontFamily: 'inter-bold',
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),),
          ),
          Expanded(child: PagedListView<int, News>(
            pagingController: paging_controller,
            builderDelegate: PagedChildBuilderDelegate<News>(
              itemBuilder: (context, item, index) => NewsAdapter(
                news: news_list[index],
              ),
            ),
          )),
        ],
      ),
    );
  }

}

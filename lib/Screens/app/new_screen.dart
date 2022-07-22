import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thai_news/components/background.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<MapDataFromUrl> dataList = [];
  bool statusLoadData = false;

  void fecthData() async {
    statusLoadData = true;
    setState(() {});
    var uri = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=th&apiKey=f9106fef8409441a9e0c3f59a2f69601");

    try {
      var response = await http.get(uri);
      if (response.statusCode != 200) {
        return;
      }
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      dataList = (responseJson["articles"] as List)
          .map((e) => MapDataFromUrl.fromJson(e))
          .toList();
      statusLoadData = false;
      setState(() {});
      print(responseJson["articles"]);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    fecthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thailand News'),
        backgroundColor: kPrimaryColor,
      ),
      body: statusLoadData
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Gap(10),
                      Card(
                        margin: EdgeInsets.all(15),
                        child: Image.network('${dataList[index].urlToImage}'),
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Align(
                          child: Text(
                            '${dataList[index].title}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Align(
                          child: Text(
                            '${dataList[index].description}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fecthData();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class MapDataFromUrl {
  String title;
  String description;
  String urlToImage;

  MapDataFromUrl(
      {required this.title,
      required this.description,
      required this.urlToImage});

  factory MapDataFromUrl.fromJson(Map<String, dynamic> json) => MapDataFromUrl(
      title: json["title"] ?? "ไม่มีข้อมูล",
      description: json["description"] ?? "ไม่มีข้อมูล",
      urlToImage: json["urlToImage"] ??
          "https://notebookspec.com/web/wp-content/uploads/2022/07/Cover20220714-AW-Lenovo-BF-GDN-DPA_CoverBlog-1000x500-.jpg");
}

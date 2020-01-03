import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_new/model/model.dart';
import 'package:signature_new/webview.dart';

import 'dart:convert';

class Spk extends StatefulWidget {
  @override
  _SpkState createState() => _SpkState();
}

class _SpkState extends State<Spk> {
  List<ModelSpk> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("http://172.16.15.234/api_spk/index.php/spk");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new ModelSpk.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebVieww(
                                      spk: list[index].spk,
                                      nomor: list[index].nomor,
                                    )));
                      },
                      child: Card(
                        elevation: 6.0,
                        child: ListTile(
                          leading: new Icon(
                            Icons.assessment,
                            size: 50.0,
                          ),
                          title: new Text(list[index].nama),
                          subtitle: new Text(list[index].nomor),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}

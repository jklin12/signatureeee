import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature_new/spk.dart';
import 'package:signature_new/model/modeldsb.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<ModelDsb> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("http://172.16.15.234/spk/api/itemdsb.php");
    if (response.statusCode == 200) {
      /*list = json.decode(response.body);
      print(response);*/
      list = (json.decode(response.body) as List)
          .map((data) => new ModelDsb.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  itemCount: list.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 150.0,
                      height: 150.0,
                      child: Card(
                        color: Color.fromRGBO(0, 196, 180, 1),
                        elevation: 6.0,
                        child: Column(
                          children: <Widget>[
                            Icon(list[index].icn,
                                size: 75.0,
                                color: Color.fromRGBO(0, 69, 71, 1)),
                            Text(
                              list[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 69, 71, 1)),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}

_menuItem(BuildContext context) {
  return Container(
    width: 150.0,
    height: 150.0,
    child: Card(
      color: Color.fromRGBO(0, 196, 180, 1),
      elevation: 6.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Spk()));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.assessment,
                  size: 75.0, color: Color.fromRGBO(0, 69, 71, 1)),
              Text(
                "SPK",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 69, 71, 1)),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

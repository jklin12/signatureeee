import 'package:flutter/material.dart';
import 'package:signature_new/spk.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_menuItem(context), _menuItem(context)],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_menuItem(context), _menuItem(context)],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_menuItem(context), _menuItem(context)],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

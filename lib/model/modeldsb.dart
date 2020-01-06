import 'package:flutter/cupertino.dart';

class ModelDsb {
  final String title;
  final String icn;
  final String url;

  ModelDsb._({this.title, this.icn, this.url});

  factory ModelDsb.fromJson(Map<String, dynamic> json) {
    return new ModelDsb._(
      title: json['title'],
      icn: json['icon'],
      url: json['url'],
    );
  }
}
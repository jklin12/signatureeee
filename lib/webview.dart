import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

class WebVieww extends StatefulWidget {
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebVieww> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var _signatureCanvas = Signature(
    height: 290.0,
    backgroundColor: Colors.white,
  );

  static final String uploadEndPoint =
      'http://202.169.224.206/~jdnvp/ttd/upload.php';

  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';
  String nullImg =
      'iVBORw0KGgoAAAANSUhEUgAAAOgAAAEiCAYAAADzrZ4eAAAAAXNSR0IArs4c6QAAAARzQklUCAgICHwIZIgAAAEcSURBVHic7cExAQAAAMKg9U9tB2+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXgMcngABCceSLQAAAABJRU5ErkJggg==';

  var data;

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (nullImg == base64Image) {
      setStatus(errMessage);
      popup(context, "Tanda Tangan Tidak Ada!");
      print(errMessage);
      return;
    }
    String fileName = 'abcc.png';
    //print(base64Image);
    print(base64Image);
    print(nullImg);
    upload(fileName);
    upload(base64Image);
  }

  upload(String fileName) async {
    final response = await http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    });
    final abc = jsonDecode(response.body);
    int value = abc["value"];
    String pesan = abc["massage"];
    if (value == 1) {
      print(pesan);
      Navigator.pop(context);
      popup(context, "Sukses !");
    } else {
      Navigator.pop(context);
      popup(context, "Upload Gagal! ");
    }
  }

  ontabbb(
    BuildContext context,
    String title,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          content: SingleChildScrollView(
            child: Container(
              height: 400.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(title),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  _signatureCanvas,
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.check),
                            color: Colors.blue,
                            onPressed: () async {
                              data = await _signatureCanvas.exportBytes();
                              base64Image = base64.encode(data);
                              startUpload();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                return _signatureCanvas.clear();
                              });
                            },
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SPK")),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ListTile(
                    title: Text('TTD PELANGGAN'),
                    onTap: () {
                      ontabbb(
                        context,
                        "TTD PELANGGAN",
                      );
                    }),
              ),
              ListTile(
                title: Text('TTD KOORDINATOR IKR '),
                onTap: () {
                  ontabbb(
                    context,
                    "TTD PELAKSANA IKR",
                  );
                },
              ),
              ListTile(
                title: Text('TTD PELAKSANA'),
                onTap: () {
                  ontabbb(
                    context,
                    "TTD PELAKSANA",
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height ,
          width: MediaQuery.of(context).size.width ,
          child: Builder(
            builder: (BuildContext context) {
              return WebView(
                initialUrl: 'http://202.169.224.10/spk/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              );
            },
          ),
        ));
  }
}

popup(BuildContext context, String title) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(),
        actions: <Widget>[
          FlatButton(
            child: Text('Kembali'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

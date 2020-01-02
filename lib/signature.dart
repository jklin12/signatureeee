import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class SignatureWindow extends StatefulWidget {
  @override
  _SignatureWindowState createState() => _SignatureWindowState();
}

class _SignatureWindowState extends State<SignatureWindow> {
  var _signatureCanvas = Signature(
    height: 300,
    backgroundColor: Colors.white,
  );

  static final String uploadEndPoint =
      'http://202.169.224.206/~jdnvp/ttd/upload.php';

  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';
  String nullImg =
      'iVBORw0KGgoAAAANSUhEUgAAAWgAAAEsCAYAAADuLCmvAAAAAXNSR0IArs4c6QAAAARzQklUCAgICHwIZIgAAAG6SURBVHic7cExAQAAAMKg9U9tDQ+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIBHA5kGAAGsmxQQAAAAAElFTkSuQmCC';

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
      popup(context, "Sukses !");
    } else {
      popup(context, "Upload Gagal! ");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _signatureCanvas,
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
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

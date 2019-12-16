import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';
import 'dart:convert';

class SignatureWindow extends StatefulWidget {
  @override
  _SignatureWindowState createState() => _SignatureWindowState();
}

class _SignatureWindowState extends State<SignatureWindow> {
    var _signatureCanvas = Signature(
    height: 300,
    backgroundColor: Colors.lightBlueAccent,
  );

  static final String uploadEndPoint =
      'http://202.169.224.206/~jdnvp/ttd/upload.php';

  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';

  var data;

    setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == data) {
      setStatus(errMessage);
      print(errMessage);
      return;
    }
    String fileName = data.path.split('/').last;
    print(fileName);
  }

    upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
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
                  //SIGNATURE CANVAS
                  _signatureCanvas,
                  //OK AND CLEAR BUTTONS
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          //SHOW EXPORTED IMAGE IN NEW ROUTE
                          IconButton(
                            icon: const Icon(Icons.check),
                            color: Colors.blue,
                            onPressed: () async {
                               data = await _signatureCanvas.exportBytes();
                               startUpload();
                               /*base64Image =  base64.encode(data);
                               print(base64Image);*/
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: Container(
                                        color: Colors.grey[300],
                                        child: Image.memory(data),                                        
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          //CLEAR CANVAS
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
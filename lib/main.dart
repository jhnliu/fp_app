// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fp_app/logFoodView.dart';
import 'package:fp_app/user_nutrient.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'foodCatelogView.dart';
import 'foodModel.dart';
import 'foodDetailsView.dart';
import 'foodFormView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'foodpicker',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File selectedImage;
  Future<List<Food>> food_data;
  String selectedFoodLabel;
  String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("foodpicker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 30.0),
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/foodpicker_banner.png'),
              height: 100.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cameraButton(context),
                  RaisedButton(
                      color: Colors.green[200],
                      child: Text('食物表',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodCatelog()));
                      }),
                  RaisedButton(
                      color: Colors.orange[200],
                      child: Text('營養值',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserNutrient()));
                      }),
                  RaisedButton(
                      color: Colors.red[200],
                      child: Text('加食物',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogFood()));
                      })
                ],
              ),
            ),
            FutureBuilder(
              future: food_data,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
                if (snapshot.hasData) {
                  List<Food> foods = snapshot.data;
                  return foodOption(context, foods);
                } else {
                  return Center(child: Text('請拍下你想買的食物'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget cameraButton(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        Icons.camera_alt_outlined,
        size: 50,
        color: Colors.black,
      ),
      fillColor: Colors.white,
      shape: CircleBorder(side: BorderSide(color: Colors.green[500])),
      padding: EdgeInsets.all(10),
      elevation: 10,
      onPressed: () async {
        await getImage();
        print(basename(selectedImage.path));
        setState(() {
          food_data = submitFood(
              file: selectedImage, filename: basename(selectedImage.path));
        });
      },
    );
  }

  Widget foodOption(BuildContext context, foods) {
    return Column(
      children: [
        Container(
            height: 240.0,
            width: 200,
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    color: Colors.white,
                    child: Text('${foods[index].chiName}'),
                    onPressed: () async {
                      setState(() {
                        fileName = foods[index].fileName;
                        selectedFoodLabel = foods[index].label;
                      });
                      sendFoodLabel(selectedFoodLabel, fileName);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FoodDataPage(
                                    data: foods[index],
                                    // food_index: index,
                                    fileName: fileName,
                                    label: selectedFoodLabel,
                                  )));
                      // setState(() {
                      //   food_data = null;
                      // });
                    },
                  ),
                );
              },
            )),
        Container(
          width: 200.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.orange),
            ),
            color: Colors.white,
            child: Text('其他'),
            onPressed: () {
              setState(() {
                fileName = foods[1].fileName;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodForm(
                          fileName: fileName,
                        )),
              );
              // sendFoodLabel("Other", fileName);
              // print('Choosed Others');
            },
          ),
        )
      ],
    );
  }

  // Get image from camera
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {
      selectedImage = image;
    });
  }

  Future<List<Food>> submitFood({File file, String filename}) async {
    // Multipart request
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://10.0.2.2:8000/fp/predict/"));
    // 'POST',Uri.parse("http://128.199.169.10/fp/predict/"));
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'sentFile',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.headers.addAll(headers);
    request.fields.addAll({"name": "sentFile"});

    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print(response.statusCode);
    if (response.statusCode != 200) {
      return null;
    } else {
      List<dynamic> body = jsonDecode(response.body);
      List<Food> foods = body
          .sublist(0, 5)
          .map((dynamic item) => Food.fromJson(item))
          .toList();
      print(response.body);
      return foods;
    }
  }

  Future sendFoodLabel(label, fileName) async {
    final String url = 'http://10.0.2.2:8000/fp/name_photo/';
    // final String url = 'http://128.199.169.10/fp/name_photo/';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.headers.addAll(headers);
    request.fields.addAll({
      "old_name": fileName,
      "new_name": label,
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Renamed image");
    } else {
      print('Failed to load');
    }
  }
}

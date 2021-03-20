import 'package:flutter/material.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

import 'foodModel.dart';
import 'foodRepository.dart';

class FoodForm extends StatefulWidget {
  final String fileName;
  FoodForm({Key key, this.fileName}) : super(key: key);

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final _formKey = GlobalKey<FormState>();
  String labelName;
  Repository repo = Repository();
  List<String> _types = ["Choose a Food Type"];
  List<String> _food = ["Choose .."];
  String _selectedType = "Choose a Food Type";
  String _selectedFood = "Choose ..";

  @override
  void initState() {
    _types = List.from(_types)..addAll(repo.getType());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Insert New Food'),
          // centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('幫幫手🥺話我聽您影緊咩:)', style: TextStyle(fontSize: 30)),
                  SizedBox(height: 30),
                  Text('食物種類',
                      style: TextStyle(fontSize: 20, color: Colors.grey[500])),
                  DropdownButton(
                      isExpanded: true,
                      items: _types.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem));
                      }).toList(),
                      onChanged: (value) => _onSelectedType(value),
                      value: _selectedType),
                  Text('食物',
                      style: TextStyle(fontSize: 20, color: Colors.grey[500])),
                  DropdownButton(
                      isExpanded: true,
                      items: _food.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem));
                      }).toList(),
                      onChanged: (value) => _onSelectedFood(value),
                      value: _selectedFood),
                  // Text(widget.fileName),
                  Text(
                    '或',
                    style: TextStyle(fontSize: 40, color: Colors.grey[500]),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.emoji_food_beverage),
                      labelText: '其他食物名',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a value.';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      labelName = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                        sendFoodLabel(widget.fileName, labelName);
                        Navigator.pop(context);
                      },
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
            )));
  }

  Future sendFoodLabel(oldName, newName) async {
    final String url = 'http://10.0.2.2:8000/fp/name_other/';
    // final String url = 'http://128.199.169.10/fp/name_photo/';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.headers.addAll(headers);
    request.fields.addAll({
      "old_name": oldName,
      "new_name": newName,
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Renamed image");
    } else {
      throw Exception('Failed to load');
    }
  }

  void _onSelectedType(String value) {
    setState(() {
      _selectedFood = "Choose ..";
      _food = ["Choose .."];
      _selectedType = value;
      _food = List.from(_food)..addAll(repo.getFoodByTypeForForm(value));
    });
  }

  void _onSelectedFood(String value) {
    setState(() {
      _selectedFood = value;
      labelName = value;
    });
  }
}

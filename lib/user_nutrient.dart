import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'foodModel.dart';

class UserNutrient extends StatefulWidget {
  @override
  _UserNutrientState createState() => _UserNutrientState();
}

class _UserNutrientState extends State<UserNutrient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrient Status')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text('Your nutrient status', style: TextStyle(fontSize: 25)),
          ),
          Expanded(
            flex: 3,
            // height: MediaQuery.of(context).size.width*0.6,
            // width: MediaQuery.of(context).size.width*0.6,
            child: FutureBuilder(
                future: nut_status(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Nutrient nutrients = snapshot.data;
                    var features = nutrients.toJson().keys.toList();
                    List<List<int>> nut_vals = [
                      nutrients.toJson().values.toList()
                    ];
                    const ticks = [0, 100];
                    return RadarChart.light(
                        ticks: ticks, features: features, data: nut_vals);
                  } else {
                    return Text('Something went wrong');
                  }
                }),
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder(
                future: retrieve_log(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Food> nutrients = snapshot.data;
                    var food_log = nutrients;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          dataRowHeight: 50,
                          columns: [
                            DataColumn(
                                label: Text(
                              'Date',
                              style: TextStyle(fontSize: 32),
                            )),
                            DataColumn(
                                label: Text(
                              'Food',
                              style: TextStyle(fontSize: 32),
                            ))
                          ],
                          rows: nutrients
                              .map((food_log) => DataRow(cells: [
                                    DataCell(Text(
                                      food_log.type,
                                      style: TextStyle(fontSize: 24),
                                    )),
                                    DataCell(Text(
                                      food_log.label,
                                      style: TextStyle(fontSize: 22),
                                    ))
                                  ]))
                              .toList()),
                    );
                  } else {
                    return Text('Something went wrong');
                  }
                }),
          ),
        ],
      ),
    );
  }

// TO BE REFINED
  static Future nut_status() async {
    final response = await http.get('http://10.0.2.2:8000/fp/nut_status/');
    if (response.statusCode != 200) {
      print('Could not get food');
    } else {
      return Nutrient.fromJson(jsonDecode(response.body));
    }
  }

  static Future retrieve_log() async {
    final response = await http.get('http://10.0.2.2:8000/fp/check_food_log/');
    if (response.statusCode != 200) {
      print('Could not get food');
    } else {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Food.fromJson(item)).toList();
      // return Nutrient.fromJson(jsonDecode(response.body));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fp_app/foodRepository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'foodDetailsView.dart';
import 'foodModel.dart';

class FoodListItem extends StatelessWidget {
  String chosenCategory;
  Repository repo = Repository();

  FoodListItem({this.chosenCategory});

  @override
  Widget build(BuildContext context) {
    List _foodList = repo.getFoodByType(chosenCategory);

    return Scaffold(
      appBar: AppBar(title: Text('Food List')),
      body: ListView.builder(
        itemCount: _foodList.length,
        itemBuilder: (BuildContext context, index) => Column(
          children: [
            ListTile(
              title: Text(_foodList[index][0]),
              onTap: () async {
                print(_foodList[index][1]);
                print('ok');
                //get food details first
                Food food = await getFoodDetails(_foodList[index][1]);
                print(food.type);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FoodDataPage(
                              // We need to pass the food_ID or name here
                              data: food,
                            )));
              },
            ),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }

  Future<Food> getFoodDetails(String engName) async {
    final response = await http.get('http://10.0.2.2:8000/fp/food_detail/$engName');
    // final response = await http.get('http://128.199.169.10/fp/food_detail/$engName');

    if (response.statusCode != 200) {
      print('Could not get food');
    } else {
      return Food.fromJson(jsonDecode(response.body));
    }
  }
}

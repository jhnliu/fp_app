import 'package:flutter/material.dart';
import 'package:fp_app/0unused_foodCatelogSpecies.dart';
import 'package:fp_app/foodList.dart';

class FoodCatelog extends StatefulWidget {
  @override
  _FoodCatelogState createState() => _FoodCatelogState();
}

class _FoodCatelogState extends State<FoodCatelog> {
  List categories = ['肉類', '魚及海鮮', '蔬菜', '生果', '參茸海味'];
  String chosenCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Scaffold(
            appBar: AppBar(
              title: Text('食物清單'),
            ),
            body: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext context, index) =>
                    categoryButton(index))));
  }

  Widget categoryButton(index) {
    List<Color> colors = [
      Colors.red[200],
      Colors.blue[200],
      Colors.green[200],
      Colors.orange[200],
      Colors.purple[200]
    ];

    return Container(
      padding: EdgeInsets.all(20),
      height: 120,
      width: 300,
      child: RaisedButton(
          color: colors[index],
          child: Text(categories[index]),
          onPressed: () {
            print("Pressed Species.");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodListItem(
                          chosenCategory: categories[index],
                        )));
          }),
    );
  }
}

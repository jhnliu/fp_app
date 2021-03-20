import 'package:flutter/material.dart';
import 'dart:core';
import 'foodModel.dart';

class FoodDataPage extends StatefulWidget {
  // We are using the data downloaded from the prediction phase
  final Food data;
  // final int food_index;
  final String fileName;
  final String label;

  FoodDataPage({
    this.data,
    // this.food_index,
    this.fileName,
    this.label,
  });

  @override
  _FoodDataPageState createState() => _FoodDataPageState();
}

class _FoodDataPageState extends State<FoodDataPage> {
  bool is_visible = false;
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fp - foodPage'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Text(
                  '${widget.data.chiName} - ${widget.data.foodId}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 36.0),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            // Text(fileName),
            // Text(label),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Image(
                image: AssetImage(
                  'assets/images/shark.jpg',
                ),
                height: 150.0,
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                title: Text(
                  '挑選方法',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500),
                ),
                trailing: _editButton(context),
              ),
              Divider(
                thickness: 3.0,
              ),
              widget.data.tips != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ListView.builder(
                        itemCount: widget.data.tips.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _foodTips(context, index, widget.data);
                        },
                      ))
                  : Container(
                    child: Text('There is no tips for this food.')
                  ),
            ]),
          ],
        ),
        textEditBox(context, widget.data),
      ]),
    );
  }

  Widget _foodTips(BuildContext context, index, Food data) {
    return SizedBox(
      // height:60
      child: ListTile(
        leading: Icon(Icons.star),
        title: Text(
          '${data.tips[index]}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    return IconButton(icon: Icon(Icons.edit), onPressed: showBox);
  }

  Widget textEditBox(BuildContext context, Food data) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: is_visible,
      child: Container(
        height: 150,
        width: 300,
        color: Colors.green,
        child: Column(
          children: [
            Text('Food Content'),
            // Text('${data.appearance}'),
            TextField(
              controller: myController),
            RaisedButton(
                child: Text('Submit your description'), onPressed: hideBox)
          ],
        ),
      ),
    );
  }

  void showBox() {
    setState(() {
      is_visible = true;
    });
  }

  void hideBox() {
    setState(() {
      is_visible = false;
    });
    
  }
}

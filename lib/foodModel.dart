// class Food2 {
//   String chiName;
//   int id;
//   String foodId;
//   String type;
//   String engName;
//   String label;
//   List<String> appearance;
//   String touch;
//   String fileName;

//   Food2({
//     this.chiName,
//     this.id,
//     this.foodId,
//     this.type,
//     this.engName,
//     this.label,
//     this.appearance,
//     this.touch,
//     this.fileName,
//   });

//   factory Food2.fromJson(Map<String, dynamic> json) {
//     var appearanceFromJson = json['appearance'];
//     List<String> appearanceList = new List<String>.from(appearanceFromJson);

//     return Food2(
//       chiName: json["chiName"],
//       id: json["ID"],
//       foodId: json["food_id"],
//       type: json["type"],
//       engName: json["engName"],
//       label: json["label"],
//       appearance: appearanceList,
//       touch: json["touch"],
//       fileName: json["fileName"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "chiName": chiName,
//         "ID": id,
//         "food_id": foodId,
//         "type": type,
//         "engName": engName,
//         "label": label,
//         "appearance": appearance,
//         "touch": touch,
//         "fileName": fileName,
//       };
// }

class Nutrient {
    Nutrient({
        // this.id,
        this.fibre,
        this.protein,
        this.iron,
        this.vitaminA,
    });

    // String id;
    int fibre;
    int protein;
    int iron;
    int vitaminA;

    factory Nutrient.fromJson(Map<String, dynamic> json) => Nutrient(
        // id: json["_id"],
        fibre: json["fibre"],
        protein: json["protein"],
        iron: json["iron"],
        vitaminA: json["vitamin_a"],
    );

    Map<String, int> toJson() => {
        // "_id": id,
        "fibre": fibre,
        "protein": protein,
        "iron": iron,
        "vitamin_a": vitaminA,
    };
}

// Food foodFromJson(String str) => Food.fromJson(json.decode(str));

// String foodToJson(Food data) => json.encode(data.toJson());

class Food {
    Food({
        this.foodId,
        this.stage,
        this.id,
        this.type,
        this.chiName,
        this.engName,
        this.label,
        this.protein,
        this.fat,
        this.fibre,
        this.iron,
        this.iodine,
        this.magnesium,
        this.potassium,
        this.sodium,
        this.vitaminB2,
        this.vitaminB12,
        this.vitaminC,
        this.calcium,
        this.zinc,
        // this.preformedVitaminA,
        // this.provitaminA,
        this.vitaminA,
        this.tips,
    });

    String foodId;
    String stage;
    dynamic id;
    String type;
    String chiName;
    String engName;
    String label;
    double protein;
    double fat;
    double fibre;
    double iron;
    double iodine;
    double magnesium;
    double potassium;
    double sodium;
    double vitaminB2;
    double vitaminB12;
    double vitaminC;
    double calcium;
    double zinc;
    // double preformedVitaminA;
    // double provitaminA;
    double vitaminA;
    List<String> tips;

    factory Food.fromJson(Map<String, dynamic> json) {
      var tipsFromJson = json["tips"] == null ? null:json['tips'];
      List<String> tipsList = new List<String>.from(tipsFromJson);
      
      return Food(
        foodId: json["food_id"],
        stage: json["Stage"] == null ? null:json["Stage"],
        id: json["ID"] == null ? null:json["ID"],
        type: json["type"],
        chiName: json["chiName"] == null ? null:json["chiName"],
        engName: json["engName"] == null ? null:json["engName"],
        label: json["label"] == null ? null:json["label"],
        protein: json["protein"] == null ? null: json["protein"].toDouble(),
        fat: json["fat"] == null ? null: json["fat"].toDouble(),
        fibre: json["fibre"] == null ? null:json["fibre"].toDouble(),
        iron: json["iron"] == null ? null:json["iron"].toDouble(),
        iodine: json["iodine"] == null ? null: json["iodine"].toDouble(),
        magnesium: json["magnesium"] == null ? null: json["magnesium"].toDouble(),
        potassium: json["potassium"] == null ? null: json["potassium"].toDouble(),
        sodium: json["sodium"] == null ? null: json["sodium"].toDouble(),
        vitaminB2: json["vitamin_b2"] == null ? null: json["vitamin_b2"].toDouble(),
        vitaminB12: json["vitamin_b12"] == null ? null: json["vitamin_b12"].toDouble(),
        vitaminC: json["vitamin_c"] == null ? null: json["vitamin_c"].toDouble(),
        calcium: json["calcium"] == null ? null: json["calcium"].toDouble(),
        zinc: json["zinc"] == null ? null: json["zinc"].toDouble(),
        // preformedVitaminA: json["preformed_vitamin_a"],
        // provitaminA: json["provitamin_a"],
        vitaminA: json["vitamin_a"] == null ? null: json["vitamin_a"].toDouble(),
        tips: tipsList,
    );
    }

    Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "Stage": stage,
        "ID": id,
        "type": type,
        "chiName": chiName,
        "engName": engName,
        "label": label,
        "protein": protein,
        "fat": fat,
        "fibre": fibre,
        "iron": iron,
        "iodine": iodine,
        "magnesium": magnesium,
        "potassium": potassium,
        "sodium": sodium,
        "vitamin_b2": vitaminB2,
        "vitamin_b12": vitaminB12,
        "vitamin_c": vitaminC,
        "calcium": calcium,
        "zinc": zinc,
        // "preformed_vitamin_a": preformedVitaminA,
        // "provitamin_a": provitaminA,
        "vitamin_a": vitaminA,
        "tips": tips,
    };
}

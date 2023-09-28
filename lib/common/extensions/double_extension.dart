extension DoubleExtension on double {
  String get formatRatingNumber {
    String value = toString();

    if(!value.contains(".")) return value; /// if value like int: 0 , 1 , 2,...

    if(value.contains(".0")) { /// if value value like: 1.0, 2.0323, 3.00000, 4.00024,...
      return toInt().toString();
    } else { /// if value like: 1.2, 2.45534, 3.54353
      return toStringAsFixed(1);
    }
  }
}
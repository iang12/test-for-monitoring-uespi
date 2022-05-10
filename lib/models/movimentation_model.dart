enum TypeMovimentation {
  deposit,
  saque,
}

class MovimentationModel {
  final DateTime date;
  final String title;
  final TypeMovimentation typeMovimentation;
  final double value;
  MovimentationModel({
    required this.date,
    required this.title,
    required this.typeMovimentation,
    required this.value,
  });
}

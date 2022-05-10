import 'dart:math';

import 'package:flutter/material.dart';
import 'package:teste_monitoria_app/models/movimentation_model.dart';

class HomeController extends ValueNotifier<List<MovimentationModel>> {
  HomeController() : super([]);
  final saldo = ValueNotifier<double>(0.0);
  void movimentation({
    required double valueDeposit,
    required TypeMovimentation typeMovimentation,
  }) {
    value = List.from(value);
    value.add(
      MovimentationModel(
        date: generateRandomDate(),
        title: typeMovimentation == TypeMovimentation.deposit
            ? 'Depósito'
            : 'Saque',
        value: valueDeposit,
        typeMovimentation: typeMovimentation,
      ),
    );
    if (typeMovimentation == TypeMovimentation.deposit) {
      saldo.value += valueDeposit;
    } else {
      saldo.value -= valueDeposit;
    }
  }

  DateTime generateRandomDate() {
    var randomValue = Random();
    var year = randomValue.nextInt(DateTime.now().year - 2000);
    var month = randomValue.nextInt(12 - 1);
    var day = randomValue.nextInt(30 - 1);

    return DateTime(year + 2000, month, day);
  }
}

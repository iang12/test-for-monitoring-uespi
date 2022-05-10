import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomMoneyTextFild extends StatefulWidget {
  final TextEditingController controller;
  final CurrencyTextInputFormatter formatter;
  const CustomMoneyTextFild({
    Key? key,
    required this.controller,
    required this.formatter,
  }) : super(key: key);

  @override
  State<CustomMoneyTextFild> createState() => _CustomMoneyTextFildState();
}

class _CustomMoneyTextFildState extends State<CustomMoneyTextFild> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[widget.formatter],
      validator: (value) {
        var money = widget.formatter.getUnformattedValue();
        if (value!.isEmpty) {
          return 'Campo Obrigatorio';
        }
        if (money <= 0) {
          return 'Valor inválido';
        }
        return null;
      },
      controller: widget.controller,
      decoration: const InputDecoration(
        label: Text('Valor'),
        hintText: '0,00',
      ),
    );
  }
}

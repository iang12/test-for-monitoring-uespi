import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/movimentation_model.dart';
import '../widgets/custom_money_textfield.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();

  final amountController = TextEditingController();
  final money = NumberFormat("#,##0.00", "pt_BR");

  final formKey = GlobalKey<FormState>();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$', locale: 'pt_BR');
  void showCustomDialog(TypeMovimentation typeMovimentation) {
    showDialog(
      context: context,
      builder: (_) {
        var titleMovimentation = typeMovimentation == TypeMovimentation.deposit
            ? 'déposito'
            : 'saque';
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Informe um valor para o $titleMovimentation'),
                CustomMoneyTextFild(
                  controller: amountController,
                  formatter: _formatter,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var valueMovimentation =
                      _formatter.getUnformattedValue().toDouble();
                  if (titleMovimentation == 'déposito') {
                    homeController.movimentation(
                        valueDeposit: valueMovimentation,
                        typeMovimentation: TypeMovimentation.deposit);
                  }
                  if (titleMovimentation == 'saque') {
                    if (valueMovimentation > homeController.saldo.value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Você não tem saldo suficiente para esse saque.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      homeController.movimentation(
                        valueDeposit: valueMovimentation,
                        typeMovimentation: TypeMovimentation.saque,
                      );
                    }
                  }
                  Navigator.pop(context);
                  amountController.clear();
                }
              },
              child: Text('Efetuar  $titleMovimentation '),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                amountController.clear();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder<List<MovimentationModel>>(
          valueListenable: homeController,
          builder: (context, value, widget) {
            return value.isEmpty
                ? const Center(
                    child: Text(
                      'SEM MOVIMENTAÇÔES',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 50,
                          color: Colors.greenAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'EXTRATO',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'SALDO: R\$ ${money.format(homeController.saldo.value.toDouble())}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.length,
                          itemBuilder: (_, index) {
                            var movimentation = value[index];
                            return ListTile(
                              title: Text(movimentation.title),
                              leading: CircleAvatar(
                                child: Icon(
                                  movimentation.typeMovimentation ==
                                          TypeMovimentation.deposit
                                      ? Icons.add
                                      : Icons.remove,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat("dd/MM/yyyy")
                                    .format(movimentation.date),
                              ),
                              trailing: Text(
                                  'R\$ ${money.format(movimentation.value.toDouble())}'),
                            );
                          },
                        ),
                      ],
                    ),
                  );
          }),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => showCustomDialog(TypeMovimentation.deposit),
                icon: const Icon(Icons.add),
                label: const Text('Depósito'),
              ),
            ), //Button 1
            VerticalDivider(
              width: 1,
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () => showCustomDialog(TypeMovimentation.saque),
                icon: const Icon(Icons.remove),
                label: const Text('Saque'),
              ),
            ), //Bututn 2
          ],
        ),
      ],
    );
  }
}

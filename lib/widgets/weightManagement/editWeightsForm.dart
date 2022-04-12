import 'package:flutter/material.dart';

//local
import '../../db/weights/weightsDBConstructor.dart';
import '../../db/weights/weights.dart';
import 'weightsList.dart';

class EditWeightsForm extends StatelessWidget {
    final weightTextController = TextEditingController();
    final quantityTextController = TextEditingController();
    int? id;
    int weight;
    int quantity;

    EditWeightsForm({
      Key? key,
      required this.id,
      required this.weight,
      required this.quantity,
    }) : super(
        key: key,
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : const Text('Edit'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const WeightsList(
                  // title: 'test',
                  )
                ),
              );
            }
        ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: weightTextController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixText: '#   ',
                hintText: weight.toString(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: quantityTextController,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                prefixText: 'Quantity:   ',
                hintText: quantity.toString(),
                  hintStyle: const TextStyle(fontSize: 20)
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.green,
              fixedSize: const Size(100, 40),
            ),
            onPressed: () async {
              if (weightTextController.text.isNotEmpty || quantityTextController.text.isNotEmpty ) {
                await WeightsDBConstructor.instance.update(
                    Weights(id: id,
                        weight: weightTextController.text.isNotEmpty ? int.parse(weightTextController.text) : weight,
                        quantity: quantityTextController.text.isNotEmpty ? int.parse(quantityTextController.text) : quantity
                    )
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const WeightsList(
                  )
                ),
              );
            },
            child: const Text('SAVE'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.green,
              fixedSize: const Size(100, 40),
            ),
            onPressed: () async {
              await WeightsDBConstructor.instance.remove(id!);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const WeightsList(
                  )
                ),
              );
            },
            child: const Text('DELETE'),
          ),
        ],
      )
    );
  }
}
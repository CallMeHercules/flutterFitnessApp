import 'package:flutter/material.dart';

//local
import '../../db/weights/weightsDBConstructor.dart';
import '../../db/weights/weights.dart';
import 'weightsList.dart';

class AddWeightsForm extends StatelessWidget {
  final weightTextController = TextEditingController();
  final quantityTextController = TextEditingController();
  AddWeightsForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : const Text('Add'),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Plate Size:   ',
                  hintText: '#   ',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: quantityTextController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixText: 'Quantity:   ',
                  hintText: '#   ',
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
                await WeightsDBConstructor.instance.add(
                    Weights(weight: int.parse(weightTextController.text), quantity:int.parse(quantityTextController.text))
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const WeightsList(
                    // title: 'test',
                    )
                  ),
                );
              },
              child: const Text('SAVE'),
            ),
          ],
        )
    );
  }
}
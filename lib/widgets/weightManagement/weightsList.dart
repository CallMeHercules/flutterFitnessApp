import 'package:flutter/material.dart';

//local
import '../../db/weights/weightsDBConstructor.dart';
import '../../db/weights/weights.dart';
import '../home.dart';
import 'editWeightsForm.dart';
import 'addWeightsForm.dart';

class WeightsList extends StatefulWidget {
  const WeightsList({Key? key,
    // required this.title
  }) : super(key: key);
  // final String title;
  @override
  State<WeightsList> createState() => _WeightsList();
}

class _WeightsList extends State<WeightsList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title : Text(
            // widget.title
          'Weight Room'
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "btn3",
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const Home()),
                  );
                },
                child: const Icon(Icons.home),
              ),
              FloatingActionButton(
                heroTag: "btn4",
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AddWeightsForm()),
                    );
                  },
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),

      body: Center(
        child: FutureBuilder<List<Weights>>(
            future: WeightsDBConstructor.instance.getWeights(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Weights>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No weights have been entered'))
                  : ListView(
                children: snapshot.data!.map((weights) {
                  return SizedBox(
                    child: ListTile(
                      leading:  Icon(Icons.circle, size: (weights.weight.toDouble()))
                      ,title:  Center(
                          child: Text(weights.weight.toString() + ' lbs x ' + weights.quantity.toString())
                      )
                      ,trailing:  Icon(Icons.circle, size: (weights.weight.toDouble()))
                      ,onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  EditWeightsForm(
                            id: weights.id,
                            weight: weights.weight,
                            quantity: weights.quantity,
                          )),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
import 'package:flutter/material.dart';

//local
import '../../../db/exercises/exercisePerformed/exercisePerformed.dart';
import '../../../db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import '../exercisesList.dart';
import '../../home.dart';

class EditPerformExercise extends StatelessWidget {
  final weightTextController = TextEditingController();
  final repsTextController = TextEditingController();
  int? id;
  int exercisesID;
  String barType;
  String name;
  int weight;
  int reps;

  EditPerformExercise({
    Key? key,
    required this.id,
    required this.exercisesID,
    required this.barType,
    required this.name,
    required this.weight,
    required this.reps,
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : const Text('Edit'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const Home()),
                  );
                },
                child: const Icon(Icons.home),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const ExercisesList()),
                  );
                },
                child: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: weightTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixText: 'weight#           ',
                  hintText: weight.toString(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: repsTextController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixText: 'reps:                ',
                    hintText: reps.toString(),
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
                if (weightTextController.text.isNotEmpty && repsTextController.text.isNotEmpty ) {
                  await ExercisePerformedDBConstructor.instance.update(
                      ExercisePerformed(id: id,
                          exerciseID: exercisesID,
                          weight: weightTextController.text.isNotEmpty ? int.parse(weightTextController.text) : 0,
                          reps: repsTextController.text.isNotEmpty ? int.parse(repsTextController.text) : 0
                      )
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const ExercisesList()),
                );
              },
              child: const Text('SAVE'),
            ),
          ],
        )
    );
  }
}
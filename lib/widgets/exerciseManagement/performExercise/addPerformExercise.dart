import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformed.dart';
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import '../exercisesList.dart';
import 'exercisePerformedList.dart';

class AddPerformExercise extends StatelessWidget {
  final weightTextController = TextEditingController();
  final repsTextController = TextEditingController();
  int? exercisesID;
  String barType;
  String name;
  AddPerformExercise(
      {Key? key
    , required this.exercisesID
    , required this.barType
    , required this.name
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : Text(name.toString())
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const ExercisesList()),
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
                  prefixText: 'Weight:   ',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: repsTextController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixText: 'Reps:   ',
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.green,
                fixedSize: const Size(100, 40),
              ),
              // onPressed: (){},
              onPressed: () async {
                await ExercisePerformedDBConstructor.instance.add(
                    ExercisePerformed(exerciseID: exercisesID, weight: int.parse(weightTextController.text), reps: int.parse(repsTextController.text), t: '')
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ExercisePerformedList(
                        barType: barType
                      , name: name
                      , exercisesID: int.parse(exercisesID.toString())
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
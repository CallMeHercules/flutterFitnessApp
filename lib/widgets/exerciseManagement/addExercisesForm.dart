import 'package:flutter/material.dart';

//local
import '../../db/exercises/exercisesDBConstructor.dart';
import '../../db/exercises/exercises.dart';
import 'exercisesList.dart';

class AddExercisesForm extends StatelessWidget {

  final barTextController = TextEditingController();
  final nameTextController = TextEditingController();

  AddExercisesForm({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : const Text('Add'),
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
                controller: barTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Bar Type:   ',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: nameTextController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixText: 'Name:   ',
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
                await ExercisesDBConstructor.instance.add(
                    Exercises(barType: barTextController.text, name: nameTextController.text)
                );
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
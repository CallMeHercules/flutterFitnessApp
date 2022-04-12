import 'package:flutter/material.dart';

//local
import '../../db/exercises/exercisesDBConstructor.dart';
import '../../db/exercises/exercises.dart';
import '../home.dart';
import 'exercisesList.dart';
import 'performExercise/addPerformExercise.dart';
import 'performExercise/exercisePerformedList.dart';

class EditExercisesForm extends StatelessWidget {
    final barTextController = TextEditingController();
    final nameTextController = TextEditingController();
    int? exercisesID;
    String barType;
    String name;

    EditExercisesForm({
      Key? key,
      required this.exercisesID,
       required this.barType,
       required this.name,
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
                    MaterialPageRoute(builder: (context) =>  AddPerformExercise(
                        exercisesID: exercisesID
                        , barType: barType.toString()
                        , name: barType.toString()
                      )
                    ),
                  );
                },
                child: const Icon(Icons.add),
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
              controller: barTextController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixText: '             ',
                hintText: barType,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: nameTextController
              ,decoration: InputDecoration(
                border: const OutlineInputBorder()
                ,prefixText: 'name:   '
                ,hintText: name.toString()
                // ,hintStyle: const TextStyle(fontSize: 20)
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
              if (barTextController.text.isNotEmpty || nameTextController.text.isNotEmpty ) {
                await ExercisesDBConstructor.instance.update(
                    Exercises(id: exercisesID,
                        barType: barTextController.text.isNotEmpty ? barTextController.text : barType.toString(),
                        name: nameTextController.text.isNotEmpty ? nameTextController.text : name.toString()
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
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.green,
              fixedSize: const Size(100, 40),
            ),
            onPressed: () async {
              await ExercisesDBConstructor.instance.remove(exercisesID!);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const ExercisesList(
                  )
                ),
              );
            },
            child: const Text('DELETE'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.green,
              fixedSize: const Size(100, 60),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddPerformExercise(
                    exercisesID: exercisesID
                    ,barType: barType.toString()
                    ,name: name.toString()
                )
                ),
              );
            },
            child: const Text('PERFORM EXERCISE'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.green,
              fixedSize: const Size(100, 60),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ExercisePerformedList(
                    barType: barType.toString()
                    ,name: name.toString()
                    ,exercisesID:int.parse(exercisesID.toString())
                )
                ),
              );
            },
            child: const Text('VIEW HISTORY'),
          ),
        ],
      )
    );
  }
}
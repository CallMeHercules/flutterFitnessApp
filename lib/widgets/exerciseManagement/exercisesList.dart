import 'package:flutter/material.dart';
import 'package:untitled1/widgets/exerciseManagement/performExercise/exercisePerformedList.dart';

//local
import '../../db/exercises/exercisesDBConstructor.dart';
import '../../db/exercises/exercises.dart';
import '../home.dart';
import 'addExercisesForm.dart';

class ExercisesList extends StatefulWidget {
  const ExercisesList({Key? key}) : super(key: key);
  @override
  State<ExercisesList> createState() => _ExercisesList();
}

class _ExercisesList extends State<ExercisesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text('Exercise History'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const Home()),
                );
              },
              child: const Icon(Icons.home),
            ),
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AddExercisesForm()),
                );
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),

      body: Center(
        child: FutureBuilder<List<Exercises>>(
            future: ExercisesDBConstructor.instance.getExercises(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Exercises>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No exercises have been entered'))
                  : ListView(
                children: snapshot.data!.map((exercises) {
                  return SizedBox(
                    child: ListTile(
                      title:  Center(
                          child: Text(exercises.barType + ' ' + exercises.name)
                      )
                      ,onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ExercisePerformedList(
                            exercisesID: int.parse(exercises.id.toString())
                            ,barType: exercises.barType
                            ,name: exercises.name
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
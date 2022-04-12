import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformed.dart';
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import 'package:untitled1/widgets/exerciseManagement/editExercisesForm.dart';
import 'package:untitled1/widgets/exerciseManagement/exercisesList.dart';
import 'package:untitled1/widgets/exerciseManagement/performExercise/addPerformExercise.dart';
import '../../home.dart';
import '../graphData.dart';
import 'editPerformExercise.dart';

class ExercisePerformedList extends StatefulWidget {
  final String name;
  final String barType;
  final int exercisesID;
  const ExercisePerformedList({Key? key
    , required this.barType
    , required this.name
    , required this.exercisesID
  }) : super(key: key);
  @override
  State<ExercisePerformedList> createState() => _ExercisePerformedList();
}

class _ExercisePerformedList extends State<ExercisePerformedList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text(widget.barType + ' ' + widget.name),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  EditExercisesForm(
                  exercisesID: widget.exercisesID
                  , barType: widget.barType
                  , name: widget.name
                )
              ),
            );
      },
          child: const Icon(
            Icons.edit,  // add custom icons also
          ),
        ),
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
                      exercisesID: widget.exercisesID
                      , barType: widget.barType
                      , name: widget.name
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
                  MaterialPageRoute(builder: (context) =>  StackedAreaLineChart(
                    animate: true
                    ,exercisesID: widget.exercisesID
                    ,name: widget.name
                    ,barType: widget.barType
                    ,swap: 'TODAY'
                    ,
                    )
                  ),
                );
              },
              child: const Icon(Icons.auto_graph),
            ),
            FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const ExercisesList()
                  ),
                );
              },
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),

      body: Center(
        child: FutureBuilder<List<ExercisePerformed>>(
            future: ExercisePerformedDBConstructor.instance.getExercisePerformed(int.parse(widget.exercisesID.toString())),
            builder: (BuildContext context,
                AsyncSnapshot<List<ExercisePerformed>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No exercises have been entered'))
                  : ListView(
                children: snapshot.data!.map((exercisePerformed) {
                  return SizedBox(
                    child: ListTile(
                      title:  Center(
                          child: Text(exercisePerformed.t.toString().substring(0,11) + '     ' +exercisePerformed.weight.toString() + ' x ' + exercisePerformed.reps.toString())
                      )
                      ,onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  EditPerformExercise(
                          id: exercisePerformed.id
                          ,exercisesID: widget.exercisesID
                          ,barType: widget.barType
                          ,name: widget.name
                          ,weight: exercisePerformed.weight
                          ,reps: exercisePerformed.reps
                        )
                        ),
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

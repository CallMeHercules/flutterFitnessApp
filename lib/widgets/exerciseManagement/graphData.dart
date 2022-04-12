/// Example of a stacked area chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import '../../db/exercises/exercisePerformed/exercisePerformed.dart';
import '../home.dart';

class StackedAreaLineChart extends StatelessWidget {
  final bool animate;
  final int exercisesID;
  final String swap; /*this is what determines the chart
  I usually hard code throw it by day
  lack of data or user input will switch it to ALL TIME from TODAY
  I might add more swaps in the future, to by week, month year etc.
  the idea is that this would scale in a switch statement
  */

  const StackedAreaLineChart({Key? key
    , required this.animate
    , required this.exercisesID
    , required this.swap}): super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title : Text(swap),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  StackedAreaLineChart(
                  animate: true
                  ,exercisesID: exercisesID
                  , swap: swap=='TODAY' ? 'ALL TIME' : swap
                  ,
                  )
                ),
              );
            },
            child: const Icon(
              Icons.auto_graph,  // add custom icons also
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.home),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const Home()),
              );
            }
        ),

        body : Center(
            child: FutureBuilder<List<ExercisePerformed>>(
                future: ExercisePerformedDBConstructor.instance.getExercisePerformedToday(exercisesID, swap),
                builder: (BuildContext context,
                AsyncSnapshot<List<ExercisePerformed>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('loading...'));
                  }
                  return snapshot.data!.isEmpty
                      ? const Center(child: Text('No exercises have been entered'))
                      :  (
                            charts.LineChart(_createSampleData(snapshot.data),
                              defaultRenderer:
                              charts.LineRendererConfig(includeArea: true, stacked: true),
                              animate: animate,
                          )
                  );
                })
        )
    );
  }

  static List<charts.Series<LiftsPerformed, int>> _createSampleData(List<ExercisePerformed>? exercisePerformed) {
    var weightData= [
      LiftsPerformed(0, 0),
    ];
    try
      {(exercisePerformed?.length.isNaN);}
    catch (error){
      LiftsPerformed(0, 0); //this should never happen but if it does, that means theres an issue with the DB
    } finally {
      weightData= [];
    }

    for(var i = 0; i < exercisePerformed!.length; i++){
      var x = exercisePerformed[i].weight * (1 + 0.0333 * exercisePerformed[i].reps);
       weightData.add (
         LiftsPerformed(i, x.round())
       );
    }

    return [
      charts.Series<LiftsPerformed, int>(
        id: 'Lifts',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LiftsPerformed lifts, _) => lifts.reps,
        measureFn: (LiftsPerformed lifts, _) => lifts.weight,
        data: weightData,
      ),
    ];
  }
}

class LiftsPerformed {
  final int reps;
  final int weight;

  LiftsPerformed(this.reps, this.weight);
}

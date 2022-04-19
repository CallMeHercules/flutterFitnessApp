/// Example of a stacked area chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import 'package:untitled1/widgets/exerciseManagement/performExercise/exercisePerformedList.dart';
import '../../db/exercises/exercisePerformed/exercisePerformed.dart';
import '../home.dart';

class StackedAreaLineChart extends StatelessWidget {
  final bool animate;
  final int exercisesID;
  final String name;
  final String barType;
  final String swap; /*this is what determines the chart
  I usually hard code throw it by day
  lack of data or user input will switch it to ALL TIME from TODAY
  I might add more swaps in the future, to by week, month year etc.
  the idea is that this would scale in a switch statement
  */

  const StackedAreaLineChart({Key? key
    , required this.animate
    , required this.exercisesID
    , required this.name
    , required this.barType
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
                  , name: name
                  , barType: barType
                  , swap: swap=='TODAY' ? 'ALL TIME' : 'TODAY'
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
                    MaterialPageRoute(builder: (context) =>  ExercisePerformedList(
                      exercisesID: exercisesID
                      ,name: name
                      ,barType: barType
                    )
                    ),
                  );
                },
                child: const Icon(Icons.arrow_back),
              )
            ],
          ),
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
                            charts.LineChart(_createSampleData(snapshot.data
                                                              ,barType + ' ' + name),
                              defaultRenderer:
                              charts.LineRendererConfig(
                                  includeArea: true
                                  , stacked: true
                              )
                              ,behaviors: [charts.SeriesLegend()]
                              ,animate: animate
                              ,
                          )
                  );
                })
        )
    );
  }

  static List<charts.Series<LiftsPerformed, int>> _createSampleData(List<ExercisePerformed>? exercisePerformed
                                                                    ,String name
      )
  {
    List<LiftsPerformed> weightData= [
      // LiftsPerformed(0, 0),
    ];
    for(var i = 0; i < exercisePerformed!.length; i++){
      var x = exercisePerformed[i].weight * (1 + 0.0333 * exercisePerformed[i].reps);
      weightData.add (
         LiftsPerformed(i, x.round())
       );
    }

    return [
      charts.Series<LiftsPerformed, int>(
        id: name,
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

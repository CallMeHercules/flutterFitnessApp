import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import 'package:untitled1/widgets/exerciseManagement/performExercise/exercisePerformedList.dart';
import '../../db/exercises/exercisePerformed/exercisePerformed.dart';
import '../home.dart';
import 'graphDataAllTime.dart';

class GraphData extends StatelessWidget {
  final bool animate;
  final int exercisesID;
  final String name;
  final String barType;
  final String swap; /*this is what determines the chart
  I usually hard code throw it by all time, since that gives macro data
  lack of data or user input will switch it to ALL TIME from TODAY
  I might add more swaps in the future, to by week, month year etc.
  the idea is that this would scale in a switch statement
  */

  const GraphData({Key? key
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
                MaterialPageRoute(builder: (context) =>  GraphDataAllTime(
                  animate: true
                  ,exercisesID: exercisesID
                  , name: name
                  , barType: barType
                  , swap: 'TOTAL WORK PERFORMED OVER TIME'
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
                heroTag: "btn1",
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const Home()),
                  );
                },
                child: const Icon(Icons.home),
              ),
              FloatingActionButton(
                heroTag: "btn2",
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
                                                              ,barType + ' ' + name
                                                              ,swap.toString()),
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
                                                                    ,String swap
      )
  {
    List<LiftsPerformed> weightData= [
    ];
      for (var i = 0; i < exercisePerformed!.length; i++) {
        var x = exercisePerformed[i].weight *
            (1 + 0.0333 * exercisePerformed[i].reps);
        weightData.add(
            LiftsPerformed(i, x.round(), DateTime.parse(exercisePerformed[i].t.toString()))
        );
      }

      return [
        charts.Series<LiftsPerformed, int>(
          id: name,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LiftsPerformed lifts, _) => lifts.x,
          measureFn: (LiftsPerformed lifts, _) => lifts.y,
          data: weightData,
        ),
      ];
    }
}

class LiftsPerformed {
  final int x;
  final int y;
  final DateTime z;

  LiftsPerformed(this.x, this.y, this.z);
}

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//local
import 'package:untitled1/db/exercises/exercisePerformed/exercisePerformedDBConstructor.dart';
import 'package:untitled1/widgets/exerciseManagement/performExercise/exercisePerformedList.dart';
import '../../db/exercises/exercisePerformed/exercisePerformed.dart';
import '../home.dart';
import 'graphData.dart';

class GraphDataAllTime extends StatelessWidget {
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

  const GraphDataAllTime({Key? key
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
                MaterialPageRoute(builder: (context) =>  GraphData(
                  animate: true
                  ,exercisesID: exercisesID
                  , name: name
                  , barType: barType
                  , swap: 'TODAY'
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
                    ExercisePerformedDBConstructor.instance.getExercisePerformedToday(exercisesID, swap);
                    return const Center(child: Text('loading...'));
                  }
                  int count = 0;
                  for (var i = 0; i < snapshot.data!.length; i++) {
                    count++;
                    // print(count);
                  }
                  // print(count);
                  // if (count == 0) {
                  //   Future.delayed(const Duration(milliseconds: 500));
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) =>  GraphData(
                  //       animate: true
                  //       ,exercisesID: exercisesID
                  //       , name: name
                  //       , barType: barType
                  //       , swap: 'TODAY'
                  //       ,
                  //     )
                  //     ),
                  //   );
                  // }
                  return (count == 0)
                      ? const Center(child: Text('No exercises have been entered'))
                      :  (
                      charts.TimeSeriesChart(_createLiftData(snapshot.data
                          ,barType + ' ' + name
                        ,
                      )
                          ,behaviors: [charts.SeriesLegend()]
                  )
                  );
                })
        )
    );
  }

  static List<charts.Series<LiftsPerformed, DateTime>> _createLiftData(List<ExercisePerformed>? exercisePerformed
      ,String name
      )
  {
    List<LiftsPerformed> weightData= [
    ];
    List<LiftsPerformed> maxData= [
    ];
    for (var i = 0; i < exercisePerformed!.length; i++) {
      var x = exercisePerformed[i].weight;
      weightData.add(
          LiftsPerformed(i, x.round(), DateTime.parse(exercisePerformed[i].t.toString()))
      );
    }
    for (var i = 0; i < exercisePerformed.length; i++) {
      var x = exercisePerformed[i].id; //in v_total_work, the id will be the max 1rm for the day for that exercise.
      maxData.add(
          LiftsPerformed(i, int.parse(x.toString()).round(), DateTime.parse(exercisePerformed[i].t.toString()))
      );
    }

    return [
      charts.Series<LiftsPerformed, DateTime>(
        id: name + ' (work x sets)',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LiftsPerformed lifts, _) => lifts.z,
        measureFn: (LiftsPerformed lifts, _) => lifts.y,
        data: weightData,
      ),
      charts.Series<LiftsPerformed, DateTime>(
        id: 'best lift',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LiftsPerformed lifts, _) => lifts.z,
        measureFn: (LiftsPerformed lifts, _) => lifts.y,
        data: maxData,
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
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
                  MaterialPageRoute(builder: (context) =>  AddExercisesForm()),
                );
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () async {
                final url = Uri.parse('https://exrx.net/Lists/Directory');
                final response = await http.get(url);
                final titles = dom.Document.html(response.body)
                    .querySelectorAll('#mainShell > article > div > div > div > div > div > ul')
                    .map((element) => element.innerHtml.trim())
                .toList();
                // print(titles);
                var str = titles.toString();
                const start = '''Wt">''';
                const end = "</a";

                const startHREF = '''<a href="''';
                const endHREF = '''">''';

                var startIndex = str.indexOf(start);
                var endIndex = str.indexOf(end, startIndex + start.length);

                var startIndexHREF = str.indexOf(startHREF);
                var endIndexHREF = str.indexOf(endHREF, startIndexHREF + startHREF.length);

                // print(startIndex);
                // print(endIndex);
                var count = str.length;
                Map<String, dynamic> data;
                List<String> returnList = [];
                List<String> HREFList = [];

                var checker = false;

                while(count > 0) {
                  var getter = str.substring(startIndex + start.length, endIndex);
                  var HREFgetter = str.substring(startIndexHREF + startHREF.length, endIndexHREF);
                  if (HREFgetter == 'OlympicWeightlifting') {
                    count = 0;
                  }
                  if (HREFgetter.substring(0,1) =='E')
                    {
                      HREFgetter = 'https://exrx.net/Lists/' + HREFgetter;
                    }

                  if (!returnList.contains(getter) && !returnList.contains('Calves')) {
                    returnList.add(getter);
                  }

                  if (returnList.length > 1 && HREFgetter.contains('#') &&! HREFList.contains(HREFgetter.substring(0,HREFgetter.indexOf('#')))) {
                    var go = HREFgetter.substring(0,HREFgetter.indexOf('#'));
                    print(HREFgetter.substring(0,HREFgetter.indexOf('#')));
                    HREFList.add(go);
                    final url = Uri.parse(go);
                    final response = await http.get(url);
                    final types = dom.Document.html(response.body)
                        .querySelectorAll('#mainShell > article > div:nth-child(1) > div > div')
                        .map((element) => element.innerHtml.trim())
                        .toList();

                    final muscleParts = dom.Document.html(response.body)
                        .querySelectorAll('#mainShell')
                        .map((element) => element.innerHtml.trim())
                        .toList();
                    // print(muscleParts);
                    var muscle = returnList.elementAt(returnList.length - 2);
                    if (checker == true) {
                      muscle = returnList.elementAt(returnList.length - 1);
                    }

                    const startMusclePart = '''/Muscles/''';
                    const endMusclePart = '''</a>''';

                    const startExType = '''<ul><li>''';
                    const endExType = '''<ul><li><a href=''';

                    var muscleStr = types.toString();
                    var muscleCount = muscleStr.length;

                    var musclePart = ' ';

                    var musclePartStr = muscleParts.toString();
                    var musclePartCount = musclePartStr.length;

                    var startIndexMusclePart = musclePartStr.indexOf(startMusclePart);
                    var endIndexMusclePart = musclePartStr.indexOf(
                        endMusclePart, startIndexMusclePart + startMusclePart.length);

                    while (musclePartCount > 0 && startIndexMusclePart > 0 && endIndexMusclePart > 0) {
                      startIndexMusclePart = musclePartStr.indexOf(startMusclePart);
                      endIndexMusclePart = musclePartStr.indexOf(
                          endMusclePart, startIndexMusclePart + startMusclePart.length);

                      var musclePartGetter = '';

                      if (endIndexMusclePart > 0 && startIndexMusclePart > 0) {
                        musclePartGetter = musclePartStr.substring(
                            startIndexMusclePart + startMusclePart.length, endIndexMusclePart);
                        if (!(musclePartGetter.substring(musclePartGetter.indexOf('''">''') +2,musclePartGetter.length)).contains('''">''')) {
                          if (checker == true) {
                            muscle = returnList.elementAt(returnList.length - 1);
                          }
                          else {
                            muscle = returnList.elementAt(returnList.length - 2);
                          }
                          // print(muscle);
                          musclePart = musclePartGetter.substring(musclePartGetter
                              .indexOf('''">''') + 2, musclePartGetter.length);
                          if (musclePart.contains('Popliteus')) {
                            checker = true;
                          }
                          // print(musclePart);
                          print(muscle + ' ' + musclePart);
                        }
                        musclePartStr = musclePartStr.substring(endIndexMusclePart);
                        musclePartCount = musclePartCount - startIndexMusclePart;
                      } else {
                        musclePartCount = 0;
                      }
                    }
                    // final urlMuscle = Uri.parse('https://exrx.net/Muscles/' + musclePart);
                    // final responseMuscle = await http.get(urlMuscle);
                    // final titlesMuscle = dom.Document.html(responseMuscle.body)
                    //     .querySelectorAll('#mainShell')
                    //     .map((element) => element.innerHtml.trim())
                    //     .toList();
                    // var exStr = titlesMuscle.toString();
                    // var exCount = exStr.length;
                    // var startIndexEX = exStr.indexOf(startExType);
                    // var endIndexEX = exStr.indexOf(
                    //     endExType, startIndexEX + startExType.length);
                    // while (exCount > 0 && startIndexEX > 0 && endIndexEX > 0) {
                    //   startIndexEX = titlesMuscle.indexOf(startExType);
                    //   endIndexEX = exStr.indexOf(
                    //       endExType, startIndexEX + startExType.length);
                    //
                    //   var EXgetter = '';
                    //
                    //   if (endIndexEX > 0 && startIndexEX > 0) {
                    //     EXgetter = exStr.substring(
                    //         startIndexEX + startExType.length, endIndexEX);
                    //
                    //     print(muscle + ' ' + musclePart + ' ' + EXgetter);
                    //
                    //     exStr = exStr.substring(endIndexEX);
                    //     exCount = exCount - startIndexEX;
                    //   } else {
                    //     exCount = 0;
                    //   }
                    // }
                  }
                  str = str.substring(endIndexHREF);
                  count = count - startIndexHREF;
                  startIndex = str.indexOf(start);
                  startIndexHREF = str.indexOf(startHREF);
                  endIndex = str.indexOf(end, startIndex + start.length);
                  endIndexHREF = str.indexOf(endHREF, startIndexHREF + startHREF.length);
                }
                // print(returnList);
              },
              child: const Icon(Icons.add_to_drive),
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
                      );},),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
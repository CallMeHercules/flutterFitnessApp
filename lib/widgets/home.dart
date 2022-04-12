import 'package:flutter/material.dart';

//local
import 'weightManagement/weightsList.dart';
import 'exerciseManagement/exercisesList.dart';
class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double buttonBuffer = 2.29;
    return Scaffold(
      appBar: AppBar(
        title : const Text('Home'),
      ),
        body: Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.green,
                fixedSize: Size((screenWidth), (screenHeight/buttonBuffer)),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const WeightsList(
                    // title: 'test',
                  )),
                );
              },
              child: const Text('Add Weights'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.green,
                fixedSize: Size((screenWidth), (screenHeight/buttonBuffer)),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const ExercisesList(
                    )
                  ),
                );
              },
              child: const Text('Add Exercises'),
            ),
          ],
        )
    );
  }
}
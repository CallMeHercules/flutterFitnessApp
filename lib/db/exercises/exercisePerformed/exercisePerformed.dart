class ExercisePerformed {
  final int? id;
  final int? exerciseID;
  final int weight;
  final int reps;
  String? t; //timestamp
  ExercisePerformed({this.id, required this.exerciseID,required this.weight,required this.reps, this.t});

  factory ExercisePerformed.fromMap(Map<String, dynamic> json) => ExercisePerformed(
      id: json['id']
      ,exerciseID: json['exercisesID']
      ,weight: json['weight'].round()
      ,reps: json['reps']
      ,t: json['t']
  );

  Map<String, dynamic> toMap() {
    return {
      'exercisesID': exerciseID
      ,'weight': weight
      ,'reps': reps
      ,'t': t
    };
  }
}
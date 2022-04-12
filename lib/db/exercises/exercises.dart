class Exercises {
  late final int? id;
  final String barType;
  final String name;

  Exercises({this.id, required this.barType,required this.name});

  factory Exercises.fromMap(Map<String, dynamic> json) => Exercises(
    id: json['id']
    ,barType: json['barType']
    ,name: json['name']
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id
      ,'barType': barType
      ,'name': name
    };
  }
}
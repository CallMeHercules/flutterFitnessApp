class Weights {
  final int? id;
  final int weight;
  final int quantity;

  Weights({this.id, required this.weight,required this.quantity });

  factory Weights.fromMap(Map<String, dynamic> json) => Weights(
    id: json['id'],
    weight: json['weight'],
    quantity: json['quantity'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight':weight,
      'quantity':quantity,
    };
  }
}
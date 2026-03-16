import 'package:equatable/equatable.dart';

class PointTransaction extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final int points;

  const PointTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.points,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'points': points,
    };
  }

  @override
  List<Object?> get props => [id, title, date, points];
}

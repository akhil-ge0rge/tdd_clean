import 'dart:convert';

import '../../domain/entities/trivia.dart';

class TriviaModel extends Trivia {
  const TriviaModel({
    required super.text,
    required super.number,
    required super.found,
    required super.type,
  });

  Trivia copyWith({String? text, int? number, bool? found, String? type}) {
    return Trivia(
      text: text ?? this.text,
      number: number ?? this.number,
      found: found ?? this.found,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
      'found': found,
      'type': type,
    };
  }

  factory TriviaModel.fromMap(Map<String, dynamic> map) {
    return TriviaModel(
      text: map['text'] as String,
      number:
          (map['number'] is double)
              ? (map['number'] as double).toInt()
              : map['number'] as int,
      found: map['found'] as bool,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TriviaModel.fromJson(String source) =>
      TriviaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}

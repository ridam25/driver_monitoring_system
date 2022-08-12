class PrevLog {
  final int? id;
  final int duration;

  PrevLog({this.id, required this.duration});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "duration": duration,
    };
  }
}

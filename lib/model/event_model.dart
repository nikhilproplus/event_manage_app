class EventModel {
  final String key;
  final String title;
  final DateTime eventDate;
  final String description;
  final DateTime createDate;

  EventModel({
    required this.key,
    required this.title,
    required this.eventDate,
    required this.description,
    DateTime? createDate,
  }) : createDate = createDate ?? DateTime.now();

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    return EventModel(
      title: parsedJson['title'] ?? "",
      eventDate: DateTime.parse(parsedJson['eventDate'] ?? ""),
      description: parsedJson['description'] ?? "",
      createDate: DateTime.parse(parsedJson['createDate'] ?? ""),
      key: parsedJson['key'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "eventDate": eventDate.toIso8601String(),
      "description": description,
      "createDate": createDate.toIso8601String(),
      "key": key.toString(),
    };
  }
}

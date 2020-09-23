class Location {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final String created;

  Location(
      {this.id = -1,
      this.name,
      this.type = "",
      this.dimension = "",
      this.residents = const [],
      this.url = "",
      this.created = ""});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        dimension: json["dimension"],
        residents: [...json["residents"]],
        url: json["url"],
        created: json["created"]);
  }

  factory Location.onlyName(String name) => Location(name : name);

}
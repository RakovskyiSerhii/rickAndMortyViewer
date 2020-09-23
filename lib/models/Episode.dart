class Episode {
  final int id;
  final String name;
  final String air_date;
  final String episode;
  final List<String> characters;
  final String url;
  final String created;

  Episode(this.id, this.name, this.air_date, this.episode, this.characters,
      this.url, this.created);

  factory Episode.convertFromJson(Map<String, dynamic> json) {
    return Episode(
      json["id"],
      json["name"],
      json["air_date"],
      json["episode"],
      [...json["characters"]],
      json["url"],
      json["created"],
    );
  }

  @override
  String toString() {
    return 'Episode{id: $id, name: $name, air_date: $air_date, episode: $episode, characters: $characters, url: $url, created: $created}';
  }
}

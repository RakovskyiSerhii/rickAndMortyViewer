class CharacterMetaData {
  String name;
  String url;

  CharacterMetaData({this.name, this.url});

  static CharacterMetaData convertFromJson(Map<String, dynamic> json) {
    return CharacterMetaData(name: json["name"], url: json["url"]);
  }

  @override
  String toString() {
    return 'CharacterMetaData{name: $name}';
  }
}

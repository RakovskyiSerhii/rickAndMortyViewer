import 'package:rick_and_morty_viewer/converters/NetworkConverter.dart';
import 'package:rick_and_morty_viewer/models/CharacterMetaData.dart';

class Character {
  int id;
  String name;
  String status;
  String species;
  String type;
  String gender;
  CharacterMetaData origin;
  CharacterMetaData location;
  String image;
  List<String> episode;
  String url;
  String created;

  Character(
      {this.id,
      this.name,
      this.status,
      this.species,
      this.type,
      this.gender,
      this.origin,
      this.location,
      this.image,
      this.episode,
      this.url,
      this.created});

  factory Character.convertFromJson(Map<String, dynamic> json) {
    return Character(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      species: json["species"],
      type: json["type"],
      gender: json["gender"],
      origin: CharacterMetaData.convertFromJson(json["origin"]),
      location: CharacterMetaData.convertFromJson(json["location"]),
      image: json["image"],
      episode:[...json["episode"]],
      url: json["url"],
      created: json["created"],
    );
  }

  @override
  String toString() {
    return 'Character{id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, origin: $origin, location: $location, created: $created}';
  }
}

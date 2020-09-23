import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

//class for generating small biography of character based
// on origin and location places and does character alive or not
class CharacterBioConstructor {
  static const _https = "https://";
  String _result;
  String _genderString;
  String _genderType;
  bool _isAlive;
  String _location;
  String _origin;
  String _urlOrigin;
  String _urlLocation;

  String get bio => _result;

  CharacterBioConstructor(Character character) {
    _getGender(character.gender);
    _isAlive = character.status.toLowerCase() == Strings.ALIVE_STRING;
    _location = _https + character.location.name.replaceAll(" ", "_");
    _origin = _https + character.origin.name.replaceAll(" ", "_");
    _urlOrigin = character.origin.url;
    _urlLocation = character.location.url;

    if (_origin.toLowerCase() == Strings.UNKNOWN_STRING &&
        _location.toLowerCase() == Strings.UNKNOWN_STRING) {
      _result = sprintf(Strings.CHARACTER_ORIGIN_LOCATION_UNKNOWN, [
        _genderType,
        _genderString.toLowerCase(),
        _genderString.toLowerCase()
      ]);
    } else {
      if (_origin.toLowerCase() == Strings.UNKNOWN_STRING ||
          _location.toLowerCase() == Strings.UNKNOWN_STRING) {
        if (_origin.toLowerCase() == Strings.UNKNOWN_STRING)
          _result = _isCharacterAlive(
              isAlive: sprintf(Strings.CHARACTER_ALIVE_ORIGIN_UNKNOWN,
                  [_location]),
              isDied: sprintf(Strings.CHARACTER_DEAD_ORIGIN_UNKNOWN,
                  [_genderString, _location]));
        else
          _result = _isCharacterAlive(
              isAlive: sprintf(Strings.CHARACTER_ALIVE_LOCATION_UNKNOWN,
                  [_origin]),
              isDied: sprintf(Strings.CHARACTER_DEAD_ORIGIN_UNKNOWN,
                  [_genderString, _origin]));
      } else {
        if (_origin == _location)
          _result = _isCharacterAlive(
              isAlive: sprintf(Strings.CHARACTER_ALIVE_ORIGIN_EQUAL_LOCATION,
                  [_genderString, _origin]),
              isDied: sprintf(Strings.CHARACTER_DEAD_ORIGIN_EQUAL_LOCATION,
                  [_genderString, _origin]));
        else
          _result = _isCharacterAlive(
              isAlive:
                  sprintf(Strings.CHARACTER_ALIVE_ORIGIN_NOT_EQUAL_LOCATION, [
                _genderString,
                    _origin,
                _genderString.toLowerCase(),
                    _location
              ]),
              isDied: sprintf(
                  Strings.CHARACTER_DEAD_ORIGIN_NOT_EQUAL_LOCATION, [
                _genderString,
                _origin,
                _genderString,
                _location
              ]));
      }
    }
  }

  String getUrl(String linkifyText) => "$_https$linkifyText" == _origin ? _urlOrigin : _urlLocation;
  
  String getClearPlace(String linkifyText) => linkifyText.replaceAll(_https, "").replaceAll("_", "");

  String _isCharacterAlive({String isAlive, String isDied}) {
    if (_isAlive)
      return isAlive;
    else
      return isDied;
  }

  void _getGender(String gender) {
    switch (gender.toLowerCase()) {
      case Strings.FEMALE_STRING:
        {
          _genderString = Strings.SHE_STRING;
          _genderType = Strings.WOMAN_STRING;
          break;
        }

      case Strings.MALE_STRING:
        {
          _genderString = Strings.HE_STRING;
          _genderType = Strings.GUY_STRING;

          break;
        }
      default:
        _genderString = Strings.IT_STRING;
        _genderType = Strings.TRIPLE_DOT_SOMETHING_STRING;
    }
  }
}

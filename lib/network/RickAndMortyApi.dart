import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';

class RickAndMortyApiRoutes {
  static const String _baseUrl = "rickandmortyapi.com";
  static const String _character = "/api/character/";
  static const String _episodes = "api/episode/";
  static const String _location = "api/location/";

  Uri _getCharacterListUrl(int page) => Uri.https(_baseUrl, _character, {"page": page.toString()});
  Uri _getEpisodesListUrl(String episodes) => Uri.https(_baseUrl, "$_episodes$episodes");
  Uri _getCharacterListForEpisodeUrl(String characters) => Uri.https(_baseUrl, "$_character$characters");
  Uri _getCharactersListForLocationUrl(String characters) => Uri.https(_baseUrl, "$_character$characters");
  Uri _getLocationListUrl(String location) => Uri.https(_baseUrl, "$_location$location");
  Uri _getPageLocationsListUrl(int page) => Uri.https(_baseUrl, _location, {"page": page.toString()});
  Uri _getEpisodeListUrl(int page) => Uri.https(_baseUrl, _episodes, {"page": page.toString()});

  Future<Response> getEpisodeListById(String episodes) => http.get(_getEpisodesListUrl(episodes));
  Future<Response> getCharacterList(int page) => http.get(_getCharacterListUrl(page));
  Future<Response> getCharactersForEpisode(String characters) => http.get(_getCharacterListForEpisodeUrl(characters));
  Future<Response> getCharactersForLocation(String characters) => http.get(_getCharactersListForLocationUrl(characters));
  Future<Response> getPageEpisodeList(int page) => http.get(_getEpisodeListUrl(page));
  Future<Response> getPageLocationList(int page) => http.get(_getPageLocationsListUrl(page));
  Future<Response> getLocationList(String location) => http.get(_getLocationListUrl(location));
}

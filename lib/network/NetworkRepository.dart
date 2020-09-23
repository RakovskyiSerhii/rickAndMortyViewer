import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/models/Location.dart';
import 'package:rick_and_morty_viewer/network/BasePaginResponse.dart';
import 'package:rick_and_morty_viewer/network/RickAndMortyApi.dart';

class NetworkRepository {
  var _api = RickAndMortyApiRoutes();

  Future<BasePageResponse<List<T>>> simplePageResponse<T>(Future<Response> response, T Function (Map<String, dynamic>) converter) async {
    try {
      var result = await response;
      final statusCode = result.statusCode;
      if (statusCode == 200) {
        final data = jsonDecode(result.body);
        final info = data[_ResponseKeys.INFO_KEY];
        final resultBody = data[_ResponseKeys.RESULTS_KEY].cast<Map<String, dynamic>>();
        return BasePageResponse.fromJson(info, resultBody.map<T>((json) => converter(json)).toList());
      } else if(statusCode == 0)
          return Future.error(Failure.networkError());
        else return Future.error(Failure.serverError());
    } on SocketException {
      return Future.error(Failure.networkError());
    }
  }

  Future<List<T>> simpleRequestWithList<T>(Future<Response> request, T Function(Map<String,dynamic>) converter) async {
    try {
      var response = await request;
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        try {
          return result.map<T>((json) => converter(json)).toList();
        } on NoSuchMethodError {
          return [converter(result)];
        }
      } else if(response.statusCode == 0)
        return Future.error(Failure.networkError());
      else return Future.error(Failure.serverError());
    } on SocketException {
      return Future.error(Failure.networkError());
    }
  }

  Future<BasePageResponse<List<Location>>> getPageLocationList(int page) async => simplePageResponse(_api.getPageLocationList(page), (json) => Location.fromJson(json));
  Future<BasePageResponse<List<Episode>>> getPageEpisodeList(int page) async => await simplePageResponse(_api.getPageEpisodeList(page), (json) => Episode.convertFromJson(json));
  Future<BasePageResponse<List<Character>>> getCharacterList(int page) async => await simplePageResponse(_api.getCharacterList(page), (Map<String,dynamic> json) => Character.convertFromJson(json));

  Future<List<Location>> getLocationListById(String location) async => await simpleRequestWithList(_api.getLocationList(location), (json) => Location.fromJson(json));
  Future<List<Episode>> getEpisodesListById(String episodes) async => await simpleRequestWithList(_api.getEpisodeListById(episodes), (json) => Episode.convertFromJson(json));

  Future<List<Character>> getCharacterForEpisode(String characters) async => await simpleRequestWithList(_api.getCharactersForEpisode(characters), (json) => Character.convertFromJson(json));
  Future<List<Character>> getCharacterForLocation(String characters) async => await simpleRequestWithList(_api.getCharactersForLocation(characters), (json) => Character.convertFromJson(json));
  Future<List<Character>> getCharactersForLocation(String characters) async => await simpleRequestWithList(_api.getCharactersForLocation(characters), (json) => Character.convertFromJson(json));

}

class _ResponseKeys {
  static const RESULTS_KEY = "results";
  static const INFO_KEY = "info";
}

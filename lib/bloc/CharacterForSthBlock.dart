import 'dart:async';

import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/core/base_block.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/models/Location.dart';
import 'package:rick_and_morty_viewer/network/NetworkRepository.dart';
import 'package:rick_and_morty_viewer/util/util.dart';

class CharacterForSthBlock extends BaseBloc {
  final _repository = NetworkRepository();

  final _characterListController =
      StreamController<List<Character>>.broadcast();
  final _errorController = StreamController<Failure>.broadcast();
  final _locationController = StreamController<Location>.broadcast();

  StreamSink<List<Character>> get _characterListSink =>
      _characterListController.sink;

  Stream<List<Character>> get characterListStream =>
      _characterListController.stream;

  StreamSink<Location> get _locationSink => _locationController.sink;

  Stream<Location> get locationStream => _locationController.stream;

  StreamSink<Failure> get _errorSink => _errorController.sink;

  Stream<Failure> get errorStream => _errorController.stream;

  void getCharacterForEpisode(Episode episode) {
    _errorSink.add(null);
    final list = episode.characters.map((e) => e.split("/").last).toList();
    _repository
        .getCharacterForEpisode(list.join(","))
        .then((value) => delayForSmooth(() {
              _characterListSink.add(value);
            }))
        .catchError((onError) => _handleError(onError));
  }

  void getLocation(String url) {
    _repository
        .getLocationListById(url.split("/").last)
        .then((value) => getCharacterForLocation(value.first))
        .catchError((onError) => _handleError(onError));
  }

  void getCharacterForLocation(Location location) {
    _errorSink.add(null);
    _locationSink.add(location);
    _repository
        .getCharactersForLocation(
            location.residents.map((url) => url.split("/").last).join(","))
        .then((value) => delayForSmooth(() {
              _characterListSink.add(value);
            }))
        .catchError((onError) => _handleError(onError));
  }

  void _handleError(var onError) {
    delayForSmooth(() {
      try {
        Failure failure = onError;
        _errorSink.add(failure);
      } catch (_) {
        _errorSink.add(Failure.serverError());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _characterListController.close();
    _errorController.close();
    _locationController.close();
  }
}

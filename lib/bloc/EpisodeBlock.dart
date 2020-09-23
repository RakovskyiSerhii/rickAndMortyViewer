import 'dart:async';

import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/core/base_block.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/network/BasePaginResponse.dart';
import 'package:rick_and_morty_viewer/network/NetworkRepository.dart';
import 'package:rick_and_morty_viewer/util/util.dart';

class EpisodeBlock extends BaseBloc {
  final _repository = NetworkRepository();
  final _episodesListController = StreamController<List<Episode>>.broadcast();
  final _errorController = StreamController<Failure>.broadcast();
  final List<Episode> _episodeList = [];
  bool _isLoading = false;
  String _episodesId;
  int _page = 1;
  bool _hasNextPage = true;

  StreamSink<List<Episode>> get _episodesListSink =>
      _episodesListController.sink;

  Stream<List<Episode>> get episodesListStream =>
      _episodesListController.stream;

  StreamSink<Failure> get _errorSink => _errorController.sink;

  Stream<Failure> get errorStream => _errorController.stream;

  EpisodeBlock({Character character}) {
    if (character != null) {
      _episodesId = character.episode.map((e) => e.split("/").last).join(",");
      getEpisodesById();
    } else
      getNextPage();
  }

  factory EpisodeBlock.loadForCharacter(Character character) =>
      EpisodeBlock(character: character);

  factory EpisodeBlock.loadAllEpisodes() => EpisodeBlock(character: null);

  void getEpisodesById() {
    _errorSink.add(null);
    _episodesListSink.add(null);
    _repository
        .getEpisodesListById(_episodesId)
        .then((value) => delayForSmooth(() {
              _episodesListSink.add(value);
            }))
        .catchError((onError) => _handleError(onError));
  }

  void getNextPage() {
    if (!_hasNextPage || _isLoading) return;
    _isLoading = true;
    _repository
        .getPageEpisodeList(_page)
        .then((value) => _handleEpisodes(value));
  }

  void _handleEpisodes(BasePageResponse<List<Episode>> response) {
    _isLoading = false;
    _page++;
    _episodeList.addAll(response.data);
    delayForSmooth(() {
      _episodesListSink.add(_episodeList);
    });
    _hasNextPage = response.hasNextPage;
  }

  void _handleError(Failure failure) {
    delayForSmooth(() {
      _errorSink.add(failure);
    });
  }

  @override
  void dispose() {
    _episodesListController.close();
    _errorController.close();
    super.dispose();
  }
}

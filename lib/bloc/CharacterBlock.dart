import 'dart:async';

import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/core/base_block.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/network/BasePaginResponse.dart';
import 'package:rick_and_morty_viewer/network/NetworkRepository.dart';
import 'package:rick_and_morty_viewer/util/util.dart';

class CharacterBlock extends BaseBloc {
  final _repository = NetworkRepository();
  final List<Character> _characterList = [];
  int _page = 1;
  bool _isNextPageExist = true;
  bool _isLoading = false;

  final _characterListController =
      StreamController<List<Character>>.broadcast();
  final _errorController = StreamController<Failure>.broadcast();

  StreamSink<List<Character>> get _characterListSink =>
      _characterListController.sink;

  Stream<List<Character>> get characterListStream =>
      _characterListController.stream;

  StreamSink<Failure> get _errorSink => _errorController.sink;

  Stream<Failure> get errorStream => _errorController.stream;

  void getNextPage() {
    _errorSink.add(null);
    if (_isNextPageExist && !_isLoading) {
      _isLoading = true;
      _repository
          .getCharacterList(_page)
          .then((value) => _handlePage(value))
          .catchError((onError) {
        _handleError(onError);
      });
    }
  }

  void _handlePage(BasePageResponse response) {
    _isNextPageExist = response.hasNextPage;
    _characterList.addAll(response.data);
    _page++;
    _isLoading = false;
    delayForSmooth(() {
      _characterListSink.add(_characterList);
    });
  }

  void _handleError(Failure failure) {
    _isLoading = false;
    delayForSmooth(() => _errorSink.add(failure));
  }

  @override
  void dispose() {
    super.dispose();
    _characterListController.close();
    _errorController.close();
  }
}

import 'dart:async';

import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/core/base_block.dart';
import 'package:rick_and_morty_viewer/models/Location.dart';
import 'package:rick_and_morty_viewer/network/BasePaginResponse.dart';
import 'package:rick_and_morty_viewer/network/NetworkRepository.dart';
import 'package:rick_and_morty_viewer/util/util.dart';

class LocationBlock extends BaseBloc {
  final _repository = NetworkRepository();
  final _locationController = StreamController<List<Location>>.broadcast();
  final _errorController = StreamController<Failure>.broadcast();
  final List<Location> _locationList = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasNextPage = true;

  LocationBlock() {
    getNextPage();
  }

  StreamSink<List<Location>> get _locationListSink => _locationController.sink;

  Stream<List<Location>> get locationStream => _locationController.stream;

  StreamSink<Failure> get _errorSink => _errorController.sink;
  Stream<Failure> get errorStream => _errorController.stream;

  void getNextPage() {
    if (!_hasNextPage || _isLoading) return;
    _errorSink.add(null);
    _isLoading = true;
    _repository
        .getPageLocationList(_page)
        .then((value) => _handleList(value))
        .catchError(_handleError);
  }

  void _handleError(var onError) {
    _isLoading = false;
    _errorSink.add(onError);
  }

  void _handleList(BasePageResponse<List<Location>> response) {
    _isLoading = false;
    _page++;
    _locationList.addAll(response.data);
    _hasNextPage = response.hasNextPage;
    delayForSmooth(() {
      _locationListSink.add(_locationList);
    });
  }

  @override
  void dispose() {
    _locationController.close();
    _errorController.close();
    super.dispose();
  }
}

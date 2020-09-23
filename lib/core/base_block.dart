import 'dart:async';

import 'package:meta/meta.dart';

abstract class BaseBloc {
  final _processProgress = StreamTransformer<bool, bool>.fromHandlers(
      handleData: (showProgress, progressSink) {
        progressSink.add(showProgress);
      });

  final _progressController = StreamController<bool>.broadcast();

  StreamSink<bool> get _progressSink => _progressController.sink;

  Stream<bool> get progressStream =>
      _progressController.stream.transform(_processProgress);

  void showProgress() {
    _progressSink.add(true);
  }

  void hideProgress() {
    _progressSink.add(false);
  }

  @mustCallSuper
  void dispose() {
    _progressController.close();
  }
}
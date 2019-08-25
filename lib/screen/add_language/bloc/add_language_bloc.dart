import 'dart:async';

import 'package:rxdart/rxdart.dart';

class AddLanguageBloc {
  double level = 0;

  final _levelSliderSubject = PublishSubject<double>();
  Stream<double> get levelSliderStream => _levelSliderSubject.stream;
  Sink<double> get levelSliderSink => _levelSliderSubject.sink;

  dispose() {
    _levelSliderSubject.close();
  }
}

import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AddEducationBloc {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();

  final _startDateBehaviorSubject = PublishSubject<DateTime>();
  Stream<DateTime> get startDateStream => _startDateBehaviorSubject.stream;
  Sink<DateTime> get startDateSink => _startDateBehaviorSubject.sink;

  final _endDateBehaviorSubject = PublishSubject<DateTime>();
  Stream<DateTime> get endDateStream => _endDateBehaviorSubject.stream;
  Sink<DateTime> get endDateSink => _endDateBehaviorSubject.sink;

  final _errorBehaviorSubject = PublishSubject<String>();
  Stream<String> get errorStream => _errorBehaviorSubject.stream;
  Sink<String> get errorSink => _errorBehaviorSubject.sink;

  dispose() {
    _startDateBehaviorSubject.close();
    _endDateBehaviorSubject.close();
    _errorBehaviorSubject.close();
  }
}

import 'package:flutter/material.dart';

import 'add_education_bloc.dart';

class AddEducationBlocProvider extends InheritedWidget {
  final AddEducationBloc bloc;

  const AddEducationBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AddEducationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddEducationBlocProvider) as AddEducationBlocProvider).bloc;
  }
}

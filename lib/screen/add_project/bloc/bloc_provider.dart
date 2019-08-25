import 'package:flutter/material.dart';

import 'add_project_bloc.dart';

class AddProjectBlocProvider extends InheritedWidget {
  final AddProjectBloc bloc;

  const AddProjectBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AddProjectBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddProjectBlocProvider) as AddProjectBlocProvider).bloc;
  }
}

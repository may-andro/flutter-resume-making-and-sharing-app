import 'package:flutter/material.dart';

import 'add_experience_bloc.dart';

class AddExperienceBlocProvider extends InheritedWidget {
  final AddExperienceBloc bloc;

  const AddExperienceBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AddExperienceBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddExperienceBlocProvider) as AddExperienceBlocProvider).bloc;
  }
}

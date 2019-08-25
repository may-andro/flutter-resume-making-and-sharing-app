import 'package:flutter/material.dart';

import 'add_language_bloc.dart';

class AddLanguageBlocProvider extends InheritedWidget {
  final AddLanguageBloc bloc;

  const AddLanguageBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AddLanguageBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddLanguageBlocProvider) as AddLanguageBlocProvider).bloc;
  }
}

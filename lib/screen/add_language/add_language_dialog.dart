import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_language/bloc/add_language_bloc.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/rounded_button.dart';

import 'bloc/bloc_provider.dart';

class AddLanguageDialog extends StatefulWidget {
  final Language language;

  AddLanguageDialog({this.language});

  @override
  _AddLanguageDialogState createState() => _AddLanguageDialogState();
}

class _AddLanguageDialogState extends State<AddLanguageDialog> {
  TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  AddLanguageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddLanguageBloc();
    _nameController = TextEditingController(text: widget.language != null ? widget.language.name : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddLanguageBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: _buildForm(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Add Language',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomTextFieldForm(
                controller: _nameController,
                hintText: 'You speak ...',
                helperText: 'Language name',
                validator: (val) => val.length == 0 ? 'Empty name' : null,
              ),
              SizedBox(height: 24.0),
              StreamBuilder<double>(
                  stream: _bloc.levelSliderStream,
                  builder: (context, snapshot) {
                    double level = snapshot.hasData ? snapshot.data : 0;
                    return Slider(
                        label: 'Level',
                        value: level,
                        onChanged: (value) {
                          _bloc.levelSliderSink.add(value);
                          _bloc.level = value;
                        });
                  }),
              Align(
                alignment: Alignment.center,
                child: StreamBuilder<double>(
                    stream: _bloc.levelSliderStream,
                    builder: (context, snapshot) {
                      double level = snapshot.hasData ? snapshot.data : 0;
                      return Text(
                        _getLanguageLevel(level * 100),
                        textAlign: TextAlign.center,
                      );
                    }),
              ),
              SizedBox(height: 24.0),
              RoundedButton(
                text: 'Add',
                onPressed: onAddLanguage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddLanguage() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.of(context).pop(
        Language(
          name: _nameController.text,
          level: _getLanguageLevel(_bloc.level * 100),
        ),
      );
    }
  }

  String _getLanguageLevel(double level) {
    if (level < 25) {
      return 'Beginner Level';
    }

    if (level < 50) {
      return 'Conversational Level';
    }

    if (level < 75) {
      return 'Business Level';
    }

    return 'Fluent Level';
  }
}

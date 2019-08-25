import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/date_picker_field.dart';
import 'package:resumepad/widget/rounded_button.dart';

import 'bloc/add_education_bloc.dart';
import 'bloc/bloc_provider.dart';

class AddEducationDialog extends StatefulWidget {
  final Education education;

  AddEducationDialog({this.education});

  @override
  _AddEducationDialogState createState() => _AddEducationDialogState();
}

class _AddEducationDialogState extends State<AddEducationDialog> {
  TextEditingController _universityController;
  TextEditingController _courseController;
  TextEditingController _linkController;
  final _formKey = GlobalKey<FormState>();
  AddEducationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddEducationBloc();
    _universityController = TextEditingController(text: widget.education != null ? widget.education.universityName: '');
    _courseController = TextEditingController(text: widget.education != null ? widget.education.courseTaken: '');
    _linkController = TextEditingController(text: widget.education != null ? widget.education.collegeLink: '');

    _bloc.startDate = widget.education != null ? widget.education.startDate: DateTime.now();
    _bloc.endDate = widget.education != null ? widget.education.endDate: DateTime.now();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddEducationBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: _buildForm(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Add College',
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
                controller: _universityController,
                hintText: 'Name of university ...',
                helperText: 'Your university',
                validator: (val) => val.length == 0 ? 'Empty name' : val.length < 2 ? 'Invalid name' : null,
              ),
              SizedBox(height: 12.0),
              CustomTextFieldForm(
                controller: _linkController,
                hintText: 'University website',
                helperText: 'University link',
                validator: null,
              ),
              SizedBox(height: 12.0),
              CustomTextFieldForm(
                controller: _courseController,
                hintText: 'What course you took?',
                helperText: 'Your course',
                validator: (val) => val.length == 0 ? 'Empty course' : null,
              ),
              SizedBox(height: 12.0),
              _DateRow(),
              SizedBox(height: 24.0),
              RoundedButton(
                text: 'Add',
                onPressed: onAddEducation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddEducation() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_bloc.startDate.isAfter(_bloc.endDate)) {
        _bloc.errorSink.add('Invalid date');
        return;
      }

      Navigator.of(context).pop(
        Education(
          collegeLink: _linkController.text,
          startDate: _bloc.startDate,
          endDate: _bloc.endDate,
          courseTaken: _courseController.text,
          universityName: _universityController.text,
        ),
      );
    }
  }
}

class _DateRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = AddEducationBlocProvider.of(context);
    return StreamBuilder<String>(
        stream: _bloc.errorStream,
        builder: (context, errorSnapshot) {
          String error = errorSnapshot.hasData ? errorSnapshot.data : null;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<DateTime>(
                    stream: _bloc.startDateStream,
                    builder: (context, snapshot) {
                      _bloc.startDate = snapshot.hasData ? snapshot.data : _bloc.startDate;
                      return DatePicker(
                        labelText: 'Start',
                        errorText: error,
                        dateTime: _bloc.startDate,
                        onChanged: (dateTime) => _bloc.startDateSink.add(dateTime),
                      );
                    }),
              ),
              SizedBox(
                width: 24,
              ),
              Expanded(
                child: StreamBuilder<DateTime>(
                    stream: _bloc.endDateStream,
                    builder: (context, snapshot) {
                      _bloc.endDate = snapshot.hasData ? snapshot.data : _bloc.endDate;
                      return DatePicker(
                        labelText: 'End',
                        errorText: error,
                        dateTime: _bloc.endDate,
                        onChanged: (dateTime) => _bloc.endDateSink.add(dateTime),
                      );
                    }),
              ),
            ],
          );
        });
  }

}

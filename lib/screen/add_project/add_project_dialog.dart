import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_project/bloc/bloc_provider.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/date_picker_field.dart';
import 'package:resumepad/widget/rounded_button.dart';

import 'bloc/add_project_bloc.dart';

class AddProjectDialog extends StatefulWidget {
  final Project project;

  AddProjectDialog({this.project});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  TextEditingController _nameController;
  TextEditingController _linkController;
  TextEditingController _summaryController;

  final _formKey = GlobalKey<FormState>();
  AddProjectBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddProjectBloc();

    _nameController = TextEditingController(text: widget.project != null ? widget.project.projectName: '');
    _summaryController = TextEditingController(text: widget.project != null ? widget.project.projectSummary: '');
    _linkController = TextEditingController(text: widget.project != null ? widget.project.projectLink: '');

    _bloc.startDate = widget.project != null ? widget.project.startDate: DateTime.now();
    _bloc.endDate = widget.project != null ? widget.project.endDate: DateTime.now();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _nameController.dispose();
    _summaryController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddProjectBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: _buildForm(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Add Project',
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
                hintText: 'Name of project ...',
                helperText: 'Your project',
                validator: (val) => val.length == 0 ? 'Empty name' : val.length < 2 ? 'Invalid name' : null,
              ),
              SizedBox(height: 12.0),
              CustomTextFieldForm(
                controller: _linkController,
                hintText: 'Project website',
                helperText: 'Project link',
                validator: null,
              ),
              SizedBox(height: 12.0),
              CustomTextFieldForm(
                controller: _summaryController,
                hintText: 'What was your contribution?',
                helperText: 'Project summary',
                validator: null,
                maxLines: 10,
                inputBorder: OutlineInputBorder(),
              ),
              SizedBox(height: 12.0),
              _DateRow(),
              SizedBox(height: 24.0),
              RoundedButton(
                text: 'Add',
                onPressed: onAddProject,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddProject() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_bloc.startDate.isAfter(_bloc.endDate)) {
        _bloc.errorSink.add('Invalid date');
        return;
      }

      Navigator.of(context).pop(
        Project(
          projectLink: _linkController.value.text,
          startDate: _bloc.startDate,
          endDate: _bloc.endDate,
          projectName: _nameController.value.text,
          projectSummary: _summaryController.value.text,
        ),
      );
    }
  }
}

class _DateRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = AddProjectBlocProvider.of(context);
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

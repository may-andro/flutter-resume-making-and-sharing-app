import 'package:flutter/material.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';

class SkillTab extends StatefulWidget {
  @override
  _SkillTabState createState() => _SkillTabState();
}

class _SkillTabState extends State<SkillTab> {
  final TextEditingController _skillController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
	  super.didChangeDependencies();
	  _skillController..addListener(_onTextChange);
  }

  void _onTextChange() {
	  final _bloc = ResumeMakerBlocProvider.of(context);
	  _bloc.skillIconSink.add(true);
  }

  @override
  Widget build(BuildContext context) {
	  return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
      child: buildForm(),
    );
  }

  Widget buildForm() {
	  final _bloc = ResumeMakerBlocProvider.of(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OnBoardingHeaderText(text: 'Skills'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipOval(
                      child: Container(
                          height: 32,
                          width: 32,
                          color: Theme.of(context).primaryColor,
                          child: IconButton(
                            padding: EdgeInsets.all(4),
                            color: Colors.white,
                            onPressed: () => _addSkills(),
                            icon: StreamBuilder<bool>(
                              stream: _bloc.skillIconStream,
                              builder: (context, snapshot) {
                              	IconData iconDate = snapshot.hasData ? snapshot.data ? Icons.done: Icons.add: Icons.add;
                                return Icon(iconDate);
                              }
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextFieldForm(
                  controller: _skillController,
                  hintText: 'Add Skill ...',
                  helperText: 'Your skill',
                  validator: (val) => val.length == 0 ? 'Empty skill' : null,
                ),
              ),
              _buildSkillsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsList() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: StreamBuilder<String>(
          stream: _bloc.skillListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.educationList.isEmpty
                ? Container(
                    child: Text('No skill added'),
                  )
                : Wrap(
                    children: _buildSkillList(_bloc.skillList),
                  );
          }),
    );
  }

  _buildSkillList(List<String> skillList) {
    List<Widget> skills = List();
    skillList.forEach((item) {
      skills.add(Container(
        margin: EdgeInsets.only(right: 12.0, bottom: 4),
        child: Chip(
          deleteIcon: Icon(
            Icons.close,
            size: 16,
            color: Colors.white,
          ),
          label: Text(
            item,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.shortestSide * 0.04,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
          onDeleted: () => _deleteSkills(item),
          elevation: 4,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ));
    });
    return skills;
  }

  void _addSkills() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final _bloc = ResumeMakerBlocProvider.of(context);
      _bloc.skillList.add(_skillController.text);
      _bloc.skillListModifiedSink.add(_skillController.text);
      _bloc.skillList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
      _skillController.text = '';
      _bloc.skillIconSink.add(false);
    }
  }

  void _deleteSkills(String skill) async {
	  FocusScope.of(context).requestFocus(new FocusNode());
	  final _bloc = ResumeMakerBlocProvider.of(context);
	  _bloc.skillList.remove(skill);
	  _bloc.skillListModifiedSink.add(skill);
	  _bloc.skillList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
  }
}

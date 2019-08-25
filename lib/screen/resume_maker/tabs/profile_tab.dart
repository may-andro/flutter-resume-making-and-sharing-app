import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/rounded_button.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  TextEditingController _nameController;
  TextEditingController _designationController;
  TextEditingController _cityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _designationController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _bloc = ResumeMakerBlocProvider.of(context);
    _nameController.text = _bloc.profile != null ? _bloc.profile.name : '';
    _designationController.text = _bloc.profile != null ? _bloc.profile.designation : '';
    _cityController.text = _bloc.profile != null ? _bloc.profile.currentCityAndCountry : '';
    _nameController..addListener(_onNameChange);
    _designationController..addListener(_onDesignationChange);
    _cityController..addListener(_onCityChange);
  }

  void _onNameChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.profile != null && _nameController.text != _bloc.profile.name) {
      _bloc.saveProfileButtonEnableSink.add(true);
      _bloc.nextButtonEnableSink.add(false);
    }
  }

  void _onDesignationChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.profile != null && _designationController.text != _bloc.profile.designation) {
      _bloc.saveProfileButtonEnableSink.add(true);
      _bloc.nextButtonEnableSink.add(false);
    }
  }

  void _onCityChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.profile != null && _cityController.text != _bloc.profile.currentCityAndCountry) {
      _bloc.saveProfileButtonEnableSink.add(true);
      _bloc.nextButtonEnableSink.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _designationController.dispose();
    _cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _nameController,
                  hintText: 'What is your name?',
                  helperText: 'Your name',
                  validator: (val) => val.length == 0 ? 'Empty name' : val.length < 2 ? 'Invalid name' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _designationController,
                  hintText: 'What is your designation?',
                  helperText: 'Your designation',
                  validator: (val) =>
                      val.length == 0 ? 'Empty designation' : val.length < 2 ? 'Invalid designation' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _cityController,
                  hintText: 'City, Country (eg: Madrid, Spain)',
                  helperText: 'Your residing city',
                  validator: (val) => val.length == 0 ? 'Invalid' : null,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              StreamBuilder<bool>(
                  stream: _bloc.saveProfileButtonEnableStream,
                  builder: (context, snapshot) {
                    bool isEnable = snapshot.hasData ? snapshot.data : false;
                    return RoundedButton(
                      text: 'Save',
                      onPressed: isEnable ? _onAddProfile : null,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddProfile() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.userImage == null) {
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _bloc.profile = Profile(
        name: _nameController.text,
        designation: _designationController.text,
        imagePath: _bloc.userImage.path,
        currentCityAndCountry: _cityController.text,
      );
      _bloc.saveProfileButtonEnableSink.add(false);
      _bloc.nextButtonEnableSink.add(true);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/rounded_button.dart';

class ProfileSummaryTab extends StatefulWidget {
  @override
  _ProfileSummaryTabState createState() => _ProfileSummaryTabState();
}

class _ProfileSummaryTabState extends State<ProfileSummaryTab> {
  TextEditingController _summaryController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _summaryController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _bloc = ResumeMakerBlocProvider.of(context);
    _summaryController.text = _bloc.profileSummary != null ? _bloc.profileSummary : '';
    _summaryController..addListener(_onSummaryChange);
  }

  void _onSummaryChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.profileSummary != null && _summaryController.text != _bloc.profileSummary) {
      _bloc.saveProfileSummaryButtonEnableSink.add(true);
      _bloc.nextButtonEnableSink.add(false);
    }
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
              OnBoardingHeaderText(text: 'Summary'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _summaryController,
                  helperText: 'Write few words about you...',
                  hintText: 'Your summary',
                  maxLines: 10,
                  inputBorder: OutlineInputBorder(),
                  validator: (val) => val.length == 0 ? 'Empty summary' : val.length < 2 ? 'Invalid summary' : null,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              StreamBuilder<bool>(
                  stream: _bloc.saveProfileSummaryButtonEnableStream,
                  builder: (context, snapshot) {
                    bool isEnable = snapshot.hasData ? snapshot.data : _bloc.profileSummary != null ? false : true;
                    return RoundedButton(
                      text: 'Save',
                      onPressed: isEnable ? _onAddProfileSummary : null,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddProfileSummary() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _bloc.profileSummary = _summaryController.text;
      _bloc.saveProfileSummaryButtonEnableSink.add(false);
      _bloc.nextButtonEnableSink.add(true);
    }
  }
}

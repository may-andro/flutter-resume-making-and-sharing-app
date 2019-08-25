import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/widget/country_code_picker.dart';
import 'package:resumepad/widget/custom_text_feild_form.dart';
import 'package:resumepad/widget/rounded_button.dart';

class ContactTab extends StatefulWidget {
  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _linkedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _bloc = ResumeMakerBlocProvider.of(context);
    _emailController.text = _bloc.contact != null ? _bloc.contact.email : _emailController.text;
    _emailController..addListener(_onEmailChange);

    _phoneController.text = _bloc.contact != null ? _bloc.contact.phone : _phoneController.text;
    _phoneController..addListener(_onPhoneChange);

    _linkedController.text = _bloc.contact != null ? _bloc.contact.linkedin : _linkedController.text;
    _linkedController..addListener(_onLinkedInChange);

    _codeController.text = _bloc.contact != null ? _bloc.contact.countryCode : _codeController.text;
    _codeController..addListener(_onCodeChnage);
  }

  void _onEmailChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.contact != null && _emailController.text != _bloc.contact.email) {
      _bloc.enableSaveContactButton(true);
    }
  }

  void _onPhoneChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.contact != null && _phoneController.text != _bloc.contact.phone) {
      _bloc.enableSaveContactButton(true);
    }
  }

  void _onLinkedInChange() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_bloc.contact != null && _linkedController.text != _bloc.contact.linkedin) {
      _bloc.enableSaveContactButton(true);
    }
  }

  void _onCodeChnage() {
	  final _bloc = ResumeMakerBlocProvider.of(context);
	  if (_bloc.contact != null && _codeController.text != _bloc.contact.countryCode) {
		  _bloc.enableSaveContactButton(true);
	  }
  }


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OnBoardingHeaderText(text: 'Contact'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _emailController,
                  hintText: 'Whats is your email?',
                  helperText: 'Your email',
                  textInputType: TextInputType.emailAddress,
                  validator: (val) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(val))
                      return 'Enter Valid Email';
                    else
                      return null;
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: _showCountryDialog,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16),
                      child: IgnorePointer(
                        child: Container(
                          width: 75,
                          child: CustomTextFieldForm(
                            controller: _codeController,
                            hintText: '(     )',
                            helperText: 'code',
                            maxLength: 8,
                            textInputType: TextInputType.phone,
                            readOnly: true,
                            validator: (val) => val.length == 0 ? 'Code' : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: CustomTextFieldForm(
                          controller: _phoneController,
                          hintText: 'Enter mobile digits?',
                          helperText: 'Your mobile number',
                          textInputType: TextInputType.phone,
                          validator: (val) =>
                              val.length == 0 ? 'Empty mobile number' : val.length < 9 ? 'Invalid mobile number' : null,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(10),
                          ]),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomTextFieldForm(
                  controller: _linkedController,
                  hintText: 'Enter your LinkedIn profile',
                  helperText: 'Your LinkedIn',
                  validator: (val) => val.length == 0 ? 'Empty link' : null,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              StreamBuilder<bool>(
                  stream: _bloc.saveContactButtonEnableStream,
                  builder: (context, snapshot) {
                    bool isEnable = snapshot.hasData ? snapshot.data : _bloc.contact != null ? false : true;
                    return RoundedButton(
                      text: 'Save',
                      onPressed: isEnable ? _onAddContact : null,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddContact() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final _bloc = ResumeMakerBlocProvider.of(context);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _bloc.contact = Contact(
          email: _emailController.text,
          phone: _phoneController.text,
          linkedin: _linkedController.text,
          countryCode: _codeController.text);
      _bloc.enableSaveContactButton(false);
    }
  }

  void _showCountryDialog() {
    showDialog(
      context: context,
      builder: (_) => SelectionDialog(),
    ).then((e) {
      if (e != null) {
        _codeController.text = e.toString();
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_language/add_language_dialog.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/utility/color_utility.dart';

class LanguageTab extends StatefulWidget {
  @override
  _LanguageTabState createState() => _LanguageTabState();
}

class _LanguageTabState extends State<LanguageTab> {
  final TextEditingController summaryController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OnBoardingHeaderText(text: 'Language'),
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
                        onPressed: () => _showAddLanguageDialog(null, 0),
                        icon: const Icon(Icons.add),
                      )),
                ),
              ),
            ],
          ),
          Expanded(child: _buildLanguageList()),
        ],
      ),
    );
  }

  Widget _buildLanguageList() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: StreamBuilder<Language>(
          stream: _bloc.languageListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.languageList.isEmpty
                ? Container(
                    child: Text('No language added'),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _bloc.languageList[index] != null
                          ? _LanguageCard(
                              language: _bloc.languageList[index],
                              onTap: () => _showAddLanguageDialog(
                                _bloc.languageList[index],
                                index,
                              ),
                            )
                          : Offstage();
                    },
                    itemCount: _bloc.languageList.length,
                  );
          }),
    );
  }

  Future _showAddLanguageDialog(Language tempLanguage, int index) async {
    Language language = await Navigator.of(context).push(
      MaterialPageRoute<Language>(
          builder: (BuildContext context) {
            return AddLanguageDialog(
              language: tempLanguage,
            );
          },
          fullscreenDialog: true),
    );

    if(language != null) {
	    final _bloc = ResumeMakerBlocProvider.of(context);
	    if (tempLanguage != null) {
		    _bloc.languageList[index] = language;
	    } else {
		    _bloc.languageList.add(language);
	    }

	    _bloc.languageList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
	    _bloc.languageListModifiedSink.add(language);
    }
  }
}

class _LanguageCard extends StatelessWidget {
  final Language language;
  final Function onTap;

  _LanguageCard({
    @required this.language,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(language.toString()),
      background: new Container(
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: new Align(
            alignment: Alignment.centerRight,
            child: new Text('Delete', textAlign: TextAlign.right, style: new TextStyle(color: Colors.white)),
          )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final _bloc = ResumeMakerBlocProvider.of(context);
        _bloc.languageList.remove(language);
        _bloc.languageListModifiedSink.add(language);
        _bloc.languageList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
      },
      child: _tapableContent(context),
    );
  }

  _tapableContent(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
	        width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${language != null ? language.name : ''}',
                    style: TextStyle(
                        color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                        fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
                        letterSpacing: 0.8),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    language != null ? language.level : '',
                    style: TextStyle(
                        color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                        fontSize: MediaQuery.of(context).size.shortestSide * 0.04,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

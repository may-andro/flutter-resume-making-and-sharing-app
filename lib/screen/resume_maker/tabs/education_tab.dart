import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/add_education/add_education_dialog.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/utility/color_utility.dart';

class EducationTab extends StatefulWidget {
  @override
  _EducationTabState createState() => _EducationTabState();
}

class _EducationTabState extends State<EducationTab> {
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
              OnBoardingHeaderText(text: 'Education'),
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
                        onPressed: () => _showAddEducationDialog(null, 0),
                        icon: const Icon(Icons.add),
                      )),
                ),
              ),
            ],
          ),
          Expanded(child: _buildEducationList()),
        ],
      ),
    );
  }

  Widget _buildEducationList() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: StreamBuilder<Education>(
          stream: _bloc.educationListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.educationList.isEmpty
                ? Container(
                    child: Text('No educartion added'),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
	                    return _bloc.educationList[index] != null ?  _EducationCard(
                        education: _bloc.educationList[index],
                        onTap: () => _showAddEducationDialog(
                          _bloc.educationList[index],
                          index,
                        ),
                      ): Offstage();
                    },
                    itemCount: _bloc.educationList.length,
                  );
          }),
    );
  }

  Future _showAddEducationDialog(Education tempEducation, int index) async {
    Education education = await Navigator.of(context).push(
      MaterialPageRoute<Education>(
          builder: (BuildContext context) {
            return AddEducationDialog(
              education: tempEducation,
            );
          },
          fullscreenDialog: true),
    );

    if(education == null) return;

    final _bloc = ResumeMakerBlocProvider.of(context);
    if(tempEducation != null) {
	    _bloc.educationList[index] = education;
    } else {
	    _bloc.educationList.add(education);
    }

    _bloc.educationList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
    _bloc.educationListModifiedSink.add(education);
  }
}

class _EducationCard extends StatelessWidget {
  final Education education;
  final Function onTap;

  _EducationCard({
    @required this.education,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(education.toString()),
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
        _bloc.educationList.remove(education);
        _bloc.educationListModifiedSink.add(education);
        _bloc.educationList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
      },
      child: _tapableContent(context),
    );
  }

  _tapableContent(BuildContext context) => InkWell(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${education != null ? education.courseTaken: ''}',
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
	                education != null ? education.universityName: '',
                  style: TextStyle(
                      color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                      fontSize: MediaQuery.of(context).size.shortestSide * 0.04,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8),
                  softWrap: true,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${DateFormat.yMMM().format(education.startDate)} - ',
                      style: TextStyle(
                          color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                          fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
                          letterSpacing: 0.8),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                    Text(
	                    education.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(education.endDate),
                      style: TextStyle(
                          color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                          fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
                          letterSpacing: 0.8),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_experience/add_experience_dialog.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/utility/color_utility.dart';

class ExperienceTab extends StatefulWidget {
  @override
  _ExperienceTabState createState() => _ExperienceTabState();
}

class _ExperienceTabState extends State<ExperienceTab> {
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
              OnBoardingHeaderText(text: 'Experience'),
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
                        onPressed: () => _showAddExperienceDialog(null, 0),
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
      child: StreamBuilder<Experience>(
          stream: _bloc.experienceListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.experienceList.isEmpty
                ? Container(
                    child: Text('No experience added'),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _ExperienceCard(
                        experience: _bloc.experienceList[index],
                        onTap: () => _showAddExperienceDialog(
                          _bloc.experienceList[index],
                          index,
                        ),
                      );
                    },
                    itemCount: _bloc.experienceList.length,
                  );
          }),
    );
  }

  Future _showAddExperienceDialog(Experience tempExperience, int index) async {
    Experience experience = await Navigator.of(context).push(
      MaterialPageRoute<Experience>(
          builder: (BuildContext context) {
            return AddExperienceDialog(
	            experience: tempExperience,
            );
          },
          fullscreenDialog: true),
    );

    if(experience == null) return;

    final _bloc = ResumeMakerBlocProvider.of(context);
    if (tempExperience != null) {
      _bloc.experienceList[index] = experience;
    } else {
      _bloc.experienceList.add(experience);
    }

    _bloc.experienceList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
    _bloc.experienceListModifiedSink.add(experience);
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final Function onTap;

  _ExperienceCard({@required this.experience, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(experience.toString()),
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
        _bloc.experienceList.remove(experience);
        _bloc.experienceListModifiedSink.add(experience);
        _bloc.experienceList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
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
                  '${experience != null ? experience.companyName : ''}',
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
                  experience != null ? experience.summary : '',
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
                      '${DateFormat.yMMM().format(experience.startDate)} - ',
                      style: TextStyle(
                          color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                          fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
                          letterSpacing: 0.8),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                    Text(
	                    experience.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(experience.endDate),
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

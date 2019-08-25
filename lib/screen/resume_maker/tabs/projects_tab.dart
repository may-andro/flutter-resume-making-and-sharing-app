import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_project/add_project_dialog.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/utility/color_utility.dart';

class ProjectTab extends StatefulWidget {
  @override
  _ProjectTabState createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
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
              OnBoardingHeaderText(text: 'Project'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipOval(
                  child: Container(
                      height: 32,
                      width: 32,
                      color: Theme.of(context).primaryColor,
                      child: IconButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(4),
                        onPressed: () => _showAddProjectDialog(null, 0),
                        icon: const Icon(Icons.add),
                      )),
                ),
              ),
            ],
          ),
          Expanded(child: _buildProjectList()),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: StreamBuilder<Project>(
          stream: _bloc.projectListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.projectList.isEmpty
                ? Container(
                    child: Text('No project added'),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _ProjectCard(
                        project: _bloc.projectList[index],
                        onTap: () => _showAddProjectDialog(
                          _bloc.projectList[index],
                          index,
                        ),
                      );
                    },
                    itemCount: _bloc.projectList.length,
                  );
          }),
    );
  }

  Future _showAddProjectDialog(Project tempProject, int index) async {
    Project project = await Navigator.of(context).push(
      MaterialPageRoute<Project>(
          builder: (BuildContext context) {
            return AddProjectDialog(
              project: tempProject,
            );
          },
          fullscreenDialog: true),
    );

    if( project != null) {
	    final _bloc = ResumeMakerBlocProvider.of(context);
	    if (tempProject != null) {
		    _bloc.projectList[index] = project;
	    } else {
		    _bloc.projectList.add(project);
	    }

	    _bloc.projectList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
	    _bloc.projectListModifiedSink.add(project);
    }
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final Function onTap;

  _ProjectCard({
    @required this.project,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(project.toString()),
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
        _bloc.projectList.remove(project);
        _bloc.projectListModifiedSink.add(project);
        _bloc.projectList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
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
                  '${project != null ? project.projectName : ''}',
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
                  project != null ? project.projectSummary : '',
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
                      '${DateFormat.yMMM().format(project.startDate)} - ',
                      style: TextStyle(
                          color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                          fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
                          letterSpacing: 0.8),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                    Text(
	                    project.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(project.endDate),
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

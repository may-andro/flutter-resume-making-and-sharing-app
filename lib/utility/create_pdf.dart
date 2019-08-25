import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as ImageLibrary;
import 'package:resumepad/model/resume_model.dart';

getPdf(Resume resume) async {
  final Document pdf = Document();
  final img = ImageLibrary.decodeImage(File("${resume.profile.imagePath}").readAsBytesSync());
  final image = PdfImage(
    pdf.document,
    image: img.data.buffer.asUint8List(),
    width: img.width,
    height: img.height,
  );

  final pageWidth = 21.0 * PdfPageFormat.cm;
  final pageHeight = 29.7 * PdfPageFormat.cm;

  getDivider() => Container(color: PdfColors.black, margin: EdgeInsets.all(8), height: 1, width: pageWidth);

  getExperienceItem(Context context, Experience experience) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${experience.companyName}',
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: experience.companyLink),
        SizedBox(height: 1),
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(experience.designation, style: Theme.of(context).paragraphStyle),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  '${DateFormat.yMMM().format(experience.startDate)} - ${experience.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(experience.endDate)}',
                  style: Theme.of(context).paragraphStyle),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${experience.summary}',
            style: Theme.of(context).tableCell,
            textAlign: TextAlign.justify,
          ),
        ),
      ],),);

  List<Widget> _buildExperienceList(Context context) {
    List<Widget> experienceWidgetList = List();
    resume.experiences.forEach((item) {
      experienceWidgetList.add(getExperienceItem(context, item));
    });

    experienceWidgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Experience', style: Theme.of(context).header3),
      ),
    );

    experienceWidgetList.insert(
      1,
      getDivider(),
    );

    return experienceWidgetList;
  }

  getExperience(Context context) => Column(children: _buildExperienceList(context));

  getEducationItem(Context context, Education education) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${education.courseTaken}',
            style: Theme.of(context).header5,
          ),
        ),
        SizedBox(height: 1),
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${education.universityName}',
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: education.collegeLink),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${DateFormat.yMMM().format(education.startDate)} - ${education.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(education.endDate)}',
            style: Theme.of(context).paragraphStyle,
          ),
        ),
      ]));

  List<Widget> _buildEducationList(Context context) {
    List<Widget> widgetList = List();
    resume.educations.forEach((item) {
      widgetList.add(getEducationItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Education', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getEducation(Context context) => Column(children: _buildEducationList(context));

  getProjectItem(Context context, Project project) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                project.projectName,
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: project.projectLink),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${DateFormat.yMMM().format(project.startDate)} - ${project.endDate.difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(project.endDate)}',
            style: Theme.of(context).paragraphStyle,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            project.projectSummary,
            textAlign: TextAlign.justify,
            style: Theme.of(context).tableCell,
          ),
        ),
      ]));

  List<Widget> _buildProjectList(Context context) {
    List<Widget> widgetList = List();
    resume.projects.forEach((item) {
      widgetList.add(getProjectItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Project', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getProjects(Context context) => Column(children: _buildProjectList(context));

  getReferenceItem(Context context, Reference reference) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            reference.name,
            style: Theme.of(context).header5,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${reference.company}',
            style: Theme.of(context).bulletStyle,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Email: ${reference.email}',
            style: Theme.of(context).paragraphStyle,
          ),
        ),
      ]));

  List<Widget> _buildReferenceList(Context context) {
    List<Widget> widgetList = List();
    resume.references.forEach((item) {
      widgetList.add(getReferenceItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Reference', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getReference(Context context) => Column(
        children: _buildReferenceList(context),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );

  getSkillsItem(Context context, String skill) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Text(
        skill,
        style: Theme.of(context).bulletStyle,
        textAlign: TextAlign.left,
      ));

  List<Widget> _buildSkillList(Context context) {
    List<Widget> widgetList = List();
    resume.skills.forEach((item) {
      widgetList.add(getSkillsItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Skill', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getSkills(Context context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildSkillList(context),
      );

  getLanguageItem(Context context, Language language) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Column(
        children: <Widget>[
          Text(
            '${language.name}',
            style: Theme.of(context).paragraphStyle,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 1),
          Text(
            '${language.level}',
            style: Theme.of(context).bulletStyle,
            textAlign: TextAlign.left,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ));

  List<Widget> _buildLanguageList(Context context) {
    List<Widget> widgetList = List();
    resume.languages.forEach((item) {
      widgetList.add(getLanguageItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Language', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getLanguage(Context context) => Column(
        children: _buildLanguageList(context),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );

  getContact(Context context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Contact', style: Theme.of(context).header3),
            ),
            getDivider(),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '${resume.profile.currentCityAndCountry}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '${resume.contact.countryCode} ${resume.contact.phone}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '${resume.contact.email}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: UrlLink(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LinkedIn',
                      style: Theme.of(context).bulletStyle.copyWith(color: PdfColors.blue),
                    ),
                  ),
                  destination: resume.contact.linkedin),
            ),
          ]);

  getMainRowItem(Context context) => Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            width: pageWidth * 0.6,
            child: Column(
              children: <Widget>[
                getExperience(context),
                SizedBox(height: 12),
                getProjects(context),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getContact(context),
                  SizedBox(height: 12),
                  getEducation(context),
                  SizedBox(height: 12),
                  getSkills(context),
                  SizedBox(height: 12),
                  getLanguage(context),
                  SizedBox(height: 12),
                  getReference(context),
                  SizedBox(height: 12),
                ],
              ),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );

  _getProfileImage(Context context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        width: pageHeight * 0.125,
        height: pageHeight * 0.125,
        decoration: BoxDecoration(
          image: DecorationImage(image: image),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  _getSummary(Context context) {
    return Positioned(
      top: 16,
      left: pageHeight * 0.15 + 16,
      right: 16,
      bottom: pageHeight * 0.075,
      child: Container(
          child: Column(children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Summary',
                style: Theme.of(context).header3,
                textAlign: TextAlign.justify,
              ),
            ),
            getDivider(),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                resume.profileSummary,
                style: Theme.of(context).tableCell,
                softWrap: true,
              ),
            ),
          ])),
    );
  }

  _getName(Context context) {
    return Positioned(
      top: pageHeight * 0.15,
      left: 0,
      child: Container(
        padding: EdgeInsets.only(left: 16),
        alignment: Alignment.bottomLeft,
        height: pageHeight * 0.05,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  resume.profile.name,
                  style: Theme.of(context).header2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  resume.profile.designation,
                  style: Theme.of(context).header5,
                ),
              ),
            ]),
      ),
    );
  }

  getProfileRow(Context context) => Container(
        height: pageHeight * 0.2,
        child: Stack(children: <Widget>[
          _getProfileImage(context),
          _getSummary(context),
          _getName(context),
        ]),
      );

  pdf.addPage(
    MultiPage(
        pageFormat: PdfPageFormat(pageWidth, pageHeight, marginAll: 0),
        crossAxisAlignment: CrossAxisAlignment.start,
        build: (Context context) => <Widget>[
              getProfileRow(context),
              SizedBox(height: 8),
              getMainRowItem(context),
            ]),
  );

  final path = await getApplicationDocumentsDirectory();
  final file = File("${path.path}/${resume.profile.name.replaceAll(' ', '_')}.pdf");
  file.writeAsBytesSync(pdf.save());
}

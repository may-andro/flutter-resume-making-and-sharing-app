import 'dart:async';
import 'dart:io';

import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/utility/constants.dart';
import 'package:resumepad/utility/create_pdf.dart';
import 'package:rxdart/rxdart.dart';

class ResumeMakerBloc {
  //String to store navigationId
  int currentPage = NAVIGATE_TO_PROFILE_TAB;
  List<Education> educationList = List();
  List<Experience> experienceList = List();
  List<Project> projectList = List();
  List<String> skillList = List();
  List<Reference> referenceList = List();
  List<Language> languageList = List();
  Profile profile;
  File userImage;
  String profileSummary;
  Contact contact;

  final _mainPagerBehaviorSubject = PublishSubject<double>();

  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;

  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();

  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;

  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _errorBehaviorSubject = PublishSubject<String>();

  Stream<String> get errorStream => _errorBehaviorSubject.stream.asBroadcastStream();

  Sink<String> get errorSink => _errorBehaviorSubject.sink;

  final _pictureClickBehaviorSubject = PublishSubject<File>();

  Stream<File> get pictureClickStream => _pictureClickBehaviorSubject.stream.asBroadcastStream();

  Sink<File> get pictureClickSink => _pictureClickBehaviorSubject.sink;

  final _educationListModifiedBehaviorSubject = PublishSubject<Education>();

  Stream<Education> get educationListModifiedStream => _educationListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<Education> get educationListModifiedSink => _educationListModifiedBehaviorSubject.sink;

  final _experienceListModifiedBehaviorSubject = PublishSubject<Experience>();

  Stream<Experience> get experienceListModifiedStream =>
      _experienceListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<Experience> get experienceListModifiedSink => _experienceListModifiedBehaviorSubject.sink;

  final _projectListModifiedBehaviorSubject = PublishSubject<Project>();

  Stream<Project> get projectListModifiedStream => _projectListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<Project> get projectListModifiedSink => _projectListModifiedBehaviorSubject.sink;

  final _skillListModifiedBehaviorSubject = PublishSubject<String>();

  Stream<String> get skillListModifiedStream => _skillListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<String> get skillListModifiedSink => _skillListModifiedBehaviorSubject.sink;

  final _referenceListModifiedBehaviorSubject = PublishSubject<Reference>();

  Stream<Reference> get referenceListModifiedStream => _referenceListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<Reference> get referenceListModifiedSink => _referenceListModifiedBehaviorSubject.sink;

  final _languageListModifiedBehaviorSubject = PublishSubject<Language>();

  Stream<Language> get languageListModifiedStream => _languageListModifiedBehaviorSubject.stream.asBroadcastStream();

  Sink<Language> get languageListModifiedSink => _languageListModifiedBehaviorSubject.sink;

  final _nextButtonEnableBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get nextButtonEnableStream => _nextButtonEnableBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get nextButtonEnableSink => _nextButtonEnableBehaviorSubject.sink;

  final _saveProfileButtonEnableBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get saveProfileButtonEnableStream => _saveProfileButtonEnableBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get saveProfileButtonEnableSink => _saveProfileButtonEnableBehaviorSubject.sink;

  final _saveProfileSummaryButtonEnableBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get saveProfileSummaryButtonEnableStream =>
      _saveProfileSummaryButtonEnableBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get saveProfileSummaryButtonEnableSink => _saveProfileSummaryButtonEnableBehaviorSubject.sink;

  final _saveContactButtonEnableBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get saveContactButtonEnableStream => _saveContactButtonEnableBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get saveContactButtonEnableSink => _saveContactButtonEnableBehaviorSubject.sink;

  final _skillIconBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get skillIconStream => _skillIconBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get skillIconSink => _skillIconBehaviorSubject.sink;

  final _previewButtonVisibilityBehaviorSubject = PublishSubject<bool>();

  Stream<bool> get previewButtonVisibilityStream => _previewButtonVisibilityBehaviorSubject.stream.asBroadcastStream();

  Sink<bool> get previewButtonVisibilitySink => _previewButtonVisibilityBehaviorSubject.sink;

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _errorBehaviorSubject.close();
    _pictureClickBehaviorSubject.close();
    _educationListModifiedBehaviorSubject.close();
    _experienceListModifiedBehaviorSubject.close();
    _projectListModifiedBehaviorSubject.close();
    _nextButtonEnableBehaviorSubject.close();
    _saveProfileButtonEnableBehaviorSubject.close();
    _saveProfileSummaryButtonEnableBehaviorSubject.close();
    _saveContactButtonEnableBehaviorSubject.close();
    _skillListModifiedBehaviorSubject.close();
    _referenceListModifiedBehaviorSubject.close();
    _languageListModifiedBehaviorSubject.close();
    _skillIconBehaviorSubject.close();
    _previewButtonVisibilityBehaviorSubject.close();
  }

  navigateToNextPageIfPossible() {
    switch (currentPage) {
      case NAVIGATE_TO_PROFILE_TAB:
        {
          currentPage = NAVIGATE_TO_PROFILE_SUMMARY_TAB;
          profileSummary != null  && profileSummary.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);

          break;
        }

      case NAVIGATE_TO_PROFILE_SUMMARY_TAB:
        {
          currentPage = NAVIGATE_TO_CONTACT_TAB;
          contact != null ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          break;
        }

      case NAVIGATE_TO_CONTACT_TAB:
        {
          currentPage = NAVIGATE_TO_EDUCATION_TAB;
          educationList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          break;
        }

      case NAVIGATE_TO_EDUCATION_TAB:
        {
          experienceList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_EXPERIENCE_TAB;
          break;
        }

      case NAVIGATE_TO_EXPERIENCE_TAB:
        {
          projectList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_PROJECTS_TAB;
          break;
        }

      case NAVIGATE_TO_PROJECTS_TAB:
        {
          skillList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_SKILLS_TAB;
          break;
        }

      case NAVIGATE_TO_SKILLS_TAB:
        {
          referenceList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_REFERENCES_TAB;
          break;
        }

      case NAVIGATE_TO_REFERENCES_TAB:
        {
          languageList.isNotEmpty ? nextButtonEnableSink.add(true) : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_LANGUAGE_TAB;
          break;
        }

      case NAVIGATE_TO_LANGUAGE_TAB:
        {
          currentPage = NAVIGATE_TO_ALL_DONE_TAB;
          break;
        }

      case NAVIGATE_TO_ALL_DONE_TAB:
        {
          break;
        }

      default:
        currentPage = NAVIGATE_TO_PROFILE_TAB;
    }
    pageNavigationSink.add(currentPage);
  }

  navigateToPreviousPageIfPossible() {
    nextButtonEnableSink.add(true);
    currentPage -= 1;
    pageNavigationSink.add(currentPage);
  }

  enableSaveContactButton(bool isEnable) {
    saveContactButtonEnableSink.add(isEnable);
    nextButtonEnableSink.add(!isEnable);
  }

  Future createPdf() async{
    Resume resume = Resume(
      profile: profile,
      profileSummary: profileSummary,
      contact: contact,
      educations: educationList,
      experiences: experienceList,
      projects: projectList,
      references: referenceList,
      languages: languageList,
      skills: skillList,
    );
    await getPdf(resume);
  }
}

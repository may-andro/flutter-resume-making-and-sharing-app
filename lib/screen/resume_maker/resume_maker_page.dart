import 'package:flutter/material.dart';
import 'package:resumepad/screen/resume_maker/tabs/all_done_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/contact_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/education_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/experience_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/language_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/profile_summary_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/profile_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/projects_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/reference_tab.dart';
import 'package:resumepad/screen/resume_maker/tabs/skills_tab.dart';
import 'package:resumepad/screen/resume_maker/widget/page_indicator.dart';
import 'package:resumepad/screen/resume_maker/widget/previous_page_button.dart';
import 'package:resumepad/screen/resume_maker/widget/user_name_widget.dart';
import 'package:resumepad/screen/resume_maker/widget/user_picture_widget.dart';
import 'package:resumepad/screen/resume_maker/widget/next_page_button.dart';
import 'package:resumepad/utility/constants.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/resume_maker_bloc.dart';

const _submitAnimationTime = 300;

class ResumeMakerPage extends StatefulWidget {
  @override
  _ResumeMakerPageState createState() => _ResumeMakerPageState();
}

class _ResumeMakerPageState extends State<ResumeMakerPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  ResumeMakerBloc _bloc;
  PageController _pageController;

  Future _navigateToPage(int page) async {
    _pageController.animateToPage(page, duration: Duration(milliseconds: _submitAnimationTime), curve: Curves.linear);
    _bloc.currentPage = page;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    _bloc = ResumeMakerBloc();
    _bloc.pageNavigationStream.listen(_navigateToPage);
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloc.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResumeMakerBlocProvider(
      bloc: _bloc,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _createPager(),
              UserPictureWidget(_animationController),
              NextPageButton(),
              PreviousPageButton(),
              UserNameWidget(),
              StreamBuilder<int>(
                  stream: _bloc.pageNavigationStream,
                  builder: (context, snapshot) {
                    return Positioned(
                      right: 16,
                      top: 36,
                      child: DotsIndicator(
                        dotsCount: 10,
                        position: snapshot.hasData ? snapshot.data : 0,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  _createPager() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _bloc.mainPagerSink.add(_pageController.page);
        }
        return true;
      },
      child: PageView(
        onPageChanged: (pos) {
          _bloc.pageNavigationSink.add(pos);
          _bloc.currentPage = pos;
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        children: <Widget>[
          ProfileTab(),
          ProfileSummaryTab(),
          ContactTab(),
          EducationTab(),
          ExperienceTab(),
          ProjectTab(),
          SkillTab(),
          ReferenceTab(),
          LanguageTab(),
          AllDoneTab(),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}

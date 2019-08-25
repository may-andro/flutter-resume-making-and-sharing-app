import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resumepad/screen/preview_resume/preview_resume_page.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/utility/color_utility.dart';
import 'package:resumepad/widget/rounded_button.dart';

class AllDoneTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
      child: _buildContent(context),
    );
  }

  _buildContent(BuildContext context) {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            'You are finished with data filling.\n\nClick on preview to see your resume.',
            style: TextStyle(
                color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
                letterSpacing: 0.8),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(),
        StreamBuilder<bool>(
            stream: _bloc.previewButtonVisibilityStream,
            builder: (context, snapshot) {
              var isButtonVisible = snapshot.hasData ? snapshot.data : true;

              return isButtonVisible
                  ? RoundedButton(
                      text: 'See Preview',
                      onPressed: () => _createFile(context),
                    )
                  : Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text(
                          'Preparing your resume ...',
                          style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
                        )
                      ],
                    );
            }),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }

  _createFile(BuildContext context) async {
    final _bloc = ResumeMakerBlocProvider.of(context);
    _bloc.previewButtonVisibilitySink.add(false);
    _bloc.createPdf().then((val) {
      _previewPdfFile(context, _bloc.profile.name);
    });
  }

  _previewPdfFile(BuildContext context, String name) {
    getApplicationDocumentsDirectory().then((value) {
      final _bloc = ResumeMakerBlocProvider.of(context);
      _bloc.previewButtonVisibilitySink.add(true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: '${value.path}/${name.replaceAll(' ', '_')}.pdf')),
      );
    });
  }
}

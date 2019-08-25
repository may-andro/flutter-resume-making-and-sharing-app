import 'package:flutter/material.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/bloc/resume_maker_bloc.dart';

class PreviousPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Positioned(
      bottom: 64,
      right: 24,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
            return Transform.translate(
              offset: Offset(-_getXOffset(pageOffset, MediaQuery.of(context).size.width),
                  _getYOffset(pageOffset, MediaQuery.of(context).size.height)),
              child: ClipOval(
                child: Container(
                    height: 32,
                    width: 32,
                    color: Theme.of(context).primaryColor,
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      color: Colors.white,
                      onPressed: () {
                        _bloc.navigateToPreviousPageIfPossible();
                      },
                      icon: const Icon(Icons.keyboard_arrow_up),
                    )),
              ),
            );
          }),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = -width * 0.1;
    if (pageOffset >= 0 && pageOffset <= 1) {
      xOffset = width * 0.4 * (pageOffset - 1);
    } else {
      xOffset = 0;
    }
    return xOffset;
  }

  double _getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset > 8 && pageOffset <= 9) {
      yOffset = 40 * (pageOffset - 8);
    }
    return yOffset;
  }
}

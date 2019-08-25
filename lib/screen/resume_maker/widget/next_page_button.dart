import 'package:flutter/material.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';

class NextPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Positioned(
      bottom: 24,
      right: 24,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
            return Transform.translate(
              offset: Offset(_getXOffset(pageOffset, MediaQuery.of(context).size.width), 0),
              child: ClipOval(
                child: StreamBuilder<bool>(
                    stream: _bloc.nextButtonEnableStream,
                    builder: (context, snapshotEnable) {
                      var isEnable = snapshotEnable.hasData ? snapshotEnable.data : false;
                      return Container(
                          height: 32,
                          width: 32,
                          color: isEnable ? Theme.of(context).primaryColor : Colors.grey,
                          child: IconButton(
                            padding: EdgeInsets.all(4),
                            color: Colors.white,
                            onPressed: isEnable ? () => _bloc.navigateToNextPageIfPossible() : null,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ));
                    }),
              ),
            );
          }),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 8 && pageOffset <= 9) {
      xOffset = width * 0.4 * (pageOffset - 8);
    }
    return xOffset;
  }
}

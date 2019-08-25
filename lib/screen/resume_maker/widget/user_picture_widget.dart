import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/bloc/resume_maker_bloc.dart';
import 'package:resumepad/utility/constants.dart';

const widthFactor = 0.7;
const heightFactor = 0.15;
const scaleFactor = 0.5;

class UserPictureWidget extends StatelessWidget {
  final AnimationController controller;

  UserPictureWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.4,
            child: getImageContainer(context),
          );
        },
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black87.withOpacity(1 - controller.value),
      ),
    );
  }

  getImageContainer(BuildContext context) {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return StreamBuilder<double>(
        stream: _bloc.mainPagerStream,
        builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
          double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
          return Transform.scale(
            scale: _getScaleOffset(pageOffset),
            child: Transform.translate(
              offset: Offset(-_getXOffset(pageOffset, MediaQuery.of(context).size.width),
                  -_getYOffset(pageOffset, MediaQuery.of(context).size.height)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _buildContainer(MediaQuery.of(context).size.shortestSide * 0.46 * controller.value),
                  _buildContainer(MediaQuery.of(context).size.shortestSide * 0.52 * controller.value),
                  _buildContainer(MediaQuery.of(context).size.shortestSide * 0.60 * controller.value),
                  Container(
                    height: MediaQuery.of(context).size.shortestSide * 0.4,
                    width: MediaQuery.of(context).size.shortestSide * 0.4,
                    child: InkWell(
                      onTap: _bloc.currentPage == NAVIGATE_TO_PROFILE_TAB ? () => getImage(_bloc) : null,
                      child: Card(
                        elevation: (1 + pageOffset) * 4,
                        clipBehavior: Clip.antiAlias,
                        shape: CircleBorder(side: BorderSide(color: Colors.grey.shade200, width: 2)),
                        child: StreamBuilder<File>(
                            stream: _bloc.pictureClickStream,
                            builder: (context, snapshot) {
                              var image = snapshot.hasData ? snapshot.data : _bloc.userImage;
                              return image != null
                                  ? Image.file(image)
                                  : Icon(
                                      Icons.add_a_photo,
                                      size: MediaQuery.of(context).size.shortestSide * 0.2,
                                    );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ResumeMakerBloc _bloc) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      toolbarTitle: 'Crop',
      toolbarColor: Colors.blue,
      toolbarWidgetColor: Colors.white,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    _bloc.userImage = croppedFile;
    _bloc.pictureClickSink.add(croppedFile);
    _bloc.saveProfileButtonEnableSink.add(true);
    _bloc.nextButtonEnableSink.add(false);
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset >= 1 && pageOffset <= 2) {
      xOffset = width * widthFactor * (pageOffset - 1);
    } else if (pageOffset > 8 && pageOffset <= 9) {
      xOffset = -width * widthFactor * (pageOffset - 9);
    } else if (pageOffset < 1) {
      xOffset = 0;
    } else {
      xOffset = width * widthFactor;
    }
    return xOffset;
  }

  double _getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset <= 1) {
      yOffset = height * heightFactor * pageOffset;
    } else if (pageOffset > 8 && pageOffset <= 9) {
      yOffset = height * heightFactor * (9 - pageOffset);
    } else {
      yOffset = height * heightFactor;
    }
    return yOffset;
  }

  double _getScaleOffset(double pageOffset) {
    double scale = scaleFactor;
    if (pageOffset >= 0 && pageOffset <= 1) {
      scale = 1 - pageOffset / 2;
    } else if (pageOffset > 8 && pageOffset <= 9) {
      scale = scaleFactor + (pageOffset - 8) / 2;
    } else {
      scale = scaleFactor;
    }
    return scale;
  }
}

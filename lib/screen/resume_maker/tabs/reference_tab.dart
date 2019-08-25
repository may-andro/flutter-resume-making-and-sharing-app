import 'package:flutter/material.dart';
import 'package:resumepad/model/resume_model.dart';
import 'package:resumepad/screen/add_reference/add_reference_dialog.dart';
import 'package:resumepad/screen/resume_maker/bloc/bloc_provider.dart';
import 'package:resumepad/screen/resume_maker/widget/onboarding_header_text.dart';
import 'package:resumepad/utility/color_utility.dart';

class ReferenceTab extends StatefulWidget {
  @override
  _ReferenceTabState createState() => _ReferenceTabState();
}

class _ReferenceTabState extends State<ReferenceTab> {
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
              OnBoardingHeaderText(text: 'Reference'),
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
                        onPressed: () => _showAddReferenceDialog(null, 0),
                        icon: const Icon(Icons.add),
                      )),
                ),
              ),
            ],
          ),
          Expanded(child: _buildReferenceList()),
        ],
      ),
    );
  }

  Widget _buildReferenceList() {
    final _bloc = ResumeMakerBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: StreamBuilder<Reference>(
          stream: _bloc.referenceListModifiedStream,
          builder: (context, snapshot) {
            return _bloc.referenceList.isEmpty
                ? Container(
                    child: Text('No reference added'),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _bloc.referenceList[index] != null
                          ? _ReferenceCard(
                              reference: _bloc.referenceList[index],
                              onTap: () => _showAddReferenceDialog(
                                _bloc.referenceList[index],
                                index,
                              ),
                            )
                          : Offstage();
                    },
                    itemCount: _bloc.referenceList.length,
                  );
          }),
    );
  }

  Future _showAddReferenceDialog(Reference tempReference, int index) async {
    Reference reference = await Navigator.of(context).push(
      MaterialPageRoute<Reference>(
          builder: (BuildContext context) {
            return AddReferenceDialog(
              reference: tempReference,
            );
          },
          fullscreenDialog: true),
    );

    if(reference != null){
	    final _bloc = ResumeMakerBlocProvider.of(context);
	    if (tempReference != null) {
		    _bloc.referenceList[index] = reference;
	    } else {
		    _bloc.referenceList.add(reference);
	    }

	    _bloc.referenceList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
	    _bloc.referenceListModifiedSink.add(reference);
    }
  }
}

class _ReferenceCard extends StatelessWidget {
  final Reference reference;
  final Function onTap;

  _ReferenceCard({
    @required this.reference,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(reference.toString()),
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
        _bloc.referenceList.remove(reference);
        _bloc.referenceListModifiedSink.add(reference);
        _bloc.referenceList.isNotEmpty ? _bloc.nextButtonEnableSink.add(true) : _bloc.nextButtonEnableSink.add(false);
      },
      child: _tapableContent(context),
    );
  }

  _tapableContent(BuildContext context) => Container(
        width: double.infinity,
        child: InkWell(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${reference != null ? reference.name : ''}',
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
                    reference != null ? '${reference.designation} at ${reference.company}' : '',
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
                  Text(
                    reference != null ? reference.email : '',
                    style: TextStyle(
                        color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
                        fontSize: MediaQuery.of(context).size.shortestSide * 0.04,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

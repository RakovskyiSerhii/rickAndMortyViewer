import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:rick_and_morty_viewer/core/ImagePathBuilder.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';

class ErrorStub extends StatelessWidget {
  final Function _callback;
  final int _sizeModificator;

  ErrorStub(this._callback, this._sizeModificator);

  factory ErrorStub.fullScreen(Function callback) => ErrorStub(callback, 1);

  factory ErrorStub.modalSheet(Function callback) => ErrorStub(callback, 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 50),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/portal.json',
            width: (MediaQuery.of(context).size.width / _sizeModificator) / 2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(Strings.get(context, Strings.CONNECTION_LOST), style: Theme.of(context).textTheme.bodyText1,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Theme.of(context).primaryColor,
              onPressed: () => _callback(),
              child: Text(Strings.get(context, Strings.UPDATE_STRING), style: Theme.of(context).primaryTextTheme.bodyText1,),
            ),
          )
        ],
      ),
    );
  }
}

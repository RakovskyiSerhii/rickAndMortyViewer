import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_viewer/core/ImagePathBuilder.dart';

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
          Image.asset(
            Images.portal,
            width: (MediaQuery.of(context).size.width / _sizeModificator) / 3,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Connection lost", style: Theme.of(context).textTheme.bodyText1,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: () => _callback(),
              child: Text("Update"),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ServerError extends StatelessWidget {
  final String _description;
  ServerError(this._description);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        width: double.infinity,
        child: Column(children: [
          Icon(Icons.priority_high),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            child: Text("Server error",
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: Text(_description,
                style: Theme.of(context).textTheme.bodyText2),
          ),
        ]),
      ),
    );
  }
}

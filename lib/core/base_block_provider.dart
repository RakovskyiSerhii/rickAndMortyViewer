import 'package:flutter/widgets.dart';

import 'base_block.dart';

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  BlocProvider({Key key, @required this.child, @required this.bloc})
      : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BlocProviderState<T> createState() {
    return _BlocProviderState<T>();
  }

  static T of<T extends BaseBloc>(BuildContext context) {
    _BlockProviderInherited provider = context
        .getElementForInheritedWidgetOfExactType<_BlockProviderInherited>()
        ?.widget;
    return provider?.block;
  }
}

class _BlocProviderState<T extends BaseBloc> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return new _BlockProviderInherited(
        child: widget.child, block: widget.bloc);
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc?.dispose();
  }
}

class _BlockProviderInherited<T> extends InheritedWidget {
  _BlockProviderInherited(
      {Key key, @required Widget child, @required this.block})
      : super(key: key, child: child);

  final T block;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

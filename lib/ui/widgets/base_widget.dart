import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final T notifier;
  final Widget child;
  final Function(T) onNotifierReady;

  BaseWidget({
    Key key,
    this.notifier,
    this.builder,
    this.child,
    this.onNotifierReady,
  }) : super(key: key);
  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.notifier;
    if (widget.onNotifierReady != null) {
      widget.onNotifierReady(widget.notifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (ctx) => notifier,
      child: Consumer<T>(
        child: widget.child,
        builder: widget.builder,
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// This code is a modified version of useValueChanged from flutter_hooks

void useValuesChanged(List<Object?> values, {bool firstTime = false, required VoidCallback callback}) {
  return use(_ValuesChangedHook(values, callback, firstTime: firstTime));
}

class _ValuesChangedHook extends Hook<void> {
  const _ValuesChangedHook(this.values, this.valuesChanged, {required this.firstTime});

  final VoidCallback valuesChanged;
  final List<Object?> values;
  final bool firstTime;

  @override
  _ValuesChangedHookState createState() => _ValuesChangedHookState();
}

class _ValuesChangedHookState extends HookState<void, _ValuesChangedHook> {
  @override
  void initHook() {
    super.initHook();
    if (hook.firstTime) hook.valuesChanged();
  }

  @override
  void didUpdateHook(_ValuesChangedHook oldHook) {
    super.didUpdateHook(oldHook);
    if (!const IterableEquality<Object?>().equals(hook.values, oldHook.values)) {
      hook.valuesChanged();
    }
  }

  @override
  void build(BuildContext context) {}

  @override
  String get debugLabel => 'useValuesChanged';

  @override
  bool get debugHasShortDescription => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('values', hook.values));
  }
}

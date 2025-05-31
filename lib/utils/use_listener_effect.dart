import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useListenerEffect(List<ChangeNotifier> changeNotifiers, {bool firstTime = false, required VoidCallback callback}) {
  return useEffect(() {
    for (final notifier in changeNotifiers) {
      notifier.addListener(callback);
    }
    if (firstTime) callback();
    return () {
      for (final notifier in changeNotifiers) {
        notifier.removeListener(callback);
      }
    };
  }, changeNotifiers);
}

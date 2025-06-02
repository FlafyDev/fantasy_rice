import 'package:flutter_hooks/flutter_hooks.dart';

void useDeltaTicker(void Function(double delta) tick) {
    final tickerProvider = useSingleTickerProvider();

    useEffect(() {
      var lastElapsed = Duration.zero;
      final ticker = tickerProvider.createTicker((elapsed) {
        final delta = (elapsed - lastElapsed).inMicroseconds / 1000000.0;
        tick(delta);
        lastElapsed = elapsed;
      });

      ticker.start();

      return ticker.dispose;
    }, [tickerProvider]);
}

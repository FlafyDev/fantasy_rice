Stream<void> timerStream(Duration duration, {bool firstTime = true}) async* {
  if (firstTime) yield 0;
  yield* Stream.periodic(duration);
}

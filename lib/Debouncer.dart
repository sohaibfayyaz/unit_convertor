import 'dart:async';
import 'dart:ui';

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  run(VoidCallback action) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(delay, action);
  }
}

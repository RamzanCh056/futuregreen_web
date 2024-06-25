import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerController extends GetxController {
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onStopped: () {},
    onEnded: () {},
  );
}

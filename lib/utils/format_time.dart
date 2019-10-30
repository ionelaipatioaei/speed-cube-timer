String formatMinutes(int minutes) => minutes > 9 ? minutes.toString() : minutes.toString().padLeft(2, "0");

String formatSeconds(int seconds) => seconds > 9 ? seconds.toString() : seconds.toString().padLeft(2, "0");

String formatMs(int ms) => ms.toString().length < 3 ? ms.toString().padRight(3, "0") : ms.toString();

String msToMinutes(int totalMs) {
  int mins = 0;
  int secs = 0;
  int ms = 0;
  if (totalMs > 0) {
    mins = totalMs ~/ 60000;
    secs = ((totalMs % 60000) ~/ 1000);
    // this if is here to prevent the stupid divide by 0 error
    if (secs < 1) {
      ms = totalMs % 1000;
    } else {
      ms = totalMs % ((secs * 1000) + (mins * 60000));
    }
  }
  if (mins > 0) {
    return "${mins}m:$secs.${ms ~/ 10}s";
  } else {
    return "$secs.${ms ~/ 10}s";
  }
}
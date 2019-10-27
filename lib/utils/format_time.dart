String formatMinutes(int minutes) => minutes > 9 ? minutes.toString() : minutes.toString().padLeft(2, "0");

String formatSeconds(int seconds) => seconds > 9 ? seconds.toString() : seconds.toString().padLeft(2, "0");

String formatMs(int ms) => ms.toString().length < 3 ? ms.toString().padRight(3, "0") : ms.toString();
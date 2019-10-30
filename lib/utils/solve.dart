import 'package:hive/hive.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class Solve {
  static void saveSolve(int date, String scramble, bool inspected, int inspectionTime, int solveTime, bool plus2S, bool dnf) async {
    const int maxLength = 100;
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    String data = "date:$date,practicing:$name,scramble:$scramble,inspected:$inspected,inspection_time:$inspectionTime,solve_time:$solveTime,plus_2s:$plus2S,dnf:$dnf";

    Box statistics = Hive.box("statistics");
    String boxIndexKey = "stats_${name}_index";
    int boxIndex = statistics.get(boxIndexKey, defaultValue: 0);
    String boxToWrite = "stats_${name}_$boxIndex";
    print("Getting index from: $boxIndexKey with index: $boxIndex in order to open box: $boxToWrite");
    if(!Hive.isBoxOpen(boxToWrite)) {
      print("Box: $boxToWrite is not open. Opening...");
      await Hive.openBox(boxToWrite);
      print("Box opened!");
    }
    Box box = Hive.box(boxToWrite);
    box.add(data);
    print("Added this data: $data to box: $boxToWrite");
    if (box.length >= maxLength) {
      box..compact()..close();
      print("Box: $boxToWrite has over $maxLength items, compacting and closing completed.");
      statistics.put(boxIndexKey, ++boxIndex);
      print("New box index: ${++boxIndex} for $name stats box.");
    }
    print("Data was written successfully!");

    int bestTime = settings.get("stats_${name}_best_time", defaultValue: 0);
    int worseTime = settings.get("stats_${name}_worst_time", defaultValue: 0);
    int totalSolves = settings.get("stats_${name}_total_solves", defaultValue: 0);
    int average5 = settings.get("stats_${name}_average_5", defaultValue: 0);
    int average12 = settings.get("stats_${name}_average_12", defaultValue: 0);
    int average50 = settings.get("stats_${name}_average_50", defaultValue: 0);


  }

  static void deleteLastSolve() {

  }

  static List<int> getStats(int length) {
    List<int> temp = List<int>();
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
  }

  static BottomStats getBottomState() {
    return null;
  }
}

class BottomStats {
  final int bestTime;
  final int worstTime;
  final int totalSolves;
  final int averages5;
  final int averages12;
  final int averages50;
  BottomStats(this.bestTime, this.worstTime, this.totalSolves, this.averages5, this.averages12, this.averages50);
}
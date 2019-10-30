import 'package:hive/hive.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class Solve {
  static const int maxBoxLength = 256;

  static Future<void> saveSolve(int date, String scramble, bool inspected, int inspectionTime, int solveTime, bool plus2S, bool dnf) async {
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
    if (box.length >= maxBoxLength) {
      box..compact()..close();
      print("Box: $boxToWrite has over $maxBoxLength items, compacting and closing completed.");
      statistics.put(boxIndexKey, ++boxIndex);
      print("New box index: ${++boxIndex} for $name stats box.");
    }
    print("Data was written successfully!");
    updateBottomStats();
  }

  static Future<void> deleteLastSolve() async {
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    Box statistics = Hive.box("statistics");
    String boxIndexKey = "stats_${name}_index";
    int boxIndex = statistics.get(boxIndexKey, defaultValue: 0);
    String lastStatsBox = "stats_${name}_$boxIndex";
    if(!Hive.isBoxOpen(lastStatsBox)) {
      print("Box: $lastStatsBox is not open. Opening...");
      await Hive.openBox(lastStatsBox);
      print("Box opened!");
    }
    Box box = Hive.box(lastStatsBox);
    box.deleteAt(box.length - 1);
    print("Deleted last entry from box: $lastStatsBox");
  }

  static int getTime(String solveData) {
    List<String> proprieties = solveData.split(",");
    return int.parse(proprieties[5].split(":")[1]);
  }

  static Future<List<int>> getStats(int length) async {
    List<int> temp = List<int>();
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    Box statistics = Hive.box("statistics");
    String boxIndexKey = "stats_${name}_index";
    int boxIndex = statistics.get(boxIndexKey, defaultValue: 0);
    String lastStatsBox = "stats_${name}_$boxIndex";
    // print("Getting index from: $boxIndexKey with index: $boxIndex in order to open box: $boxToWrite");
    if(!Hive.isBoxOpen(lastStatsBox)) {
      print("Box: $lastStatsBox is not open. Opening...");
      await Hive.openBox(lastStatsBox);
      print("Box opened!");
    }
    Box box = Hive.box(lastStatsBox);
    if (boxIndex > 0 && box.length < length) {
      String additionalBox = "stats_${name}_${--boxIndex}";
      if(!Hive.isBoxOpen(additionalBox)) {
        print("Box: $additionalBox is not open. Opening...");
        await Hive.openBox(additionalBox);
        print("Box opened!");
      }
      Box box2 = Hive.box(additionalBox);
      int remaining = length - box.length;

      for (int i = remaining; i < box2.length; i++) {
        temp.add(getTime(box.getAt(i)));
      }
      for (int i = 0; i < box.length; i++) {
        temp.add(getTime(box.getAt(i)));
      }
      
      return temp;
    } else {
      if (box.length >= length) {
        int startIndex = box.length - length;
        for (int i = startIndex; i < box.length; i++) {
          temp.add(getTime(box.getAt(i)));
        }
      } else {
        for (int i = 0; i < box.length; i++) {
          temp.add(getTime(box.getAt(i)));
        }
      }
      return temp;
    }
  }

  static Future<void> updateBottomStats() async {
    const int statsAmount = 50;
    Box statistics = Hive.box("statistics");
    Box settings = Hive.box("settings");

    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    String boxIndexKey = "stats_${name}_index";
    int boxIndex = statistics.get(boxIndexKey, defaultValue: 0);
    String lastStatsBoxName = "stats_${name}_$boxIndex";
    if (!Hive.isBoxOpen(lastStatsBoxName)) {
      await Hive.openBox(lastStatsBoxName);
    }
    Box lastStatsBox = Hive.box(lastStatsBoxName);

    List<int> stats = await getStats(statsAmount);

    int bestTime = statistics.get("stats_${name}_best_time", defaultValue: 1<<32);
    int worstTime = statistics.get("stats_${name}_worst_time", defaultValue: 0);

    int updatedTotalSolves = (maxBoxLength * boxIndex) + lastStatsBox.length;
    statistics.put("stats_${name}_total_solves", updatedTotalSolves);

    // if (stats.length > 0) {
      int lastIndex = stats.length - 1 >= 0 ? stats.length - 1 : 0;
      int lastStat = stats[lastIndex];
      if (lastStat < bestTime) {
        statistics.put("stats_${name}_best_time", lastStat);
      }
      if (worstTime < lastStat) {
        statistics.put("stats_${name}_worst_time", lastStat);
      }

      if (stats.length >= 5) {
        List<int> last5 = stats.skip(stats.length - 5).take(5).toList();
        int sum5 = last5.reduce((int curr, int next) => curr + next);
        int avg5 = sum5 ~/ 5;
        statistics.put("stats_${name}_average_5", avg5);
        // print("last 5");
        // print(last5);
        // print(sum5);
        // print(avg5);

        if (stats.length >= 12) {
          List<int> last12 = stats.skip(stats.length - 12).take(12).toList();
          int sum12 = last12.reduce((int curr, int next) => curr + next);
          int avg12 = sum12 ~/ 12;
          statistics.put("stats_${name}_average_12", avg12);
          // print("last 12");
          // print(last12);
          // print(sum12);
          // print(avg12);

          if (stats.length >= 50) {
            List<int> last50 = stats.skip(stats.length - 50).take(50).toList();
            int sum50 = last50.reduce((int curr, int next) => curr + next);
            int avg50 = sum50 ~/ 50;
            statistics.put("stats_${name}_average_50", avg50);
            // print("last 50");
            // print(last50);
            // print(sum50);
            // print(avg50);

          }
        }
      } 
    // }
  }
}
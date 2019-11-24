import 'package:hive/hive.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

// TODO: this code needs a major refactor
class Solve {
  // static const int maxBoxSize = 512;
  static const int statsFormatVersion = 0;

  static Future<void> saveSolve(int date, String scramble, bool inspected, int inspectionTime, int solveTime, bool plus2S, bool dnf) async {
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    String data = "date:$date,practicing:$name,scramble:$scramble,inspected:$inspected,inspection_time:$inspectionTime,solve_time:$solveTime,plus_2s:$plus2S,dnf:$dnf";

    // Box statistics = Hive.box("statistics");
    String boxToWrite = "stats_$name";
    if(!Hive.isBoxOpen(boxToWrite)) {
      print("Box: $boxToWrite is not open. Opening...");
      await Hive.openBox(boxToWrite);
      print("Box opened!");
    }
    Box box = Hive.box(boxToWrite);
    box.add(data);
    print("Data was written successfully!");
    await updateBottomStats();
  }

  static Future<void> deleteLastSolve() async {
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);

    String boxName = "stats_$name";
    if(!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    Box box = Hive.box(boxName);
    if (box.length > 0) {
      box.deleteAt(box.length - 1);
      print("Deleted last entry from box: $boxName");
      await updateBestWorstTimes();
      await updateBottomStats();
    }
  }

  static Future<void> updatePlus2SDnf(bool plus2S, bool dnf) async {
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);

    String boxName = "stats_$name";
    if(!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    Box box = Hive.box(boxName);
    if (box.length > 0) {
      int lastIndex = box.length - 1;
      String statToModify = box.getAt(lastIndex);
      List<String> proprieties = statToModify.split(",");
      String date = proprieties[0].split(":")[1];
      String nameProp = proprieties[1].split(":")[1];
      String scramble = proprieties[2].split(":")[1];
      String inspected = proprieties[3].split(":")[1];
      String inspectionTime = proprieties[4].split(":")[1];
      String solveTime = proprieties[5].split(":")[1];
      String plus2SProp = plus2S.toString();
      String dnfProp = dnf.toString();
      String rebuildStat = "date:$date,practicing:$nameProp,scramble:$scramble,inspected:$inspected,inspection_time:$inspectionTime,solve_time:$solveTime,plus_2s:$plus2SProp,dnf:$dnfProp";

      box.putAt(lastIndex, rebuildStat);
      await updateBestWorstTimes();
      await updateBottomStats();
    }
  }

  static int getTime(String solveData) {
    List<String> proprieties = solveData.split(",");
    int time = int.parse(proprieties[5].split(":")[1]);
    if (proprieties[7].split(":")[1] == "true") return 0;
    if (proprieties[6].split(":")[1] == "true") return time + 2000;
    return time;
  }

  static Future<List<int>> getStats(int length) async {
    List<int> temp = List<int>();
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    String boxName = "stats_$name";
    if(!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    Box box = Hive.box(boxName);

    if (box.length <= length) {
      for (int i = 0; i < box.length; i++) {
        temp.add(getTime(box.getAt(i)));
      }
    } else {
      int start = box.length - length;
      for (int i = start; i < box.length; i++) {
        temp.add(getTime(box.getAt(i)));
      }
    }

    return temp;
  }

  static Future<void> updateBottomStats() async {
    const int statsAmount = 50;
    Box statistics = Hive.box("statistics");
    Box settings = Hive.box("settings");

    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    String boxName = "stats_$name";
    // int boxIndex = statistics.get(boxIndexKey, defaultValue: 0);
    // String lastStatsBoxName = "stats_${name}_$boxIndex";
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    Box box = Hive.box(boxName);

    List<int> stats = await getStats(statsAmount);
    // print(stats);

    int bestTime = statistics.get("stats_${name}_best_time", defaultValue: 1<<30);
    int worstTime = statistics.get("stats_${name}_worst_time", defaultValue: 0);

    int updatedTotalSolves = box.length;
    statistics.put("stats_${name}_total_solves", updatedTotalSolves);

    if (stats.isNotEmpty) {
      int lastStat = stats[stats.length - 1];
      if (lastStat < bestTime && lastStat > 0) {
        statistics.put("stats_${name}_best_time", lastStat);
      }
      if (worstTime < lastStat) {
        statistics.put("stats_${name}_worst_time", lastStat);
      }
    }

    // TODO: this can be refactored in nicer function
    if (stats.length >= 5) {
      List<int> last5 = stats.skip(stats.length - 5).take(5).toList();
      int sum5 = last5.reduce((int curr, int next) => curr + next);
      int nonZeroItemsForAvg5 = 5;
      last5.forEach((int stat) => stat == 0 ? nonZeroItemsForAvg5-- : null);
      int avg5 = nonZeroItemsForAvg5 == 0 ? 0 : sum5 ~/ nonZeroItemsForAvg5;
      statistics.put("stats_${name}_average_5", avg5);
      if (stats.length >= 12) {
        List<int> last12 = stats.skip(stats.length - 12).take(12).toList();
        int sum12 = last12.reduce((int curr, int next) => curr + next);
        int nonZeroItemsForAvg12 = 12;
        last12.forEach((int stat) => stat == 0 ? nonZeroItemsForAvg12-- : null);
        int avg12 = nonZeroItemsForAvg12 == 0 ? 0 : sum12 ~/ nonZeroItemsForAvg12;
        statistics.put("stats_${name}_average_12", avg12);
        if (stats.length >= 50) {
          List<int> last50 = stats.skip(stats.length - 50).take(50).toList();
          int sum50 = last50.reduce((int curr, int next) => curr + next);
          int nonZeroItemsForAvg50 = 50;
          last50.forEach((int stat) => stat == 0 ? nonZeroItemsForAvg50-- : null);
          int avg50 = nonZeroItemsForAvg50 == 0 ? 0 : sum50 ~/ nonZeroItemsForAvg50;
          statistics.put("stats_${name}_average_50", avg50);
        } else {
          statistics.put("stats_${name}_average_50", 0);
        }
      } else {
        statistics.put("stats_${name}_average_12", 0);
      }
    } else {
      statistics.put("stats_${name}_average_5", 0);
    }
  }

  static Future<void> updateBestWorstTimes() async {
    Box statistics = Hive.box("statistics");
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);
    int totalSolves = statistics.get("stats_${name}_total_solves", defaultValue: 0);
    List<int> stats = await getStats(totalSolves);
    // print(stats);

    if (stats.isNotEmpty) {
      int minValue = stats[0];
      int maxValue = stats[0];
      stats.skip(1).forEach((int stat) {
        // this is needed in order to skip dnfs which makes the time 0
        if (stat > 0) minValue = minValue.compareTo(stat) >= 0 ? stat : minValue;
        maxValue = maxValue.compareTo(stat) >= 0 ? maxValue : stat;
      });
      statistics.put("stats_${name}_best_time", minValue);
      statistics.put("stats_${name}_worst_time", maxValue);
    } else {
      statistics.delete("stats_${name}_best_time");
      statistics.delete("stats_${name}_worst_time");
    }
  }
}
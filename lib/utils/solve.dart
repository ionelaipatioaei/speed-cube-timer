import 'package:hive/hive.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class Solve {
  static const int maxBoxSize = 512;
  static const int statsFormatVersion = 0;

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
    if (box.length >= maxBoxSize) {
      box..compact()..close();
      print("Box: $boxToWrite has over $maxBoxSize items, compacting and closing completed.");
      statistics.put(boxIndexKey, ++boxIndex);
      print("New box index: $boxIndex for $name stats box.");
    }
    print("Data was written successfully!");
    await updateBottomStats();
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
    if (box.length > 0) {
      box.deleteAt(box.length - 1);
      print("Deleted last entry from box: $lastStatsBox");
      await updateBestWorstTimes();
      await updateBottomStats();
    }
  }

  static Future<void> updatePlus2SDnf(bool plus2S, bool dnf) async {
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
      print("Modifiend box: $lastStatsBox at: $lastIndex with data: $rebuildStat");
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
      int neededBoxes = (length / maxBoxSize).ceil();
      print("$neededBoxes boxes are needed in order to collect $length solve entries");
      int availableItems = (boxIndex * maxBoxSize) + box.length;
      int startBox = 0;

      if (availableItems < length) {
        neededBoxes = boxIndex + 1;
        print("Not enough boxes, changing neededBoxes to: $neededBoxes");
      } else {
        startBox = boxIndex - neededBoxes;
      }
      print("Starting from box with the index of: $startBox");
      // print("Remaining items in the first box: $remainingInFirstBox");
      for (int i = startBox; i < boxIndex + 1; i++) {
        String boxToOpenKey = "stats_${name}_$i";
        print("Working box: $boxToOpenKey");
        if(!Hive.isBoxOpen(boxToOpenKey)) {
          print("Box: $boxToOpenKey is not open. Opening...");
          await Hive.openBox(boxToOpenKey);
          print("Box opened!");
        }
        Box currentBox = Hive.box(boxToOpenKey);
        for (int j = 0; j < currentBox.length; j++) {
          temp.add(getTime(currentBox.getAt(j)));
        }
        if (i < boxIndex) {
          currentBox..compact()..close();
        }
      }
      // so much easier and cleaner to actually skip the first items here
      int skipItems = temp.length > length ? temp.length - length : 0;
      return temp.skip(skipItems).toList();
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
    print(stats);

    int bestTime = statistics.get("stats_${name}_best_time", defaultValue: 1<<30);
    int worstTime = statistics.get("stats_${name}_worst_time", defaultValue: 0);

    int updatedTotalSolves = (maxBoxSize * boxIndex) + lastStatsBox.length;
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
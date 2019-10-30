import 'dart:math';

class GenScramble {
  static const List<String> defaultOptions = const [
    "2x2x2:2x2x2:F,R,U,L,B,D,F',R',U',L',B',D',F2,R2,U2,L2,B2,D2",
    "3x3x3:3x3x3:F,R,U,L,B,D,F',R',U',L',B',D',F2,R2,U2,L2,B2,D2",
    "4x4x4:4x4x4:Dw,F2,Fw",
    "5x5x5:5x5x5:Dw,F2,L2,L'",
    "6x6x6:6x6x6:F2,Dw,Fw"
  ];

  static String getOptionName(String option) {
    List<String> optionProperties = option.split(":");
    return optionProperties[0];
  }

  static String getScrambleName(String option) {
    List<String> optionProperties = option.split(":");
    return optionProperties[1];
  }

  static List<String> getScrambleMoves(String option) {
    List<String> optionProperties = option.split(":");
    return optionProperties[2].split(",");
  }

  static String genScramble(int length, List<String> scramble) {
    Random rng = Random();
    int totalMoves = scramble.length;
    String temp = "";
    for (int i = 0; i < length; i++) {
      temp += scramble[rng.nextInt(totalMoves)];
      if (i != length - 1) {
        temp += " ";
      }
    }
    return temp;
  }
}
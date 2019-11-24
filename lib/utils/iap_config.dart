import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/utils/unique_id.dart';

class IAPConfig {
  static const String purchaseId = "remove_all_ads_unlock_all_customizations";
  static const int totalBackgrounds = 15;

  static void init() async {
    Box unlocked = Hive.box("unlocked");
    String udid = await UniqueId.getId();

    bool hasPurchased = unlocked.get(purchaseId);
    if (hasPurchased == null) {
      Firestore.instance.collection("iap").document(udid).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          unlocked.put(purchaseId, ds.data[purchaseId]);
        } else {
          Firestore.instance.collection("iap").document(udid).setData(<String, bool>{
            purchaseId: false
          });
          unlocked.put(purchaseId, false);
        }
      }).catchError((error) => print("Something went wrong when trying to get $purchaseId data!"));
    }

    List<dynamic> backgrounds = unlocked.get("backgrounds");
    if (backgrounds == null) {
      List<bool> initBackgrounds = List.generate(totalBackgrounds, (int index) => index < 2);
      // print(initBackgrounds);
      Firestore.instance.collection("backgrounds").document(udid).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          unlocked.put("backgrounds", ds.data["unlocked"]);
        } else {
          Firestore.instance.collection("backgrounds").document(udid).setData(<String, List<bool>>{
            "unlocked": initBackgrounds
          });
          unlocked.put("backgrounds", initBackgrounds);
        }
      }).catchError((error) => print("Something went wrong when trying to get the unlocked background!"));
    }

    // check to see if there are more backgrounds than the previous version
    int previousTotalBackgrounds = unlocked.get("total_backgrounds");
    if (previousTotalBackgrounds == null) {
      // only need to set a value because the backgrounds array was set above 
      unlocked.put("total_backgrounds", totalBackgrounds);
    } else {
      if (totalBackgrounds != previousTotalBackgrounds) {
        print("Found only $previousTotalBackgrounds total backgrounds and there are $totalBackgrounds now, updating...");
        if (hasPurchased) {
          List<bool> allBackgroundsUnlocked = List.generate(totalBackgrounds, (int index) => true);
          Firestore.instance.collection("backgrounds").document(udid).updateData(<String, List<bool>>{
            "unlocked": allBackgroundsUnlocked
          }).catchError((error) => print("Something went wrong when trying to update the unlocked backgrounds!"));
          unlocked.put("backgrounds", allBackgroundsUnlocked);
        } else {
          List<dynamic> unlockedBackgrounds = unlocked.get("backgrounds");
          // print(unlockedBackgrounds);
          List<bool> updatedBackgrounds = List<bool>();

          for (int i = 0; i < previousTotalBackgrounds; i++) {
            updatedBackgrounds.add(unlockedBackgrounds[i]);
          }
          for (int i = previousTotalBackgrounds; i < totalBackgrounds; i++) {
            updatedBackgrounds.add(false);
          }
          // print(updatedBackgrounds);

          Firestore.instance.collection("backgrounds").document(udid).updateData(<String, List<bool>>{
            "unlocked": updatedBackgrounds
          }).catchError((error) => print("Something went wrong when trying to update the unlocked backgrounds!"));
          unlocked.put("backgrounds", updatedBackgrounds);
        }
        unlocked.put("total_backgrounds", totalBackgrounds);
      }
    }
  }

  static void confirmPurchase() async {
    Box unlocked = Hive.box("unlocked");
    String udid = await UniqueId.getId();

    Firestore.instance.collection("iap").document(udid).updateData(<String, bool>{
      purchaseId: true
    }).catchError((error) => print("Something went wrong when trying to confirm the $purchaseId purchase!"));
    unlocked.put(purchaseId, true);

    // unlock all backgrounds
    List<bool> allBackgroundsUnlocked = List.generate(totalBackgrounds, (int index) => true);
    Firestore.instance.collection("backgrounds").document(udid).updateData(<String, List<bool>>{
      "unlocked": allBackgroundsUnlocked
    }).catchError((error) => print("Something went wrong when trying to update the unlocked backgrounds!"));
    unlocked.put("backgrounds", allBackgroundsUnlocked);
  }

  static void updateBackground(int index) async {
    Box unlocked = Hive.box("unlocked");
    String udid = await UniqueId.getId();
    List<dynamic> backgrounds = unlocked.get("backgrounds");
    backgrounds[index] = true;

    Firestore.instance.collection("backgrounds").document(udid).updateData(<String, List<dynamic>>{
      "unlocked": backgrounds
    }).catchError((error) => print("Something went wrong when trying to update $index background!"));
    unlocked.put("backgrounds", backgrounds);
  }

  static List<bool> getUnlockedBackgrounds() {
    Box unlocked = Hive.box("unlocked");
    List<dynamic> backgrounds = unlocked.get("backgrounds");
    return backgrounds;
  }
}
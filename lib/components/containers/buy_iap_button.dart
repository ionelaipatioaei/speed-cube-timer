import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:speed_cube_timer/components/common/double_text_button.dart';
import 'package:speed_cube_timer/components/custom/custom_spacer.dart';
import 'package:speed_cube_timer/utils/iap_config.dart';

class BuyIAPButton extends StatefulWidget {
  final bool bottomSpacer;
  BuyIAPButton({this.bottomSpacer = false});

  @override
  State<StatefulWidget> createState() => _BuyIAPButtonState();
}

class _BuyIAPButtonState extends State<BuyIAPButton> {
  static const List<String> productIds = ["remove_ads_unlock_all_customizations"];

  bool available = true;
  InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  StreamSubscription subscription;

  void initialize() async {
    available = await iap.isAvailable();
    if (available) {
      await getProducts();
      await getPastPurchases();

      verifyPurchase();
    }

    subscription = iap.purchaseUpdatedStream.listen((data) => setState(() {
      purchases.addAll(data);
      verifyPurchase();
    }));
  }

  Future<void> getProducts() async {
    Set<String> ids = Set.from(productIds);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    if (mounted) {
      setState(() => products = response.productDetails);
    }
  }

  Future<void> getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
    if (mounted) {
      setState(() => purchases = response.pastPurchases);
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere((PurchaseDetails purchase) => purchase.productID == productID, orElse: () => null);
  }

  void verifyPurchase() {
    PurchaseDetails removeAllAdsUnlockAllCustomizationsPurchase = hasPurchased(productIds[0]);
    if (removeAllAdsUnlockAllCustomizationsPurchase != null && removeAllAdsUnlockAllCustomizationsPurchase.status == PurchaseStatus.purchased) {
      IAPConfig.confirmPurchase();
    }
  }

  void buyRemoveAllAdsUnlockAllCustomizations() {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: products[0]);
    iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;

    return WatchBoxBuilder(
      box: Hive.box("unlocked"),
      watchKeys: ["remove_all_ads_unlock_all_customizations"],
      builder: (BuildContext context, Box box) {
        bool purchased = box.get("remove_all_ads_unlock_all_customizations", defaultValue: false);
        return purchased ? SizedBox(width: 0, height: 0) : Column(
          children: widget.bottomSpacer ? <Widget>[
            DoubleTextButton("Remove All Ads &", "Unlock All Customizations", width, () => buyRemoveAllAdsUnlockAllCustomizations()),
            CustomSpacer(width)
          ] : <Widget>[
            CustomSpacer(width),
            DoubleTextButton("Remove All Ads &", "Unlock All Customizations", width, () => buyRemoveAllAdsUnlockAllCustomizations())
          ]
        );
      }
    );
  }
}
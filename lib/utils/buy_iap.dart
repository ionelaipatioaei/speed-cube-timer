import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';

class BuyIAP {
  static const List<String> productIds = ["remove_ads_unlock_all_customizations"];

  bool available = true;
  InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  StreamSubscription subscription;

  final Function confirm;

  BuyIAP(this.confirm);

  void initialize() async {
    available = await iap.isAvailable();
    if (available) {
      await getProducts();
      await getPastPurchases();

      verifyPurchase();
    }

    subscription = iap.purchaseUpdatedStream.listen((data) => () {
      purchases.addAll(data);
      verifyPurchase();
    });
  }

  Future<void> getProducts() async {
    Set<String> ids = Set.from(productIds);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    products = response.productDetails;
  }

  Future<void> getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
    purchases = response.pastPurchases;
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere((PurchaseDetails purchase) => purchase.productID == productID, orElse: () => null);
  }

  void verifyPurchase() {
    PurchaseDetails removeAllAdsUnlockAllCustomizationsPurchase = hasPurchased(productIds[0]);
    if (removeAllAdsUnlockAllCustomizationsPurchase != null && removeAllAdsUnlockAllCustomizationsPurchase.status == PurchaseStatus.purchased) {
      confirm();
    }
  }

  void buyRemoveAllAdsUnlockAllCustomizations() {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: products[0]);
    iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }
}
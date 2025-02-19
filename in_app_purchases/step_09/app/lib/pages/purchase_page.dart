import 'package:flutter/material.dart';
import 'package:dashclicker/logic/dash_purchases.dart';
import 'package:dashclicker/model/purchasable_product.dart';
import 'package:dashclicker/model/store_state.dart';
import 'package:dashclicker/repo/iap_repo.dart';
import 'package:provider/provider.dart';

import '../logic/firebase_notifier.dart';
import '../model/firebase_state.dart';
import 'login_page.dart';

class PurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firebaseNotifier = context.watch<FirebaseNotifier>();
    if (firebaseNotifier.state == FirebaseState.loading) {
      return _PurchasesLoading();
    } else if (firebaseNotifier.state == FirebaseState.notAvailable) {
      return _PurchasesNotAvailable();
    }

    if (!firebaseNotifier.loggedIn) {
      return LoginPage();
    }

    var upgrades = context.watch<DashPurchases>();

    Widget storeWidget;
    switch (upgrades.storeState) {
      case StoreState.loading:
        storeWidget = _PurchasesLoading();
        break;
      case StoreState.available:
        storeWidget = _PurchaseList();
        break;
      case StoreState.notAvailable:
        storeWidget = _PurchasesNotAvailable();
        break;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      storeWidget,
      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
        child: Text(
          'Past purchases',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      PastPurchasesWidget(),
    ]);
  }
}

class _PurchasesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Store is loading'));
  }
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Store not available'));
  }
}

class _PurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var purchases = context.watch<DashPurchases>();
    var products = purchases.products;
    return Column(
      children: products
          .map((product) => _PurchaseWidget(
              product: product,
              onPressed: () {
                purchases.buy(product);
              }))
          .toList(),
    );
  }
}

class _PurchaseWidget extends StatelessWidget {
  final PurchasableProduct product;
  final VoidCallback onPressed;

  _PurchaseWidget({
    Key? key,
    required this.product,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = product.title;
    if (product.status == ProductStatus.purchased) {
      title += ' (purchased)';
    }
    return InkWell(
        onTap: onPressed,
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: Text(product.description),
          trailing: Text(_trailing()),
        ));
  }

  String _trailing() {
    switch (product.status) {
      case ProductStatus.purchasable:
        return product.price;
      case ProductStatus.purchased:
        return 'purchased';
      case ProductStatus.pending:
        return 'buying...';
    }
  }
}

class PastPurchasesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var purchases = context.watch<IAPRepo>().purchases;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: purchases.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(purchases[index].title),
        subtitle: Text(purchases[index].status.toString()),
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}

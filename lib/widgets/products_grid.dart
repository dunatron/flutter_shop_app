import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// providers
import '../providers/products_provider.dart';
// widgets
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(), defines how wide each item is
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2, //higher than they are wide
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), // squeezes elements onto the screen no matter the device
    );
  }
}

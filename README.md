# flutter_shop_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Provider Details

- You dont have to supply a context if it is not needed. i.e use .value
- .value is better for widgets as it ensures that when the widget is trashed the data is kept in sync
  - The widget is now tied to its data as opposed to the create ChangeNotifier version
- Whenever you use an existing object i.e. we have got all our properties in our store you should use the .value ChangeNotifier
- Setting up/getting the initial Products list we should use the create version

- when you leave pages that have data through provides. Like actually leave te page, not popping on top of it then you will find the Provider is still consuming memory. Flutter cleans up its widgets automatically, but not the provider state. and this will lead to memory leaks which will eventually lead to a memory overflow and crash your app
- NVM, ChangeNotifierProvider automatically cleans the data up when its not required

```dart
// With context
ChangeNotifierProvider(
  create: (ctx) => ProductsProvider(),
  child: MaterialApp(
    title: 'Shop Application',
    home: ProductsOverviewScreen(),
  ),
);
// without context and just using the value
ChangeNotifierProvider.value(
  value: ProductsProvider(),
  child: MaterialApp(
    title: 'Shop Application',
    home: ProductsOverviewScreen(),
  ),
);
// with context
ChangeNotifierProvider(
  create: (c) => products[i],
  child: ProductItem(),
);
// without context and just using the value
ChangeNotifierProvider.value(
  value: products[i],
  child: ProductItem(),
);
```

## Consumer instead of Provider.of

A pattern to consider is using both. i.e when getting just 1 product use the Provider.of
then for the favourite button only, listen inside of that widget for changes on product.isFavorite
shrinking the are that gets rerendered when the product changes

```dart
// provider way
final product = Provider.of<Product>(context, listen: true);
// consumer way
Consumer<Product>(
  builder: (ctx, product, child) => ClipRRect()
)
```

## Dart Mixins and extensions

- You can only extend from one class
- with mixins you can have as many as you want. properties and methods get merged
- mixins can be thought of as more utility functionality providers
- extends = strong logical connection
- mixins = more of a loose connection/general

```dart
mixin Agility  {
  var speed = 10;
  void sitDown() {
    print('Sitting down');
  }
}

class Mammal {
  void breathe() {
    print("Breathe In... breathe out...");
  }
}

class Person extends Mammal with Agility {
  String name;
  int age;

  Person(this.name, this.age);
}

void main() {
  final pers = Person('Heath', 30);
  print(pers.name);
  pers.breathe();
  print(pers.speed);
  pers.sitDown();
}
```

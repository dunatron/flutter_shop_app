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

## Dart Future

```dart
void main() {
  var myFuture = Future(() {
    return Future.error("Could not resolve future correctly");
  });
  myFuture
    .then((res) => print(res))
    .catchError((error) {
      // I catch initial error and any .then before me
      print(error);
    })
    .then((_) {
      print('After first then. finally');
    });
}
```

- Flutter using Future

```dart
Future<void> addProduct(Product product) async {
  final url = Uri.parse(
      'https://fluttershop-9a023-default-rtdb.firebaseio.com/products.json');
  return http
      .post(
    url,
    body: json.encode(
      {
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      },
    ),
  )
      .then((response) {
    final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    _items.insert(0, newProduct);
    notifyListeners();
  }).catchError((error) {
    throw error;
  });
}
```

- Flutter Future with async/await pattern

## Loading Data with Flutter.

- using the Provider you can use `listen: false` to run in the `initState` method
- You can also use the didChangeDependecies also but it is run more often and not just on initialisation, wo you would need an `_isInit` widget variable to handle that and make sure you only ran initial setup once.
- IMPORTANT: do not use the async keyword and pattern on initState or didChangeDependencies as they cannot return a Future. Instead you have to use the `.then()` approach

## Future Builder

IMPORTANT: if you use future builder where the widget could rebuild then you need to be carefull not to recall the future.
at the end of this lecture is a solution that converts the widget to a stateful widget and manages the future in a variable there and utilising initState. This would seem to be ok

- https://pro.academind.com/courses/learn-flutter-dart-to-build-ios-android-apps-2020/lectures/13912306

## Authentication in Flutter Apps

- We send a password and email to the server which will create a new user and auth them or it would just auth them if they exist

#### Web Development Sessions

- In web development we have sessions where we can basically store on a server a userId andd wheter that user is logged in or not
- On your front end you would then store a cookie somewhere
- Your browser and server can then communicate to say hey the user using this app is currently logged in.

#### Sessions Suck. We use Tokens

In flutter and many web modern web apps we work with restful APIs and these APIs are stateless  
So the server doesnt care about the user connected, instead we provide endpoints that can return an answer.
We dont want to have to deal with who is authed and who is not.  
Instead we use `token` based auth. the idea of a token is that when a user logs in, a token is generated by the server with
a certain algorithm and a certain secret key which is only known by the server. we then go ahead and store that token on the device. This allows us to read the token when the app restarts.  
For an endpoint that is authed we would require a token attached to the request

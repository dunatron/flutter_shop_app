// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/orders.dart' show Orders;

// //widgets
// import '../widgets/order_item.dart';
// import '../widgets/app_draw.dart';

// // Note. If we had something that could rebuild the widget in here then the FutureBuild
// // would run again which is bad as it fetches and sets the orders from the server.
// // To fix you could make it a statefull
// class OrdersScreen extends StatelessWidget {
//   static const routeName = '/orders';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Orders"),
//       ),
//       drawer: AppDraw(),
//       body: FutureBuilder(
//         future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
//         builder: (ctx, dataSnapshot) {
//           if (dataSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (dataSnapshot.error != null) {
//             return Center(child: Text('An error ocurred'));
//           } else {
//             return Consumer<Orders>(
//               builder: (ctx, orderData, child) => ListView.builder(
//                 itemCount: orderData.orders.length,
//                 itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_draw.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDraw(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

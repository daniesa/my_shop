import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widget/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget{
  static const String routeName = '/Orders';


  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future futureOrders;

  Future obtainOrders(){
    futureOrders = Provider.of<Orders>(context, listen: false)
              .fetachAndSetOrders(context);
  }

  @override
  void initState() {
    obtainOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: futureOrders,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error == null) {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, i) {
                      return OrderItemWidget(
                        selectedOrder: orderData.orders[i],
                      );
                    },
                  ),
                );
              }
              return Center(
                child: Text('Error fetching orders'),
              );
            }
          }),
    );
  }
}

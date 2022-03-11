import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/Order_item.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem selectedOrder;

  const OrderItemWidget({Key key, this.selectedOrder}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
      var _expanded = false;
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.selectedOrder.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.selectedOrder.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.selectedOrder.products.length * 20.0 + 30, 100),
              child: ListView(
                children: widget.selectedOrder.products
                    .map(
                      (prod) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(2.0),
                                  child: Text(
                                    prod.product.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x \$${prod.product.price}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
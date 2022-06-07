import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/models/order.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/models/work.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final Product product;
  final Order order;
  final Business business;
  final void Function()? onUpdate;

  const OrderView(
      {Key? key,
      required this.product,
      required this.order,
      required this.business,
      this.onUpdate})
      : super(key: key);

  List<Widget> _buildGeneralInformation(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Icon(Icons.info_outline_rounded, color: Colors.black45),
        ],
      ),
      const SizedBox(height: 16.0),
      Row(
        children: [
          Text('Business: ', style: Theme.of(context).textTheme.subtitle2),
          Text(business.name),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Text('Business Address: ',
              style: Theme.of(context).textTheme.subtitle2),
          Text(business.address),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Text('Delivery Address: ',
              style: Theme.of(context).textTheme.subtitle2),
          Text(order.deliveryAddress),
        ],
      )
    ];
  }

  Widget _buildStateIcon(context) {
    switch (order.state) {
      case OrderState.unconfirmed:
        return const Icon(
          Icons.access_time_rounded,
          color: Colors.black45,
        );
      case OrderState.assigned:
        return const Icon(
          Icons.assignment_turned_in_outlined,
          color: Colors.black45,
        );
      case OrderState.preparing:
        return const Icon(
          Icons.local_restaurant_rounded,
          color: Colors.black45,
        );
      case OrderState.delivering:
        return const Icon(
          Icons.local_shipping_rounded,
          color: Colors.black45,
        );
      case OrderState.done:
        return const Icon(
          Icons.task_alt_rounded,
          color: Colors.black45,
        );
    }
  }

  List<Widget> _buildStateInformation(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current State',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _buildStateIcon(context)
        ],
      ),
      const SizedBox(height: 16.0),
      Text(order.stateName, style: Theme.of(context).textTheme.subtitle1),
    ];
  }

  List<Widget> _buildTicket(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Icon(Icons.fastfood_rounded, color: Colors.black45),
        ],
      ),
      const SizedBox(height: 16.0),
      Text(
        '${order.quantity} x ${product.name}',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${order.quantity} x ${product.price}',
              style: Theme.of(context).textTheme.labelSmall),
          Text('\$ ${order.quantity * product.price}')
        ],
      ),
      const SizedBox(height: 8.0),
      const Divider(),
      const SizedBox(height: 8.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('TOTAL:', style: Theme.of(context).textTheme.labelLarge),
          Text(
            '\$ ${order.quantity * product.price}',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Colors.green),
          )
        ],
      )
    ];
  }

  Future<void> updateOrder(BuildContext context, int newOrderState) async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await Server.updateOrderState(auth.accessToken!, order.id, newOrderState);
      if (auth.scope == AuthScope.delivery) {
        Work work = Provider.of<Work>(context, listen: false);
        work.update(auth);
      }
      onUpdate?.call();
      navigator.popUntil((route) => route.isFirst);
    } on ServerException catch (error) {
      if (error.isAuthException()) {
        auth.delete();
        navigator.popUntil((route) => route.isFirst);
      } else {
        final snackBar = SnackBar(content: Text(error.message));
        scaffoldMessenger.showSnackBar(snackBar);
      }
    }
  }

  Widget _buildStateChangeButton(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    AuthScope scope = auth.scope;
    if (scope == AuthScope.customer) {
      return const SizedBox.shrink();
    }
    if (order.state == OrderState.unconfirmed && scope == AuthScope.delivery) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => updateOrder(context, 1),
          child: const Text('ACCEPT'),
        ),
      );
    } else if (order.state == OrderState.assigned &&
        scope == AuthScope.business) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => updateOrder(context, 2),
          child: const Text('START PREPARING'),
        ),
      );
    } else if (order.state == OrderState.preparing &&
        scope == AuthScope.delivery) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => updateOrder(context, 3),
          child: const Text('START DELIVERY'),
        ),
      );
    } else if (order.state == OrderState.delivering &&
        scope == AuthScope.delivery) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => updateOrder(context, 4),
          child: const Text('CONFIRM RECEPTION'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildGeneralInformation(context),
          const SizedBox(height: 8.0),
          const Divider(),
          const SizedBox(height: 8.0),
          ..._buildStateInformation(context),
          const SizedBox(height: 8.0),
          const Divider(),
          const SizedBox(height: 8.0),
          ..._buildTicket(context),
          const SizedBox(height: 8.0),
          const Divider(),
          const SizedBox(height: 8.0),
          _buildStateChangeButton(context)
        ],
      ),
    );
  }
}

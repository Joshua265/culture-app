import 'package:flutter/material.dart';
import 'package:culture_app/models/event.dart';

class PaymentScreen extends StatelessWidget {
  final Event event;
  final int selectedSeatIndex;

  const PaymentScreen({
    required Key key,
    required this.event,
    required this.selectedSeatIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected seat:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              event.prices[selectedSeatIndex].category,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              'Total amount to pay:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              '\$ ${event.prices[selectedSeatIndex].value}',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a payment option:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    PaymentOptionTile(
                      icon: Icons.credit_card,
                      title: 'Credit Card',
                      key: Key('credit_card'),
                    ),
                    PaymentOptionTile(
                      icon: Icons.payment,
                      title: 'PayPal',
                      key: Key('paypal'),
                    ),
                    PaymentOptionTile(
                      icon: Icons.monetization_on,
                      title: 'Apple Pay',
                      key: Key('apple_pay'),
                    ),
                    PaymentOptionTile(
                      icon: Icons.monetization_on,
                      title: 'Google Pay',
                      key: Key('google_pay'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const PaymentOptionTile({
    required Key key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Implement payment method selection
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:culture_app/models/ticket_information.dart';
import 'package:culture_app/screens/payment_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:culture_app/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTicketInformation(TicketInformation ticket) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('tickets')) {
    List<dynamic> rawTickets = jsonDecode(prefs.getString('tickets')!);
    List<Map<String, dynamic>> tickets =
        rawTickets.cast<Map<String, dynamic>>();
    tickets.add(ticket.toMap());
    prefs.setString('tickets', jsonEncode(tickets));
  } else {
    prefs.setString('tickets', jsonEncode([ticket.toMap()]));
  }
}

class PaymentScreen extends StatelessWidget {
  final Event event;
  final List<Price> selectedPrices;
  final List<Seat> selectedSeats;

  const PaymentScreen({
    super.key,
    required this.event,
    required this.selectedPrices,
    required this.selectedSeats,
  });

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
            const SizedBox(height: 16),
            Text(
              'Total amount to pay:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${selectedPrices.fold(0.0, (sum, price) => sum + price.value).toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a payment option:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PaymentOptionTile(
                      icon: Icons.credit_card,
                      title: 'Credit Card',
                      key: const Key('credit_card'),
                      event: event,
                      selectedPrices: selectedPrices,
                      selectedSeats: selectedSeats,
                    ),
                    PaymentOptionTile(
                      icon: Icons.payment,
                      title: 'PayPal',
                      key: const Key('paypal'),
                      event: event,
                      selectedPrices: selectedPrices,
                      selectedSeats: selectedSeats,
                    ),
                    PaymentOptionTile(
                      icon: Icons.monetization_on,
                      title: 'Apple Pay',
                      key: const Key('apple_pay'),
                      event: event,
                      selectedPrices: selectedPrices,
                      selectedSeats: selectedSeats,
                    ),
                    PaymentOptionTile(
                      icon: Icons.monetization_on,
                      title: 'Google Pay',
                      key: const Key('google_pay'),
                      event: event,
                      selectedPrices: selectedPrices,
                      selectedSeats: selectedSeats,
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
  final Event event;
  final List<Price> selectedPrices;
  final List<Seat> selectedSeats;

  const PaymentOptionTile({
    required Key key,
    required this.icon,
    required this.title,
    required this.event,
    required this.selectedPrices,
    required this.selectedSeats,
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
          final ticket = TicketInformation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            eventId: event.id,
            eventTitle: event.title,
            eventStartTime: event.startTime,
            reservedSeats: selectedSeats,
            totalPrice:
                selectedPrices.fold(0.0, (sum, price) => sum + price.value),
          );
          saveTicketInformation(ticket);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoadingScreen()),
          );
        },
      ),
    );
  }
}

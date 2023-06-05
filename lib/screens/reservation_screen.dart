import 'package:culture_app/models/event.dart';
import 'package:culture_app/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationScreen extends StatefulWidget {
  final Event event;
  int seatsPerRow = 14;
  int nRows = 7;

  ReservationScreen({required this.event});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Seat> selectedSeats = [];
  List<Price> selectedPrices = [];

  double calculateTotalPrice(List<Price> prices) {
    return selectedPrices.fold(
        0.0, (previousValue, element) => previousValue + element.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.selectSeats,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 16.0 * widget.nRows + 16.0 * (widget.nRows - 1),
              child: InteractiveViewer(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.0,
                    crossAxisCount: widget.seatsPerRow,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: widget.nRows * widget.seatsPerRow,
                  itemBuilder: (context, index) {
                    final seat = Seat(
                      row: String.fromCharCode(
                          'A'.codeUnitAt(0) + index ~/ widget.seatsPerRow),
                      seatNumber: (index % widget.seatsPerRow + 1).toString(),
                    );
                    final isOccupied = widget.event.bookedSeats.contains(seat);
                    return GestureDetector(
                      onTap: isOccupied
                          ? null
                          : () {
                              setState(() {
                                if (selectedSeats.contains(seat)) {
                                  selectedSeats.remove(seat);
                                } else {
                                  selectedSeats.add(seat);
                                }
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOccupied
                              ? Theme.of(context).disabledColor
                              : selectedSeats.contains(seat)
                                  ? const Color.fromARGB(255, 0, 189, 19)
                                  : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Center(
                          child: Text(
                            '_',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Column(
              children: widget.event.prices.map((price) {
                return Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: null,
                            child: Text(
                              '${price.category}: ${price.value} €',
                            ))),
                    OutlinedButton(
                      onPressed: selectedPrices
                              .where((priceElement) =>
                                  priceElement.category == price.category)
                              .isEmpty
                          ? null
                          : () {
                              setState(() {
                                if (selectedPrices.contains(price)) {
                                  selectedPrices.remove(price);
                                } else {
                                  selectedPrices.add(price);
                                }
                              });
                            },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: null,
                      child: Text(
                        selectedPrices
                            .where((priceElement) =>
                                priceElement.category == price.category)
                            .length
                            .toString(),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: selectedPrices.length < selectedSeats.length
                          ? () {
                              setState(() {
                                selectedPrices.add(price);
                              });
                            }
                          : null,
                      child: const Text('+'),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Text(
                '${AppLocalizations.of(context)!.selectedSeats}: ${selectedSeats.length}'),
            Text(
                '${AppLocalizations.of(context)!.totalPrice}: ${calculateTotalPrice(widget.event.prices)}€'),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedPrices.length == selectedSeats.length &&
                        selectedSeats.isNotEmpty
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              event: widget.event,
                              selectedPrices: selectedPrices,
                              selectedSeats: selectedSeats,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.buyTickets),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

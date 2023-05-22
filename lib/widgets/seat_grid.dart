import 'package:culture_app/models/event.dart';
import 'package:flutter/material.dart';

class SeatGrid extends StatefulWidget {
  final List<Seat> occupiedSeats;

  SeatGrid({required this.occupiedSeats});

  @override
  _SeatGridState createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  List<bool> seatSelections = List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: seatSelections.length,
      itemBuilder: (context, index) {
        final seat = Seat(
          row: String.fromCharCode('A'.codeUnitAt(0) + index ~/ 6),
          seatNumber: (index % 6 + 1).toString(),
        );
        final isOccupied = widget.occupiedSeats.contains(seat);

        return GestureDetector(
          onTap: isOccupied
              ? null
              : () {
                  setState(() {
                    seatSelections[index] = !seatSelections[index];
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isOccupied
                  ? Colors.grey
                  : seatSelections[index]
                      ? Colors.green
                      : Colors.grey,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '${seat.row}${seat.seatNumber}',
              style: TextStyle(
                color: isOccupied ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

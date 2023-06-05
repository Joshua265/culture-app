import 'package:culture_app/models/event.dart';

class TicketInformation {
  final String id;
  final String eventId;
  final String eventTitle;
  final DateTime eventStartTime;
  final List<Seat> reservedSeats;
  final double totalPrice;

  TicketInformation(
      {required this.id,
      required this.eventId,
      required this.eventTitle,
      required this.eventStartTime,
      required this.reservedSeats,
      required this.totalPrice});

  // Method to convert TicketInformation object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': eventId,
      'eventTitle': eventTitle,
      'eventStartTime': eventStartTime.toIso8601String(),
      'reservedSeats': reservedSeats.map((s) => s.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  // Method to convert Map to TicketInformation object
  static TicketInformation fromMap(Map<String, dynamic> map) {
    return TicketInformation(
      id: map['id'],
      eventId: map['event'],
      eventTitle: map['eventTitle'],
      eventStartTime: DateTime.parse(map['eventStartTime']),
      reservedSeats:
          List<Seat>.from(map['reservedSeats'].map((s) => Seat.fromJson(s))),
      totalPrice: map['totalPrice'],
    );
  }
}

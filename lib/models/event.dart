class Event {
  final String id;
  final String title;
  final String location;
  final String city;
  final DateTime startTime;
  final DateTime endTime;
  final List<Price> prices;
  final String mediaCategory;
  final String imageId;
  final String description;
  final List<String> genres;
  final List<Seat> bookedSeats;

  Event({
    required this.id,
    required this.title,
    required this.city,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.prices,
    required this.mediaCategory,
    required this.imageId,
    required this.description,
    this.genres = const [],
    this.bookedSeats = const [],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      location: json['location'],
      city: json['city'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      prices: List<Price>.from(json['prices'].map((p) => Price.fromJson(p))),
      mediaCategory: json['mediaCategory'],
      imageId: json['imageId'],
      description: json['description'],
      genres: List<String>.from(json['genres']),
      bookedSeats:
          List<Seat>.from(json['bookedSeats'].map((s) => Seat.fromJson(s))),
    );
  }
}

class Price {
  final String category;
  final double value;

  Price({
    required this.category,
    required this.value,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      category: json['category'],
      value: double.parse(json['value'].toString()),
    );
  }
}

class Seat {
  final String row;
  final String seatNumber;

  Seat({
    required this.row,
    required this.seatNumber,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      row: json['row'],
      seatNumber: json['seatNumber'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Seat &&
        runtimeType == other.runtimeType &&
        row == other.row &&
        seatNumber == other.seatNumber;
  }

  @override
  int get hashCode => row.hashCode ^ seatNumber.hashCode;
}

const List<String> eventMediaCategory = [
  "theater",
  "cinema",
  "concert",
  "festival",
];

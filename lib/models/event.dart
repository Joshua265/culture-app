class Event {
  final String id;
  final String title;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final List<Price> prices;
  final String mediaCategory;
  final String contentId;
  final String imageUrl;
  final String description;
  final List<String> genres;
  final List<Seat> bookedSeats;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.prices,
    required this.mediaCategory,
    required this.contentId,
    required this.imageUrl,
    required this.description,
    this.genres = const [],
    this.bookedSeats = const [],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      location: json['location'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      prices: List<Price>.from(json['prices'].map((p) => Price.fromJson(p))),
      mediaCategory: json['mediaCategory'],
      contentId: json['contentId'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      genres: json['genres'],
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
      category: json['type'],
      value: double.parse(json['amount'].toString()),
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
}

const List<String> eventMediaCategory = [
  "theaters",
  "cinemas",
  "concerts",
  "festivals",
];

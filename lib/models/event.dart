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

  @override
  bool operator ==(other) {
    return (other is Event) && (other.title == title);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
      prices: json['prices'] != null
          ? List<Price>.from(json['prices'].map((p) => Price.fromJson(p)))
          : [],
      mediaCategory: json['mediaCategory'] ?? '',
      imageId: json['imageId'] ?? '',
      description: json['description'] ?? '',
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      bookedSeats: json['bookedSeats'] != null
          ? List<Seat>.from(json['bookedSeats'].map((s) => Seat.fromJson(s)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'city': city,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'prices': prices.map((price) => price.toMap()).toList(),
      'mediaCategory': mediaCategory,
      'imageId': imageId,
      'description': description,
      'genres': genres,
      'bookedSeats': bookedSeats.map((seat) => seat.toMap()).toList(),
    };
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

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'value': value,
    };
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

  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'seatNumber': seatNumber,
    };
  }
}

const List<String> eventMediaCategory = [
  "theater",
  "movie",
  "concert",
  "festival",
];

const List<String> genres = [
  "comedy",
  "drama",
  "horror",
  "romance",
  "action",
  "thriller",
  "mystery",
  "crime",
  "animation",
  "adventure",
  "fantasy"
];

enum BookingType { cab, bus }

class Booking {
  final String title;
  final DateTime dateTime;
  final double price;
  final bool paid;
  final BookingType type;

  Booking({
    required this.title,
    required this.dateTime,
    required this.price,
    required this.paid,
    required this.type,
  });
}

class Deal {
  final String tag;
  final String title;
  final String subtitle;
  final String badge;

  Deal({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

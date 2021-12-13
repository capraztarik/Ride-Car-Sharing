class PostModel {
  final String id;
  final Map owner;
  final String type;
  final String available_seats;
  final String departure_location;
  final String destination;
  final String caption;
  final DateTime ride_datetime;
  final DateTime post_datetime;
  final bool is_full;
  final int remaining_seats;

  const PostModel(
      { required this.id,
        required this.owner,
        required this.type,
        required this.available_seats,
        required this.departure_location,
        required this.destination,
        required this.caption,
        required this.ride_datetime,
        required this.post_datetime,
        required this.is_full,
        required this.remaining_seats,
       });


  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id:json['id'],
        owner:json['owner'],
        type:json['type'],
        available_seats:json['available_seats'],
        departure_location:json['departure_location'],
        destination:json['destination'],
        caption:json['caption'],
        ride_datetime:json['ride_datetime'],
        post_datetime:json['post_datetime'],
        is_full:json['is_full'],
        remaining_seats:json['remaining_seats'],
    );
  }
}

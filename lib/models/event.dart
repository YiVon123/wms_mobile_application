
enum EventStatus {
  // upcoming
  pending, confirmed,
  // on progress
  vehicle_received, diagnosing, in_progress, ready_for_pickup,
  // past
  completed, cancelled}

class Event{
  final String title;
  final String date;
  final String time;
  final DateTime dateTime;
  EventStatus status;

  Event ({
    required this.title,
    required this.date,
    required this.time,
    required this.dateTime,
    required this.status,
  });

  void cancelEvent(){
    status = EventStatus.cancelled;
  }

}
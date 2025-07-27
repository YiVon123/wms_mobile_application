
enum ServiceStatus {
  // upcoming
  pending, confirmed,
  // on progress
  vehicle_received, diagnosing, in_progress, ready_for_pickup,
  // past
  completed, cancelled}

class Service{
  final String title;
  final String date;
  final String time;
  final DateTime dateTime;
  ServiceStatus status;

  Service ({
    required this.title,
    required this.date,
    required this.time,
    required this.dateTime,
    required this.status,
  });

  void cancelservice(){
    status = ServiceStatus.cancelled;
  }

}
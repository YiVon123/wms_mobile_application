import 'package:flutter/material.dart';
import 'package:wms_mobile_application/models/event.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [
    Event(
      title: 'Car Maintenance',
      date: '2025-01-01',
      time: '10:00 AM',
      dateTime: DateTime(2025, 1, 1, 10, 0),
      status: EventStatus.completed,
    ),
    Event(
      title: 'Oil Change',
      date: '2025-01-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 1, 10, 10, 0),
      status: EventStatus.ready_for_pickup,
    ),
    Event(
      title: 'Tire Rotation',
      date: '2025-01-30',
      time: '10:00 AM',
      dateTime: DateTime(2025, 1, 30, 10, 0),
      status: EventStatus.pending,
    ),
  ];

  List<Event> get events => _events;

  List<Event> getUpcomingEvents() {
    final now = DateTime.now();
    return _events
        .where(
          (event) =>
              event.dateTime.isAfter(now) &&
              (event.status == EventStatus.pending ||
                  event.status == EventStatus.confirmed),
        )
        .toList();
  }

  List<Event> getOnProgressEvents() {
    final now = DateTime.now();
    return _events
        .where(
          (event) =>
              event.status == EventStatus.vehicle_received ||
              event.status == EventStatus.diagnosing ||
              event.status == EventStatus.in_progress ||
              event.status == EventStatus.ready_for_pickup,
        )
        .toList();
  }

  List<Event> getPastEvents() {
    final now = DateTime.now();
    return _events
        .where(
          (event) =>
              event.status == EventStatus.completed ||
              event.status == EventStatus.cancelled,
        )
        .toList();
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  // getNotificationEvents()


  // Method to update event status (e.g., cancel)
  // void cancelEvent(String eventId) {
  //   final index = _events.indexWhere((event) => event.id == eventId);
  //   if (index != -1) {
  //     _events[index].cancelEvent(); // Call the cancel method on the event object
  //     notifyListeners(); // Notify listeners to rebuild UI
  //   }
  // }


}

import 'package:flutter/material.dart';
import 'package:wms_mobile_application/models/service.dart';

class ServiceProvider extends ChangeNotifier {
  final List<Service> _services = [
    Service(
      title: 'Car Maintenance',
      date: '2025-07-01',
      time: '10:00 AM',
      // year month day hour min sec
      dateTime: DateTime(2025, 7, 1, 10, 0),
      status: ServiceStatus.completed,
    ),
    Service(
      title: 'Oil Change',
      date: '2025-10-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 10, 10, 10, 0),
      status: ServiceStatus.ready_for_pickup,
    ),
    Service(
      title: 'Engine',
      date: '2025-10-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 10, 10, 10, 0),
      status: ServiceStatus.ready_for_pickup,
    ),
    Service(
      title: 'Tire Rotation',
      date: '2025-10-30',
      time: '10:00 AM',
      dateTime: DateTime(2025, 10, 30, 10, 0),
      status: ServiceStatus.pending,
    ),
    Service(
      title: 'Oil Change',
      date: '2025-10-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 10, 10, 10, 0),
      status: ServiceStatus.confirmed,
    ),
    Service(
      title: 'Oil Change',
      date: '2025-09-10',
      time: '09:00 AM',
      dateTime: DateTime(2025, 9, 10, 10, 0),
      status: ServiceStatus.confirmed,
    ),
    Service(
      title: 'Change',
      date: '2025-09-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 9, 10, 10, 0),
      status: ServiceStatus.confirmed,
    ),
    Service(
      title: 'Oil Change',
      date: '2025-09-10',
      time: '09:00 AM',
      dateTime: DateTime(2025, 9, 10, 10, 0),
      status: ServiceStatus.confirmed,
    ),
    Service(
      title: 'Change',
      date: '2025-09-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 9, 10, 10, 0),
      status: ServiceStatus.confirmed,
    ),
    Service(
      title: 'Car Maintenance',
      date: '2025-09-10',
      time: '10:00 AM',
      dateTime: DateTime(2025, 9, 10, 10, 0),
      status: ServiceStatus.diagnosing,
    ),

  ];

  List<Service> get services => _services;

  List<Service> getUpcomingServices() {
    final now = DateTime.now();
    return _services
        .where(
          (service) =>
              service.dateTime.isAfter(now) &&
              (service.status == ServiceStatus.pending ||
                  service.status == ServiceStatus.confirmed),
        )
        .toList();
  }

  List<Service> getOnProgressServices() {
    return _services
        .where(
          (service) =>
              service.status == ServiceStatus.vehicle_received ||
              service.status == ServiceStatus.diagnosing ||
              service.status == ServiceStatus.in_progress ||
              service.status == ServiceStatus.ready_for_pickup,
        )
        .toList();
  }

  List<Service> getPastServices() {
    final now = DateTime.now();
    return _services
        .where(
          (service) =>
          service.dateTime.isBefore(now) &&
              (service.status == ServiceStatus.completed ||
              service.status == ServiceStatus.cancelled),
        )
        .toList();
  }

  void addService(Service service) {
    _services.add(service);
    notifyListeners();
  }

  // getNotificationservices()


  // Method to update service status (e.g., cancel)
  // void cancelservice(String serviceId) {
  //   final index = _services.indexWhere((service) => service.id == serviceId);
  //   if (index != -1) {
  //     _services[index].cancelservice(); // Call the cancel method on the service object
  //     notifyListeners(); // Notify listeners to rebuild UI
  //   }
  // }


}

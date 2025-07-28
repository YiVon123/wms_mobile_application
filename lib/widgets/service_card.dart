import 'package:flutter/material.dart';
import 'package:wms_mobile_application/models/service.dart';
import 'package:wms_mobile_application/constants/colors.dart';
import 'package:wms_mobile_application/widgets/progress_bar.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  // Status for On progress Service
  bool _isOnProgress(ServiceStatus status) {
    return [
      ServiceStatus.vehicle_received,
      ServiceStatus.diagnosing,
      ServiceStatus.in_progress,
      ServiceStatus.ready_for_pickup,
    ].contains(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        color: AppColors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${service.date}',
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Time: ${service.time}',
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Status: ${service.status.toString().split('.').last.replaceAll('_', ' ')}',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                  // mark as done button
                  if (service.status == ServiceStatus.ready_for_pickup)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(110, 40),
                        backgroundColor: AppColors.lightBlue,
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      ),
                      onPressed: () {},
                      child: const Text('Marked As Done', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),

              /// progress bar
              if (_isOnProgress(service.status)) ...[
                SizedBox(height: 20),
                ProgressBar(status: service.status),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
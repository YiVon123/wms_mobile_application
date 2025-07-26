import 'package:flutter/material.dart';
import 'package:wms_mobile_application/models/service.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  // Status for On progress Service
  bool get isOnProgress => [
    ServiceStatus.vehicle_received,
    ServiceStatus.diagnosing,
    ServiceStatus.in_progress,
    ServiceStatus.ready_for_pickup,
  ].contains(service.status);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 320,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        color: AppColors.lightGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Design for Past Service and On Progress Service
              Text(service.title),
              SizedBox(height: 8),
              Text('Date: ${service.date}'),
              SizedBox(height: 5),
              Text('Time: ${service.time}'),
              SizedBox(height: 5),
              Text('Status: ${service.status.toString().split('.').last}'),

              // If it is On Progress service, create status progress bar
              if(isOnProgress)...[
                SizedBox(height: 12),
                _buildProgressBar(service.status),
                SizedBox(height: 6),
                _buildProgressLabels(),
              ],

              // if status is ready_for_pickup, create done button
              if (service.status == ServiceStatus.ready_for_pickup)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Done'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // progress bar
  Widget _buildProgressBar(ServiceStatus currentStatus) {
    // const stages = [
    //   ServiceStatus.vehicle_received,
    //   ServiceStatus.diagnosing,
    //   ServiceStatus.in_progress,
    //   ServiceStatus.ready_for_pickup,
    // ];

    // final currentIndex = stages.indexOf(currentStatus);

      return Row(
        // children: List.generate(stages.length, (index) {
        //   bool isActive = index <= currentIndex;
        //   return Expanded(
        //     child: Row(
        //       children: [
        //         CircleAvatar(
        //           radius: 10,
        //           backgroundColor: isActive ? Colors.green : Colors.grey,
        //           child: Text('${index + 1}',
        //               style: TextStyle(fontSize: 10, color: Colors.white)),
        //         ),
        //         if (index != stages.length - 1)
        //           Expanded(
        //             child: Container(
        //               height: 2,
        //               color: isActive ? Colors.green : Colors.grey,
        //             ),
        //           ),
        //       ],
        //     ),
        //   );
        // }),
      );
  }

  //Build stage labels like: Received | Diagnosing | ...
  Widget _buildProgressLabels() {
    // const labels = ['Received', 'Diagnosing', 'In Progress', 'Pickup'];
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // children: labels
      //     .map((label) => Text(label, style: TextStyle(fontSize: 10)))
      //     .toList(),
    );
  }
}


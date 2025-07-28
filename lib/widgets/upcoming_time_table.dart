import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wms_mobile_application/models/service.dart';
import 'package:wms_mobile_application/constants/colors.dart';
import 'package:wms_mobile_application/providers/service_provider.dart';

class UpcomingTimeTable extends StatefulWidget {
  const UpcomingTimeTable({super.key});

  @override
  State<UpcomingTimeTable> createState() => _UpcomingTimeTableState();
}

class _UpcomingTimeTableState extends State<UpcomingTimeTable> {
  final DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  }

  // get service book dates
  List<DateTime> _getBookedDates(List<Service> services) {
    return services.map((service) {
      final dateParts = service.date.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final upcomingList = serviceProvider.getUpcomingServices();

    // check whether selected day same as service date
    final selectedDayServices = upcomingList.where((service) {
      return isSameDay(service.dateTime, selectedDay);
    }).toList();

    // get all booking dates
    final bookedDates = _getBookedDates(upcomingList);

    // map date to book
    Map<DateTime, List<String>> events = {
      for (var date in bookedDates) date: ['Booked']
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),

        // Display Today Date
        Center(
          child: Text(
            today.toString().split(' ')[0],
            style: const TextStyle(fontSize: 26),
          ),
        ),

        const SizedBox(height: 16),

        // Calendar
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.lightGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TableCalendar(
              rowHeight: 38,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2040, 1, 1),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              eventLoader: (day) =>
              events[DateTime(day.year, day.month, day.day)] ?? [],
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Selected date and services aligned under the calendar
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Selected ',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: selectedDay.toString().split(' ')[0],
                          style: const TextStyle(
                            color: AppColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // service
                  Expanded(
                    child: selectedDayServices.isEmpty
                        ? const Text(
                      'No services booked for this day.',
                      style: TextStyle(fontSize: 12),
                    )
                        : ListView.builder(
                      itemCount: selectedDayServices.length,
                      itemBuilder: (context, index) {
                        final service = selectedDayServices[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  service.title,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin:
                                    const EdgeInsets.only(right: 6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded( // Using Expanded here too for robustness
                                    child: Text(
                                      service.time,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
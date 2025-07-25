import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_mobile_application/providers/event_provider.dart';
import 'package:wms_mobile_application/models/event.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

// Declare tab bar
class _SchedulePageState extends State<SchedulePage> {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Upcoming'),
    Tab(text: 'Past'),
    Tab(text: 'On Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(
      context,
    ); // Access EventProvider
    return Scaffold(
      appBar: null,
      backgroundColor: AppColors.white,
      body: DefaultTabController(
        length: myTabs.length,
        child: SafeArea(
          child: Column(
              children: [
                TabBar(
                    tabs: myTabs,
                ),

                // Content of each tab bar
                Expanded(
                    child: TabBarView(
                        children: [
                          Center(

                              ),



                          Center(child: Text('Past')),
                          Center(child: Text('On Progress')),
                        ],
                    ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

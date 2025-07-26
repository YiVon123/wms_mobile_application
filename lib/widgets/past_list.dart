import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_mobile_application/providers/service_provider.dart';
import 'package:wms_mobile_application/widgets/service_card.dart';
import 'package:wms_mobile_application/models/service.dart';

class PastServicesList extends StatelessWidget {
  const PastServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);

    final List<Service> pastList = serviceProvider.getPastServices();

    return ListView.builder(
      itemCount: pastList.length,
      itemBuilder: (context, index) {
        return ServiceCard(service: pastList[index]);
      },
    );
  }
}

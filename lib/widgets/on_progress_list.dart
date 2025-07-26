import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_mobile_application/providers/service_provider.dart';
import 'package:wms_mobile_application/widgets/service_card.dart';

class OnProgressServicesList extends StatelessWidget {
  const OnProgressServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final onProgressList = serviceProvider.getOnProgressServices();

    return ListView.builder(
      itemCount: onProgressList.length,
      itemBuilder: (context, index) {
        return ServiceCard(service: onProgressList[index]);
      },
    );
  }
}

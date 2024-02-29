import 'package:flutter/material.dart';

class RevenueStatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String selectedPeriod = args['selectedPeriod'];
    final DateTime selectedDate = args['selectedDate'];

    // Thực hiện thống kê dựa trên selectedPeriod và selectedDate

    return Scaffold(
      appBar: AppBar(
        title: Text('Thống Kê Doanh Thu'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_home/revenue_statistics_options');
          },
        ),
      ),
      body: Center(
        child: Text(
          'Thống kê doanh thu theo $selectedPeriod ngày ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

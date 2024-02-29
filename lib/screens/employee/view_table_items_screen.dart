import 'package:flutter/material.dart';

class ViewTableItemsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;

  ViewTableItemsScreen({required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin món ăn đã chọn'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên món ăn: ${selectedItems[index]['name']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Số lượng: ${selectedItems[index]['quantity']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Giá tiền: ${selectedItems[index]['unit_price']} VND',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Tổng tiền: ${selectedItems[index]['total_price']} VND',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

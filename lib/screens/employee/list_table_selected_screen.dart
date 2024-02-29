import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'view_table_items_screen.dart'; // Import trang ViewTableItemsScreen

class ListTablesSlelectedScreen extends StatefulWidget {
  @override
  _ListTablesSlelectedScreenState createState() => _ListTablesSlelectedScreenState();
}

class _ListTablesSlelectedScreenState extends State<ListTablesSlelectedScreen> {
  List<Map<String, dynamic>> _tables = [];

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    List<Map<String, dynamic>> tables = await DatabaseHelper().getTables();
    List<Map<String, dynamic>> reservedTables = tables.where((table) => table['status'] == 1).toList();

    setState(() {
      _tables = reservedTables;
    });
  }

  void _onViewTableItemsButtonPressed(int tableId) async {
    List<Map<String, dynamic>> selectedItems = await DatabaseHelper().getSelectedItemsForTable(tableId);
    print('Selected items for table $tableId: $selectedItems'); // In ra dữ liệu để kiểm tra
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTableItemsScreen(selectedItems: selectedItems),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bàn đã chọn'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _tables.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                _onViewTableItemsButtonPressed(index);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_chart,
                      size: 50.0,
                      color: _tables[index]['status'] == 0 ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _tables[index]['name'], // Sửa lại tên cột tên nếu cần
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _onViewTableItemsButtonPressed(_tables[index]['id']);
                      },
                      child: Text('Xem chi tiết'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'select_empty_table_screen.dart'; // Import màn hình chọn bàn trống

class ChangeTableScreen extends StatefulWidget {
  @override
  _ChangeTableScreenState createState() => _ChangeTableScreenState();
}

class _ChangeTableScreenState extends State<ChangeTableScreen> {
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

  void _onTransferTableButtonPressed(int tableId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectEmptyTableScreen(currentTableId: tableId),
      ),
    ).then((selectedTableId) {
      if (selectedTableId != null) {
        _onConfirmTransferButtonPressed(tableId, selectedTableId);
      }
    });
  }

  void _onConfirmTransferButtonPressed(int currentTableId, int newTableId) async {
    try {
      await DatabaseHelper().transferTable(currentTableId, newTableId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chuyển bàn thành công!'),
        ),
      );
      Navigator.pop(context); // Đóng màn hình chuyển bàn sau khi chuyển thành công
    } catch (error) {
      print('Lỗi khi chuyển bàn: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi chuyển bàn. Vui lòng thử lại sau.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyển bàn'),
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
                int tableId = _tables[index]['id'];
                _onTransferTableButtonPressed(tableId);
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
                        int tableId = _tables[index]['id']; // Sửa lại tên cột ID nếu cần
                        _onTransferTableButtonPressed(tableId);
                      },
                      child: Text('Chuyển bàn'),
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

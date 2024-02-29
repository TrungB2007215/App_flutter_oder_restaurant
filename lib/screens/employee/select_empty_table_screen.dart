import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class SelectEmptyTableScreen extends StatefulWidget {
  final int currentTableId;

  SelectEmptyTableScreen({required this.currentTableId});

  @override
  _SelectEmptyTableScreenState createState() => _SelectEmptyTableScreenState();
}

class _SelectEmptyTableScreenState extends State<SelectEmptyTableScreen> {
  List<Map<String, dynamic>> _emptyTables = [];
  late int _selectedTableId;

  @override
  void initState() {
    super.initState();
    _loadEmptyTables();
  }

  Future<void> _loadEmptyTables() async {
    List<Map<String, dynamic>> tables = await DatabaseHelper().getTables();
    List<Map<String, dynamic>> emptyTables = tables.where((table) => table['status'] == 0).toList();

    setState(() {
      _emptyTables = emptyTables;
      if (_emptyTables.isNotEmpty) {
        _selectedTableId = _emptyTables[0]['id'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn bàn trống'),
      ),
      body: ListView.builder(
        itemCount: _emptyTables.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile<int>(
            title: Text('${_emptyTables[index]['name']}'),
            value: _emptyTables[index]['id'],
            groupValue: _selectedTableId,
            onChanged: (int? value) {
              setState(() {
                _selectedTableId = value!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _confirmTransfer(context),
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> _confirmTransfer(BuildContext context) async {
    // Assume that the table transfer is successful

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chuyển bàn thành công!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, _selectedTableId);
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}

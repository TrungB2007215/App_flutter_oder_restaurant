import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class EditTableDetailsScreen extends StatefulWidget {
  final int tableId;

  EditTableDetailsScreen({required this.tableId});

  @override
  _EditTableDetailsScreenState createState() => _EditTableDetailsScreenState();
}

class _EditTableDetailsScreenState extends State<EditTableDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Map<String, dynamic> _tableInfo = {};

  @override
  void initState() {
    super.initState();
    _getTableInfo();
  }

  Future<void> _getTableInfo() async {
    Map<String, dynamic>? tableInfo = await DatabaseHelper().getTableInfo(widget.tableId);

    if (tableInfo != null) {
      setState(() {
        _tableInfo = tableInfo;
        _nameController.text = tableInfo['name'];
        _statusController.text = tableInfo['status'].toString();
      });
    }
  }

  Future<void> _updateTableInfo() async {
    String name = _nameController.text;
    int status = int.tryParse(_statusController.text) ?? 0;

    try {
      // Kiểm tra xem tên mới có trùng với tên của bàn khác không
      bool isDuplicate = await DatabaseHelper().isTableNameDuplicate(widget.tableId, name);

      if (isDuplicate) {
        // Hiển thị cảnh báo nếu tên trùng lặp
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Tên bàn đã tồn tại. Vui lòng chọn một tên khác.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Nếu không có tên trùng lặp, tiến hành cập nhật thông tin
        await DatabaseHelper().updateTableInfo(widget.tableId, name, status);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cập nhật thông tin thành công'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã có lỗi xảy ra khi cập nhật thông tin. Vui lòng thử lại sau.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin bàn'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên bàn',
                icon: Icon(Icons.table_chart),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _statusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Trạng thái (0: Trống, 1: Đã đặt)',
                icon: Icon(Icons.info),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                int status = int.tryParse(_statusController.text) ?? 0;

                try {
                  await _updateTableInfo();
                } catch (error) {
                  print('Error: $error');
                }
              },
              child: Text('Cập nhật thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class AddTableScreen extends StatefulWidget {
  @override
  _AddTableScreenState createState() => _AddTableScreenState();
}

class _AddTableScreenState extends State<AddTableScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController(text: '0');

  void _addTable() async {
    String name = _nameController.text;
    String statusText = _statusController.text;

    // Kiểm tra xem có trường nào trống không
    if (name.isEmpty || statusText.isEmpty) {
      // Hiển thị thông báo nếu có trường trống
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Vui lòng nhập đầy đủ thông tin.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Kết thúc hàm nếu có trường trống
    }

    int status = int.tryParse(statusText) ?? 0;

    // Tiếp tục thêm bàn nếu không có trường trống
    try {
      // Kiểm tra bàn đã tồn tại hay chưa
      Map<String, dynamic>? existingTable = await DatabaseHelper().getTableByName(name);
      if (existingTable != null) {
        // Hiển thị thông báo nếu bàn đã tồn tại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Bàn đã tồn tại'),
              content: Text('Bàn $name đã tồn tại. Vui lòng chọn tên khác.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Kết thúc hàm nếu bàn đã tồn tại
      }

      await DatabaseHelper().insertTable(name, status);

      // Hiển thị thông báo khi thêm bàn thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thêm bàn thành công'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  Navigator.pop(context); // Trở về màn hình trước đó
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Hiển thị thông báo khi có lỗi xảy ra
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã có lỗi xảy ra khi thêm bàn. Vui lòng thử lại sau.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
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
        title: Text('Thêm bàn ăn'),
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
              onPressed: _addTable,
              child: Text('Thêm bàn'),
            ),
          ],
        ),
      ),
    );
  }
}


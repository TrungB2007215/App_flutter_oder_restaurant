import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _addDishList() async {
    String name = _nameController.text;

    if (name.trim().isEmpty) {
      // Hiển thị thông báo nếu tên danh sách trống
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tên danh mục trống'),
            content: Text('Vui lòng nhập tên danh mục món ăn.'),
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
      return; // Kết thúc hàm nếu tên danh sách trống
    }

    try {
      // Kiểm tra danh sách món đã tồn tại hay chưa
      Map<String, dynamic>? existingDishList = await DatabaseHelper().getDishListByName(name);
      if (existingDishList != null) {
        // Hiển thị thông báo nếu danh sách món đã tồn tại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Danh mục món đã tồn tại'),
              content: Text('Tên danh mục đã tồn tại vui lòng chọn một tên khác'),
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
        return; // Kết thúc hàm nếu danh sách món đã tồn tại
      }

      await DatabaseHelper().insertDishList(name);

      // Hiển thị thông báo khi thêm danh sách món thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thêm danh mục thành công'),
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
            content: Text('Đã có lỗi xảy ra khi thêm danh mục món. Vui lòng thử lại sau.'),
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
        title: Text('Thêm danh mục món ăn'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                labelText: 'Tên danh mục',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDishList,
              child: Text('Thêm danh mục'),
            ),
          ],
        ),
      ),
    );
  }
}

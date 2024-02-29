import 'package:flutter/material.dart';
// Import các trang hoặc thành phần cần thiết khác

class EmployeeHomeScreen extends StatelessWidget {

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _openDrawer(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'), // Đường dẫn đến tệp ảnh
                    radius: 50, // Độ lớn của ảnh (tuỳ chỉnh)
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Quản lý tài khoản',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: Text('Đăng xuất'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/employee_home/tables_selected');
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.info_outline, size: 25),
                    Text('Thông tin bàn đã chọn', style: TextStyle(fontSize: 20)),
                    Text('Chi tiết bàn ăn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/employee_home/choose_table');
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.table_chart, size: 25),
                    Text('Chọn bàn ăn', style: TextStyle(fontSize: 20)),
                    Text('Chọn món ăn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/employee_home/generate_invoice');
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.receipt, size: 25),
                    Text('Xuất hóa đơn', style: TextStyle(fontSize: 20)),
                    Text('Thông tin hóa đơn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/employee_home/change_table');
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.swap_horiz, size: 25),
                    Text('Chuyển bàn ăn', style: TextStyle(fontSize: 20)),
                    Text('Thông tin chuyển bàn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/employee_home/add_dish');
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.add, size: 25),
                    Text('Thêm món lên bàn ăn', style: TextStyle(fontSize: 20)),
                    Text('Thêm món lên bàn ăn'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  // Hàm mở Drawer
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
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   title: Text('Chỉnh sửa tài khoản'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/admin_home/edit_admin_account');
            //   },
            // ),
            ListTile(
              title: Text('Đăng ký tài khoản admin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_home/register_admin');
              },
            ),
            ListTile(
              title: Text('Đăng ký tài khoản nhân viên'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_home/register_employee');
              },
            ),
            ListTile(
              title: Text('Đăng xuất'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/'); // Đăng xuất và quay về trang đăng nhập
              },
            ),
          ],
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          // Chức năng quản lý bàn ăn
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_home/manage_tables');
                // Hiển thị thông tin trạng thái bàn ăn
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.table_chart, size: 25),
                    Text('Quản lý bàn ăn', style: TextStyle(fontSize: 20)),
                    Text('Thông tin bàn ăn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Khoảng cách giữa các chức năng
          // Chức năng quản lý thực đơn
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_home/manage_menu');
                // Hiển thị danh mục món ăn
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.restaurant_menu, size: 25),
                    Text('Quản lý thực đơn', style: TextStyle(fontSize: 20)),
                    Text('Danh mục món ăn'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Khoảng cách giữa các chức năng
          // Chức năng thống kê doanh thu
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_home/revenue_statistics_options');
                // Hiển thị thông tin doanh thu
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 25),
                    Text('Thống kê doanh thu', style: TextStyle(fontSize: 20)),
                    Text('Thông tin doanh thu'),
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

import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'admin/admin_home_screen.dart';
import 'employee/employee_home_screen.dart';

class LoginScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _login(BuildContext context, String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      // Hiển thị thông báo khi thông tin đăng nhập trống
      _showErrorDialog(context, 'Vui lòng nhập đầy đủ thông tin đăng nhập.');
      return;
    }

    // Gọi hàm kiểm tra đăng nhập từ database_helper.dart
    Map<String, dynamic>? user = await _databaseHelper.getUser(username, password);

    if (user != null) {
      // Kiểm tra vai trò của người dùng và điều hướng đến màn hình tương ứng
      if (user['role'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin_home');
      } else if (user['role'] == 'employee') {
        Navigator.pushReplacementNamed(context, '/employee_home');
      }
    } else {
      // Xử lý trường hợp đăng nhập không thành công
      _showErrorDialog(context, 'Tên đăng nhập hoặc mật khẩu không đúng.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi đăng nhập'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            TextField(
              onChanged: (value) {
                username = value;
              },
              decoration: InputDecoration(
                  labelText: 'Username', icon: Icon(Icons.person)),
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _login(context, username, password);
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}

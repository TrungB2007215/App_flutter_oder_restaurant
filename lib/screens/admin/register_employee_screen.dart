import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class RegisterEmployeeScreen extends StatefulWidget {
  @override
  _RegisterEmployeeScreenState createState() => _RegisterEmployeeScreenState();
}

class _RegisterEmployeeScreenState extends State<RegisterEmployeeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _registerAdmin(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var existingUser = await _databaseHelper.getUserByUsername(username);

    if (username.isEmpty || password.isEmpty) {
      // Hiển thị thông báo yêu cầu nhập
      _showAlertDialog(context, 'Vui lòng điền đầy đủ thông tin!', false);
      return; // Dừng lại nếu dữ liệu trống
    }

    if (existingUser != null) {
      // Tài khoản đã tồn tại
      _showAlertDialog(context, 'Tài khoản đã tồn tại!', false);
    } else {
      // Tài khoản chưa tồn tại, tiến hành đăng ký
      await _databaseHelper.insertUser(username, password, 'employee');
      _showAlertDialog(context, 'Đăng ký tài khoản thành công!', true);

    }
  }

  void _showAlertDialog(BuildContext context, String message, bool isSuccessful) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  if (isSuccessful) {
                    Navigator.of(context).pop(); // Trở lại màn hình trước đó
                  }
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký tài khoản nhân viên'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            TextField(
              controller: _usernameController,

              decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  icon: Icon(Icons.person)
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu', icon: Icon(Icons.lock)),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _registerAdmin(context);
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}

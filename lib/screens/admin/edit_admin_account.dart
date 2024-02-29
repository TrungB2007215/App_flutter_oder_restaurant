import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class EditAdminAccountScreen extends StatefulWidget {
  final int adminId;

  EditAdminAccountScreen({required this.adminId});

  @override
  _EditAdminAccountScreenState createState() => _EditAdminAccountScreenState();
}

class _EditAdminAccountScreenState extends State<EditAdminAccountScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    // Load thông tin tài khoản admin từ cơ sở dữ liệu
    _loadAdminInfo();
  }

  void _loadAdminInfo() async {
    Map<String, dynamic> adminInfo = await _databaseHelper.getAdminInfo(widget.adminId);
    setState(() {
      _usernameController.text = adminInfo['username'];
      _passwordController.text = adminInfo['password'];
    });
  }

  void _updateAdminInfo(BuildContext context, int adminId) async {
    String newUsername = _usernameController.text;
    String newPassword = _passwordController.text;

    await _databaseHelper.updateAdminInfo(adminId, newUsername, newPassword);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã cập nhật thông tin tài khoản admin!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin admin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _updateAdminInfo(context, widget.adminId);
              },
              child: Text('Cập nhật thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}

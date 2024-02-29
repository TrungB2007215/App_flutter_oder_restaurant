import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class ManageAccountsScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _addAdminAccount(BuildContext context) async {
    await _databaseHelper.insertUser('admin', 'password123', 'admin');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã thêm tài khoản admin!'),
    ));
  }

  void _addEmployeeAccount(BuildContext context) async {
    await _databaseHelper.insertUser('employee', 'password456', 'employee');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã thêm tài khoản nhân viên!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài khoản'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _addAdminAccount(context);
              },
              child: Text('Thêm tài khoản admin'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEmployeeAccount(context);
              },
              child: Text('Thêm tài khoản nhân viên'),
            ),
          ],
        ),
      ),
    );
  }
}

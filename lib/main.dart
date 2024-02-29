import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/register_admin_screen.dart';
import 'screens/admin/register_employee_screen.dart';
import 'screens/admin/edit_admin_account.dart';
import 'screens/admin/manage_tables_screen.dart';
import 'screens/admin/tables/list_table_sreen.dart';
import 'screens/admin/tables/add_table_screen.dart';
import 'screens/admin/tables/edit_table_screen.dart';
import 'screens/admin/tables/remove_table_screen.dart';
import 'screens/admin/manage_menu_screen.dart';
import 'screens/admin/menu/add_category_screen.dart';
import 'screens/admin/menu/edit_category_screen.dart';
import 'screens/admin/menu/remove_category_screen.dart';
import 'screens/admin/menu/list_category_screen.dart';
import 'screens/admin/menu/add_dish_screen.dart';
import 'screens/admin/menu/edit_dish_screen.dart';
import 'screens/admin/menu/remove_dish_screen.dart';
import 'screens/admin/menu/list_dish_screen.dart';
import 'screens/admin/revenue_statistics_options_screen.dart';

import 'screens/employee/employee_home_screen.dart';
import 'screens/employee/select_table_screen.dart';
import 'screens/employee/generate_invoice_screen.dart';
import 'screens/employee/change_table_screen.dart';
import 'screens/employee/add_item_to_table_screen.dart';
import 'screens/employee/list_table_selected_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();
  runApp(MyApp());
  // DatabaseHelper().deleteAllUsers();
  // DatabaseHelper().insertUser('admin', 'a', 'admin');
  // DatabaseHelper().insertUser('employee', 'a', 'employee');
  // DatabaseHelper().deleteAllData();
  // DatabaseHelper().insertTable('Bàn 1', 0);
  // DatabaseHelper().insertTable('Bàn 2', 0);
  // DatabaseHelper().insertTable('Bàn 3', 0);
  // DatabaseHelper().insertTable('Bàn 4', 0);
  // DatabaseHelper().insertTable('Bàn 5', 0);
  // DatabaseHelper().insertTable('Bàn 6', 0);
  // DatabaseHelper().insertTable('Bàn 7', 0);
  // DatabaseHelper().insertTable('Bàn 8', 0);
  // DatabaseHelper().insertTable('Bàn 9', 0);
  // DatabaseHelper().insertTable('Bàn 10', 0);
  // DatabaseHelper().insertTable('Bàn 11', 0);
  // DatabaseHelper().insertTable('Bàn 12', 0);

}

class MyApp extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Management App',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF8F4517, {
          50: Color.fromRGBO(143, 69, 23, 0.1),
          100: Color.fromRGBO(143, 69, 23, 0.2),
          200: Color.fromRGBO(143, 69, 23, 0.3),
          300: Color.fromRGBO(143, 69, 23, 0.4),
          400: Color.fromRGBO(143, 69, 23, 0.5),
          500: Color.fromRGBO(143, 69, 23, 0.6),
          600: Color.fromRGBO(143, 69, 23, 0.7),
          700: Color.fromRGBO(143, 69, 23, 0.8),
          800: Color.fromRGBO(143, 69, 23, 0.9),
          900: Color.fromRGBO(143, 69, 23, 1),
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Đặt màn hình khởi đầu là trang đăng nhập
      routes: {
        '/': (context) => LoginScreen(), // Trang đăng nhập
        '/admin_home': (context) => AdminHomeScreen(), // Trang chính của admin
        '/admin_home/register_admin': (context) => RegisterAdminScreen(), // Đăng ký tài khoản admin
        '/admin_home/register_employee': (context) => RegisterEmployeeScreen(), // Đăng ký tài khoản employee
        '/admin_home/manage_tables': (context) => ManageTablesScreen(), // quản lý bàn ăn
        '/admin_home/manage_tables/table_list': (context) => TableListScreen(), // danh sách bàn ăn
        '/admin_home/manage_tables/add_table': (context) => AddTableScreen(), // thêm bàn ăn
        '/admin_home/manage_tables/remove_table': (context) => RemoveTableScreen(), // thêm bàn ăn
        '/admin_home/manage_tables/edit_table': (context) => EditTableScreen(), // chỉnh sửa bàn ăn
        '/admin_home/manage_menu': (context) => ManageMenuScreen(), // quản lý menu
        '/admin_home/manage_menu/add_category': (context) => AddCategoryScreen(), //them danh muc
        '/admin_home/manage_menu/edit_category': (context) => EditCategoryScreen(),
        '/admin_home/manage_menu/remove_category': (context) => RemoveCategoryScreen(),
        '/admin_home/manage_menu/list_category': (context) => ListCategoryScreen(),
        '/admin_home/manage_menu/add_dish': (context) => AddDishScreen(),
        '/admin_home/manage_menu/edit_dish': (context) => EditDishScreen(),
        '/admin_home/manage_menu/remove_dish': (context) => RemoveDishScreen(),
        '/admin_home/manage_menu/list_dish': (context) => ListDishScreen(),
        '/admin_home/revenue_statistics_options': (context) => RevenueStatisticsOptionsScreen(),

        // '/admin_home/edit_admin_account': (context) => EditAdminAccountScreen(adminId: adminId),
        '/employee_home': (context) => EmployeeHomeScreen(), // Trang chính của nhân viên
        '/employee_home/choose_table': (context) => SelectTableScreen(),
        '/employee_home/generate_invoice': (context) => GenerateInvoiceScreen(),
        '/employee_home/change_table': (context) => ChangeTableScreen(),
        '/employee_home/add_dish': (context) => AddItemToTableScreen(),
        '/employee_home/tables_selected': (context) => ListTablesSlelectedScreen(),
      },
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      password TEXT,
      role TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE tables (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      status INTEGER
    )
  ''');
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE dishes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      price REAL,
      category_id INTEGER,
      imagePath TEXT,
      describe TEXT,
      FOREIGN KEY (category_id) REFERENCES categories(id)
    )
  ''');
    await db.execute('''
    CREATE TABLE invoices (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_id INTEGER,
      created_at DATETIME,
      total_amount REAL,
      FOREIGN KEY (table_id) REFERENCES tables(id)
    )
  ''');
    await db.execute('''
    CREATE TABLE invoice_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoice_id INTEGER,
      dish_id INTEGER,
      quantity INTEGER,
      unit_price REAL,
      FOREIGN KEY (invoice_id) REFERENCES invoices(id),
      FOREIGN KEY (dish_id) REFERENCES dishes(id)
    )
  ''');
  }


  Future<int> insertUser(String username, String password, String role) async {
    final Database db = await database;
    return await db.insert(
      'users',
      {'username': username, 'password': password, 'role': role},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return users.isNotEmpty ? users.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    // Thực hiện truy vấn lấy người dùng theo tên đăng nhập
    List<Map<String, dynamic>>? result = await _database?.rawQuery(
      '''
    SELECT * FROM users WHERE username = ?
    ''',
      [username],
    );

    // Nếu không có người dùng nào có tên đăng nhập tương ứng, trả về null
    if (result == null || result.isEmpty) {
      return null;
    }

    // Nếu có, trả về thông tin người dùng
    return result.first;
  }

  getAdminInfo(int adminId) {}

  updateAdminInfo(int adminId, String newUsername, String newPassword) {}

  Future<int> insertTable(String name, int status) async {
    final Database db = await database;
    return await db.insert('tables', {'name': name, 'status': status},
      conflictAlgorithm: ConflictAlgorithm.replace,);

  }

  Future<List<Map<String, dynamic>>> getTables() async {
    Database db = await database;
    return await db.query('tables');
  }

  Future<bool> isTableNameDuplicate(int currentTableId, String newName) async {
    Database db = await database;
    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT id FROM tables WHERE name=? AND id<>?",
      [newName, currentTableId],
    );
    return tables.isNotEmpty;
  }


  Future<Map<String, dynamic>?> getTableByName(String name) async {
    List<Map<String, dynamic>>? result = await _database?.rawQuery(
      '''
      SELECT * FROM tables WHERE name = ?
    ''',
      [name],
    );

    if (result == null || result.isEmpty) {
      return null;
    }

    return result.first;
  }
  Future<void> deleteTable(String name) async {
    final Database db = await database;
    await db.delete(
      'tables',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
  Future<void> deleteAllTables() async {
    final Database db = await database;
    await db.delete('tables');
  }
  Future<Map<String, dynamic>?> getTableInfo(int tableId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'tables',
      where: 'id = ?',
      whereArgs: [tableId],
    );

    return result.isNotEmpty ? result.first : null;
  }
  Future<void> updateTableInfo(int tableId, String newName, int newStatus) async {
    Database db = await database;
    await db.update(
      'tables',
      {'name': newName, 'status': newStatus},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<int> insertDishList(String name) async {
    final Database db = await database;
    return await db.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getDishLists() async {
    Database db = await database;
    return await db.query('categories');
  }

  Future<void> deleteDishList(String name) async {
    final Database db = await database;
    await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<Map<String, dynamic>?> getDishListByName(String name) async {
    List<Map<String, dynamic>>? result = await _database?.rawQuery(
      '''
      SELECT * FROM categories WHERE name = ?
    ''',
      [name],
    );

    if (result == null || result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<Map<String, dynamic>?> getCategoryInfo(int categoryId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Lấy danh mục theo ID
  Future<Map<String, dynamic>> getCategoryById(int categoryId) async {
    Database db = await database; // Đảm bảo rằng cơ sở dữ liệu đã được khởi tạo

    List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    return result.first;
  }

  Future<bool> isCategoryNameExists(int categoryId, String categoryName) async {
    final db = await database; // Assuming you have a method 'database' to get the database instance

    // Check if there is any category with the same name excluding the current category
    List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: 'name = ? AND id != ?',
      whereArgs: [categoryName, categoryId],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getDishesByCategory(String category) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM dishes 
    WHERE category_id = (
      SELECT id FROM categories WHERE name = ?
    )
  ''', [category]);
    return result;
  }



  Future<void> updateCategory(int categoryId, String newName) async {
    Database db = await database;
    await db.update(
      'categories',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final Database db = await database;
    return await db.query('categories');
  }

  Future<void> deleteCategory(String categoryName) async {
    final Database db = await database;
    await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [categoryName],
    );
  }

  Future<void> deleteAllCategories() async {
    final Database db = await database;
    await db.delete('categories');
  }

  Future<void> insertDish(String name, double price, int categoryId, String imagePath, String describe) async {
    final Database db = await database;
    await db.insert(
      'dishes',
      {
        'name': name,
        'price': price,
        'category_id': categoryId,
        'imagePath': imagePath,
        'describe': describe,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getDishInfo(int dishId) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('dishes', where: 'id = ?', whereArgs: [dishId]);
    return result.isNotEmpty ? result.first : {};
  }

  Future<Map<String, dynamic>> getDishByName(String name) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('dishes', where: 'name = ?', whereArgs: [name]);
    return result.isNotEmpty ? result.first : {};
  }

  Future<List<Map<String, dynamic>>> getDishes() async {
    final Database db = await database;
    return await db.query('dishes');
  }

  Future<int> deleteDish(int dishId) async {
    final Database db = await database;
    return await db.delete('dishes', where: 'id = ?', whereArgs: [dishId]);
  }

  Future<int> updateDishInfo(int dishId, String name, double price, int categoryId, String imagePath) async {
    final Database db = await database;
    return await db.update('dishes', {
      'name': name,
      'price': price,
      'category_id': categoryId,
      'imagePath': imagePath,
    }, where: 'id = ?', whereArgs: [dishId]);
  }

  Future<bool> isDishExists(String dishName, {int? dishId}) async {
    final Database db = await database;

    // Query the database to check if a dish with the given name exists
    List<Map<String, dynamic>> result;
    if (dishId != null) {
      result = await db.query(
        'dishes',
        where: 'name = ? AND id <> ?',
        whereArgs: [dishName, dishId],
      );
    } else {
      result = await db.query(
        'dishes',
        where: 'name = ?',
        whereArgs: [dishName],
      );
    }

    return result.isNotEmpty;
  }

  Future<void> deleteAllDishes() async {
    final db = await database;
    await db.delete('dishes');
  }

  Future<Map<String, dynamic>> getDish(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'dishes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.first;
  }

  Future<void> updateDishImage(int dishId, String imagePath) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE dishes SET imagePath = ? WHERE id = ?',
      [imagePath, dishId],
    );
  }

  Future<void> updateDish(int id, String name, double price, int categoryId, String imagePath, String describe) async {
    final db = await database;
    await db.update(
      'dishes',
      {
        'id': id,
        'name': name,
        'price': price,
        'category_id': categoryId,
        'imagePath': imagePath,
        'describe': describe,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<Map<String, dynamic>> getDishDetails(int dishId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('dishes', where: 'id = ?', whereArgs: [dishId]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {}; // Return an empty map if the dish with the given ID is not found
    }
  }

  Future<void> addDishToTable(int tableId, int dishId, double total, {int quantity = 1}) async {
    Database db = await database;
    await db.transaction((txn) async {
      // Kiểm tra xem bàn đã có hóa đơn chưa
      List<Map<String, dynamic>> invoices = await txn.rawQuery('''
      SELECT id FROM invoices WHERE table_id = ?
    ''', [tableId]);

      int invoiceId;

      if (invoices.isNotEmpty) {
        // Nếu đã có hóa đơn, lấy ID của hóa đơn đó
        invoiceId = invoices[0]['id'];
      } else {
        // Nếu chưa có hóa đơn, tạo hóa đơn mới
        invoiceId = await txn.rawInsert('''
        INSERT INTO invoices (table_id, created_at, total_amount)
        VALUES (?, DATETIME('now'), ?)
      ''', [tableId, total]);
      }

      // Thêm món vào hóa đơn
      await txn.rawInsert('''
      INSERT INTO invoice_items (invoice_id, dish_id, quantity, unit_price)
      VALUES (?, ?, ?, (SELECT price FROM dishes WHERE id = ?))
    ''', [invoiceId, dishId, quantity, dishId]);

      // Cập nhật trạng thái của bàn
      await txn.rawUpdate('''
      UPDATE tables 
      SET status = 1
      WHERE id = ?
    ''', [tableId]);
    });
  }

  Future<List<Map<String, dynamic>>> getInvoiceItemsForTable(int tableId) async {
    final Database db = await database;
    return await db.query('invoice_items',
        where: 'invoice_id = ?',
        whereArgs: [tableId]);
  }

  Future<void> updateInvoiceItemQuantity(int tableId, int dishId, int quantity) async {
    final Database db = await database;
    await db.rawUpdate('''
    UPDATE invoice_items
    SET quantity = ?
    WHERE invoice_id = (SELECT id FROM invoices WHERE table_id = ?)
    AND dish_id = ?
  ''', [quantity, tableId, dishId]);
  }

  Future<void> updateTableStatus(int tableId, int status) async {
    final Database db = await database;
    await db.rawUpdate('''
    UPDATE tables 
    SET status = ? 
    WHERE id = ?
  ''', [status, tableId]);
  }

  Future<List<Map<String, dynamic>>> getReservedTables() async {
    final Database db = await database;
    return await db.query(
      'tables', // Thay 'tables' bằng tên bảng chứa thông tin bàn của bạn
      where: 'status = ?', // Lọc theo trạng thái đã đặt
      whereArgs: [1], // Giá trị 1 đại diện cho trạng thái đã đặt
    );
  }

  Future<void> exportInvoiceForTable(int tableId) async {
    final Database db = await database;

    // Bước 1: Lấy ID của hóa đơn liên quan đến bàn
    final List<Map<String, dynamic>> invoices = await db.query(
      'invoices',
      where: 'table_id = ?',
      whereArgs: [tableId],
      columns: ['id'],
    );

    if (invoices.isEmpty) {
      throw Exception('No invoice found for table $tableId');
    }

    int invoiceId = invoices.first['id'];

    // Bước 2: Lấy danh sách món ăn cho hóa đơn cụ thể
    final List<Map<String, dynamic>> invoiceItems = await getOrderedDishes(invoiceId);

    // Bước 3: Tính tổng cộng
    double totalAmount = 0;
    for (var item in invoiceItems) {
      totalAmount += item['quantity'] * item['unit_price'];
    }

    // Bước 4: Cập nhật trạng thái của bàn
    await db.update(
      'tables',
      {'status': 0},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<bool> checkInvoiceExists(int tableId) async {
    final Database db = await database;

    // Thực hiện truy vấn kiểm tra sự tồn tại của hóa đơn cho bàn đã cho
    List<Map<String, dynamic>> invoices = await db.query(
      'invoices',
      where: 'table_id = ?',
      whereArgs: [tableId],
      columns: ['id'],
    );

    return invoices.isNotEmpty;
  }

  Future<void> transferTable(int currentTableId, int newTableId) async {
    final Database db = await database;
    await db.transaction((txn) async {
      // Cập nhật trạng thái của bàn cũ (status = 0 - trống)
      await txn.rawUpdate('UPDATE tables SET status = 0 WHERE id = ?', [currentTableId]);

      // Cập nhật trạng thái của bàn mới (status = 1 - đã đặt)
      await txn.rawUpdate('UPDATE tables SET status = 1 WHERE id = ?', [newTableId]);

      // Chuyển các món ăn từ bàn cũ sang bàn mới (cập nhật `table_id` trong các món ăn)
      await txn.rawUpdate('UPDATE invoices SET table_id = ? WHERE table_id = ?', [newTableId, currentTableId]);
    });
  }

  Future<List<Map<String, dynamic>>> getSelectedItemsForTable(int tableId) async {
    final Database db = await database;

    // Lấy danh sách món ăn đã chọn cho bàn với giá tiền và tổng tiền
    List<Map<String, dynamic>> selectedItems = await db.rawQuery('''
    SELECT invoice_items.id, dishes.name, invoice_items.quantity, invoice_items.unit_price,
      (invoice_items.quantity * invoice_items.unit_price) AS total_price
    FROM invoice_items
    INNER JOIN dishes ON invoice_items.dish_id = dishes.id
    INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
    WHERE invoices.table_id = ?
  ''', [tableId]);

    return selectedItems;
  }

  Future<int> getTableIdByInvoiceId(int invoiceId) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'invoice_items',
      columns: ['table_id'],
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );

    if (result.isNotEmpty) {
      return result[0]['table_id'];
    } else {
      return -1;
    }
  }

  Future<int> getInvoiceIdForTable(int tableId) async {
    try {
      final Database db = await database;

      // Lấy invoiceId từ tableId
      List<Map<String, dynamic>> invoices = await db.query(
        'invoices',
        where: 'table_id = ?',
        whereArgs: [tableId],
        columns: ['id'],
      );

      if (invoices.isNotEmpty) {
        return invoices.first['id'];
      } else {
        // Nếu không tìm thấy invoiceId cho tableId cụ thể
        throw Exception('No invoice found for table $tableId');
      }
    } catch (error) {
      print('Lỗi khi lấy invoiceId từ tableId: $error');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOrderedDishes(int invoiceId) async {
    final Database db = await database;

    // Lấy danh sách món đã đặt từ bảng invoice_items và join với bảng dishes
    final List<Map<String, dynamic>> orderedDishes = await db.rawQuery('''
    SELECT invoice_items.id, dishes.name, invoice_items.quantity, invoice_items.unit_price
    FROM invoice_items
    INNER JOIN dishes ON invoice_items.dish_id = dishes.id
    WHERE invoice_items.invoice_id = ?
  ''', [invoiceId]);

    return orderedDishes;
  }


  Future<Map<String, dynamic>> getInvoiceDetails(int invoiceId) async {
    final Database db = await database;

    // Lấy chi tiết hóa đơn từ bảng invoices
    final List<Map<String, dynamic>> invoiceDetails = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    if (invoiceDetails.isEmpty) {
      throw Exception('No invoice found for ID $invoiceId');
    }

    return invoiceDetails.first;
  }

  Future<void> deleteOrderedDishes(int invoiceId) async {
    final Database db = await database;
    await db.delete(
      'invoice_items',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
  }

  Future<void> deleteAllData() async {
    Database db = await database;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM invoice_items');
      await txn.rawDelete('DELETE FROM invoices');
    });
  }

  Future<double> getRevenue(String selectedPeriod, DateTime startDate, DateTime endDate) async {
    Database db = await database;
    double revenue = 0.0;

    switch (selectedPeriod) {
      case 'Theo Ngày':
        List<Map> result = await db.rawQuery(
          '''
          SELECT SUM(total_amount) as revenue
          FROM invoices
          WHERE DATE(created_at) = DATE(?)
          ''',
          [DateFormat('yyyy-MM-dd').format(startDate)],
        );
        revenue = result.first['revenue'] ?? 0.0;
        break;
      case 'Theo Nhiều Ngày':
        List<Map> result = await db.rawQuery(
          '''
          SELECT SUM(total_amount) as revenue
          FROM invoices
          WHERE DATE(created_at) BETWEEN DATE(?) AND DATE(?)
          ''',
          [
            DateFormat('yyyy-MM-dd').format(startDate),
            DateFormat('yyyy-MM-dd').format(endDate),
          ],
        );
        revenue = result.first['revenue'] ?? 0.0;
        break;
      case 'Theo Tháng':
        List<Map> result = await db.rawQuery(
          '''
          SELECT SUM(total_amount) as revenue
          FROM invoices
          WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', ?)
          ''',
          [DateFormat('yyyy-MM').format(startDate)],
        );
        revenue = result.first['revenue'] ?? 0.0;
        break;
      case 'Theo Năm':
        List<Map> result = await db.rawQuery(
          '''
          SELECT SUM(total_amount) as revenue
          FROM invoices
          WHERE strftime('%Y', created_at) = strftime('%Y', ?)
          ''',
          [DateFormat('yyyy').format(startDate)],
        );
        revenue = result.first['revenue'] ?? 0.0;
        break;
    }

    return revenue;
  }

  Future<double> getTotalRevenue(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT SUM(total_amount) as total
    FROM invoices
    WHERE created_at BETWEEN ? AND ?
  ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    double totalRevenue = result?.isNotEmpty == true ? (result.first['total'] as double?) ?? 0.0 : 0.0;

    print('getTotalRevenue - startDate: $startDate, endDate: $endDate');
    print(totalRevenue);
    return totalRevenue;
  }

  Future<double> getTotalRevenueForDate(DateTime startDate, DateTime endDate) async {
    // Chuyển định dạng ngày giờ về chuỗi cho việc truy vấn
    String formattedStartDate = startDate.toLocal().toString();
    String formattedEndDate = endDate.toLocal().toString();

    final db = await database;
    final result = await db.rawQuery('''
    SELECT SUM(total_amount) as total
    FROM invoices
    WHERE created_at BETWEEN ? AND ?
  ''', [formattedStartDate, formattedEndDate]);

    double totalRevenue = result?.isNotEmpty == true ? (result.first['total'] as double?) ?? 0.0 : 0.0;
    return totalRevenue;
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  Future<void> deleteInvoice() async {
    Database db = await database;
    await db.delete('invoices');
  }

  Future<void> deleteInvoiceItems() async {
    Database db = await database;
    await db.delete('invoice_items');
  }
}

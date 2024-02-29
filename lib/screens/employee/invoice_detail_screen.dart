import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'package:intl/intl.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final int tableId;

  InvoiceDetailScreen({required this.tableId});

  Future<List<Map<String, dynamic>>> _loadOrderedDishes(int tableId) async {
    try {
      // Lấy invoiceId từ tableId
      int invoiceId = await DatabaseHelper().getInvoiceIdForTable(tableId);

      // Sử dụng invoiceId để lấy danh sách món ăn đã đặt hàng
      List<Map<String, dynamic>> orderedDishes = await DatabaseHelper().getOrderedDishes(invoiceId);

      await DatabaseHelper().deleteOrderedDishes(invoiceId);

      return orderedDishes;
    } catch (error) {
      print('Lỗi khi tải danh sách món ăn đã gọi: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadInvoiceDetails(int tableId) async {
    try {
      // Lấy invoiceId từ tableId
      int invoiceId = await DatabaseHelper().getInvoiceIdForTable(tableId);

      // Sử dụng invoiceId để lấy chi tiết hóa đơn
      Map<String, dynamic> invoiceDetails = await DatabaseHelper().getInvoiceDetails(invoiceId);
      return invoiceDetails;
    } catch (error) {
      print('Lỗi khi tải chi tiết hóa đơn: $error');
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'T1 Restaurant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _loadInvoiceDetails(tableId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Có lỗi xảy ra: ${snapshot.error}');
                  } else {
                    final dynamic createdAt = snapshot.data?['created_at'];
                    final String createdAtString =
                    (createdAt != null && createdAt is String) ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(createdAt)) : 'Không có ngày tạo';

                    return Text(
                      'Ngày tạo: $createdAtString',
                      style: TextStyle(fontSize: 16),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadOrderedDishes(tableId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> orderedDishes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderedDishes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(orderedDishes[index]['name']),
                        subtitle: Text(
                          'Giá: ${NumberFormat.currency(locale: 'vi').format(orderedDishes[index]['unit_price'])}\n'
                              'Số lượng: ${orderedDishes[index]['quantity']}',
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadOrderedDishes(tableId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Có lỗi xảy ra: ${snapshot.error}');
                  } else {
                    double total = 0;
                    List<Map<String, dynamic>> orderedDishes = snapshot.data!;
                    for (var dish in orderedDishes) {
                      total += dish['unit_price'] * dish['quantity'];
                    }
                    return Text(
                      'Tổng cộng: ${NumberFormat.currency(locale: 'vi').format(total)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/payment.png',  // Thay thế đường dẫn hình ảnh bằng đường dẫn của bạn
                    width: 150,  // Thay đổi kích thước hình ảnh theo ý muốn
                    height: 150,
                    fit: BoxFit.cover,  // Chọn cách hình ảnh sẽ được hiển thị trong kích thước được cung cấp
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Thông tin thanh toán',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

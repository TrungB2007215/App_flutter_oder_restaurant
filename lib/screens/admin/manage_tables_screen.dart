import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
class ManageTablesScreen extends StatefulWidget {
  @override
  _ManageTablesScreenState createState() => _ManageTablesScreenState();
}

class _ManageTablesScreenState extends State<ManageTablesScreen> {
  Future<List<Map<String, dynamic>>> _loadTables() async {
    return await DatabaseHelper().getTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý bàn ăn'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_home');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin_home/manage_tables/table_list');
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Icon(Icons.table_chart, size: 25),
                  Text('Thông tin bàn ăn', style: TextStyle(fontSize: 20)),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _loadTables(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else {
                        List<Map<String, dynamic>> sortedTables = List.from(snapshot.data!);
                        sortedTables.sort((a, b) => a['id'].compareTo(b['id'])); // Sắp xếp theo số thứ tự

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 4 cột
                          ),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length > 8 ? 8 : snapshot.data!.length, // Tối đa 4 bàn
                          itemBuilder: (context, index) {
                            bool isTableEmpty = snapshot.data![index]['status'] == 0;
                            return Container(
                              margin: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                color: isTableEmpty ? Colors.green : Colors.red, // Xanh nếu trống, đỏ nếu đã đặt
                              ),
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    sortedTables[index]['name'], // Sử dụng danh sách đã sắp xếp
                                    style: TextStyle(
                                      color: Colors.white, // Màu chữ
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  Text(
                    '...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20), // Khoảng cách giữa các chức năng

          // Chức năng thêm bàn ăn
          ElevatedButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/admin_home/manage_tables/add_table');

              // Sau khi thêm bàn, cập nhật lại danh sách
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Icon(Icons.add, size: 25),
                  Text('Thêm bàn ăn mới', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Chức năng sửa bàn ăn
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin_home/manage_tables/edit_table');
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Icon(Icons.edit, size: 25),
                  Text('Chỉnh sửa các bàn ăn', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Chức năng xóa bàn ăn
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin_home/manage_tables/remove_table');
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Icon(Icons.delete, size: 25),
                  Text('Xóa bàn ăn', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

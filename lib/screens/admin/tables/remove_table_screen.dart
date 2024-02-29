import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class RemoveTableScreen extends StatefulWidget {
  @override
  _RemoveTableScreenState createState() => _RemoveTableScreenState();
}

class _RemoveTableScreenState extends State<RemoveTableScreen> {
  String searchTerm = '';

  Future<void> _deleteAllTables(BuildContext context) async {
    await DatabaseHelper().deleteAllTables();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa tất cả bàn'),
      ),
    );

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RemoveTableScreen(),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String tableName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa bàn $tableName không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper().deleteTable(tableName);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa bàn $tableName'),
                  ),
                );

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemoveTableScreen(),
                  ),
                );
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xóa bàn ăn'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_home/manage_tables');
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Tìm kiếm bàn ăn', prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().getTables(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Map<String, dynamic>> sortedData = List.from(snapshot.data!);
                  sortedData.sort((a, b) => a['id'].compareTo(b['id']));

                  return ListView.builder(
                    itemCount: sortedData.length,
                    itemBuilder: (context, index) {
                      final tableName = sortedData[index]['name'];
                      final tableStatus = sortedData[index]['status'];

                      if (tableName.toLowerCase().contains(searchTerm.toLowerCase())) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(tableName),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _showDeleteConfirmation(context, tableName);
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            tableStatus == 0 ? 'Trống' : 'Đã đặt',
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _deleteAllTables(context);
        },
        child: Icon(Icons.delete_forever),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'edit_table_details_screen.dart'; // Import trang chỉnh sửa bàn cụ thể

class EditTableScreen extends StatefulWidget {
  @override
  _EditTableScreenState createState() => _EditTableScreenState();
}

class _EditTableScreenState extends State<EditTableScreen> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _tables = [];
  List<Map<String, dynamic>> _filteredTables = [];

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    List<Map<String, dynamic>> tables = await DatabaseHelper().getTables();
    setState(() {
      _tables = tables;
      _filteredTables = tables;
    });
  }

  void _filterTables(String query) {
    setState(() {
      _filteredTables = _tables
          .where((table) => table['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa bàn ăn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterTables, // Gọi hàm _filterTables khi người dùng thay đổi nội dung
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTables.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_filteredTables[index]['name']),
                    subtitle: Text(_filteredTables[index]['status'] == 0 ? 'Trống' : 'Đã đặt'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTableDetailsScreen(tableId: _filteredTables[index]['id']),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

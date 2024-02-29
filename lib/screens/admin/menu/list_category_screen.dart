import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class ListCategoryScreen extends StatefulWidget {
  @override
  _ListCategoryScreenState createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  List<Map<String, dynamic>> _categories = [];
  String _searchKeyword = ''; // Thêm biến để lưu từ khóa tìm kiếm

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách danh mục'),
      ),
      body: Column (
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                // Lọc danh sách danh mục dựa trên từ khóa tìm kiếm
                if (_searchKeyword.isNotEmpty &&
                    !_categories[index]['name'].contains(_searchKeyword)) {
                  return Container(); // Trả về container rỗng nếu không tìm thấy kết quả
                }
                return ListTile(
                  title: Text(_categories[index]['name']),
                  onTap: () {
                    // Thực hiện hành động khi người dùng chọn một danh mục
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

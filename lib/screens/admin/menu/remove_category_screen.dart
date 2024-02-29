import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class RemoveCategoryScreen extends StatefulWidget {
  @override
  _RemoveCategoryScreenState createState() => _RemoveCategoryScreenState();
}

class _RemoveCategoryScreenState extends State<RemoveCategoryScreen> {
  String searchTerm = '';

  Future<void> _deleteAllCategories(BuildContext context) async {
    await DatabaseHelper().deleteAllCategories();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa tất cả danh mục'),
      ),
    );

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RemoveCategoryScreen(),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String categoryName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa danh mục $categoryName không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper().deleteCategory(categoryName);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa danh mục $categoryName'),
                  ),
                );

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemoveCategoryScreen(),
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
        title: Text('Xóa danh mục'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_home/manage_menu');
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Tìm kiếm danh mục',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().getCategories(),
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
                      final categoryName = sortedData[index]['name'];

                      if (categoryName.toLowerCase().contains(searchTerm.toLowerCase())) {
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(categoryName),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _showDeleteConfirmation(context, categoryName);
                                },
                              ),
                            ],
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
          await _deleteAllCategories(context);
        },
        child: Icon(Icons.delete_forever),
      ),
    );
  }
}

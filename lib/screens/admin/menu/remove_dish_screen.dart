import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class RemoveDishScreen extends StatefulWidget {
  @override
  _RemoveDishScreenState createState() => _RemoveDishScreenState();
}

class _RemoveDishScreenState extends State<RemoveDishScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _dishes = [];
  List<Map<String, dynamic>> _filteredDishes = [];
  List<String> _categories = ['Tất cả'];
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadDishes();
    _loadCategories();
  }

  Future<void> _loadDishes() async {
    List<Map<String, dynamic>> dishes;

    if (_selectedCategory == 'Tất cả') {
      dishes = await DatabaseHelper().getDishes();
    } else {
      dishes = await DatabaseHelper().getDishesByCategory(_selectedCategory);
    }

    setState(() {
      _dishes = dishes;
      _filterDishes(_searchController.text);
    });
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories.addAll(categories.map((category) => category['name'] as String));
    });
  }

  void _filterDishes(String query) {
    setState(() {
      _filteredDishes = _dishes
          .where((dish) => dish['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _removeDish(int dishId) async {
    await DatabaseHelper().deleteDish(dishId);
    _loadDishes();
  }

  void _removeAllDishes() async {
    await DatabaseHelper().deleteAllDishes();
    _loadDishes();
  }

  Widget _buildImageWidget(String? imagePath) {
    if (imagePath != null) {
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      }
    }
    return Container(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xóa món ăn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterDishes,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                      await _loadDishes();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDishes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Container(
                    width: 56.0, // Adjust the width as needed
                    child: _buildImageWidget(_filteredDishes[index]['imagePath']),
                  ),
                  title: Text(_filteredDishes[index]['name']),
                  subtitle: Text(
                    'Giá: ${NumberFormat.currency(locale: 'vi').format(_filteredDishes[index]['price'])}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa'),
                            content: Text('Bạn có chắc chắn muốn xóa món ăn này?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Hủy'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Xóa'),
                                onPressed: () {
                                  _removeDish(_filteredDishes[index]['id']);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _removeAllDishes();
        },
        child: Icon(Icons.delete_forever),
      ),
    );
  }
}

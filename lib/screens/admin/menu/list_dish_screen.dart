import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dish_details_screen.dart';

class ListDishScreen extends StatefulWidget {
  @override
  _ListDishScreenState createState() => _ListDishScreenState();
}

class _ListDishScreenState extends State<ListDishScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _dishes = [];
  List<Map<String, dynamic>> _filteredDishes = [];
  List<String> _categories = ['Tất cả'];
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCategories();
    await _loadDishes();
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

  Widget buildImageWidget(String? imagePath) {
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
    print(imagePath);
    // Nếu không có ảnh hoặc đường dẫn không tồn tại, hiển thị một container màu xám
    return Container(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách món ăn'),
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
                String? imagePath = _filteredDishes[index]['imagePath'];
                return ListTile(
                  leading: Container(
                    width: 70.0,
                    height: 70.0,
                    child: buildImageWidget(imagePath),
                  ),
                  title: Text(_filteredDishes[index]['name']),
                  subtitle: Text(
                    'Giá: ${NumberFormat.currency(locale: 'vi').format(_filteredDishes[index]['price'])}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DishDetailsScreen(
                          dish: _filteredDishes[index],
                          // Truyền đường dẫn ảnh vào DishDetailsScreen
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

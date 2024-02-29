import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'edit_dish_details_screen.dart';
import 'dart:io';
class EditDishScreen extends StatefulWidget {
  @override
  _EditDishScreenState createState() => _EditDishScreenState();
}

class _EditDishScreenState extends State<EditDishScreen> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredDishes = [];
  List<Map<String, dynamic>> _dishes = [];
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
    return Container(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa món ăn'),
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
            child: _filteredDishes.isNotEmpty
                ? ListView.builder(
              itemCount: _filteredDishes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 70.0,
                      height: 70.0,
                      child: buildImageWidget(_filteredDishes[index]['imagePath']),
                    ),
                    title: Text(_filteredDishes[index]['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditDishDetailsScreen(dishId: _filteredDishes[index]['id']),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text('Không có món ăn phù hợp'),
            ),
          ),
        ],
      ),
    );
  }
}

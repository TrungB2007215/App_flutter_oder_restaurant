import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../screens/admin/menu/dish_details_screen.dart';

class SelectDishScreen extends StatefulWidget {
  final int tableId;

  SelectDishScreen({required this.tableId});

  @override
  _SelectDishScreenState createState() => _SelectDishScreenState();
}

class _SelectDishScreenState extends State<SelectDishScreen> {
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> _dishes = [];
  List<String> _categories = ['Tất cả'];
  String _selectedCategory = 'Tất cả';

  Map<String, int> selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadMenu();
    _loadCategories();
  }

  Future<void> _loadMenu() async {
    menuItems = await DatabaseHelper().getDishes();
    await _loadDishesByCategory(_selectedCategory);
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories.addAll(categories.map((category) => category['name'] as String));
    });
  }

  Future<void> _loadDishesByCategory(String category) async {
    List<Map<String, dynamic>> dishes;

    if (category == 'Tất cả') {
      dishes = await DatabaseHelper().getDishes();
    } else {
      dishes = await DatabaseHelper().getDishesByCategory(category);
    }

    setState(() {
      _dishes = dishes;
    });
  }

  void _filterDishes(String query) {
    setState(() {
      _dishes = menuItems
          .where((dish) => dish['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var dish in _dishes) {
      String dishName = dish['name'];
      int quantity = selectedQuantities[dishName] ?? 0;
      double price = dish['price'];
      total += price * quantity;
    }
    return total;
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
        title: Text('Chọn món ăn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _filterDishes(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm món ăn',
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
                      await _loadDishesByCategory(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dishes.length,
              itemBuilder: (BuildContext context, int index) {
                String? imagePath = _dishes[index]['imagePath'];
                String dishName = _dishes[index]['name'];

                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 70.0,
                        height: 70.0,
                        child: buildImageWidget(imagePath),
                      ),
                      title: Text('$dishName'),
                      subtitle: Text(
                        'Giá: ${NumberFormat.currency(locale: 'vi').format(_dishes[index]['price'])} VND',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (selectedQuantities[dishName] != null &&
                                    selectedQuantities[dishName]! > 0) {
                                  selectedQuantities[dishName] =
                                      selectedQuantities[dishName]! - 1;
                                }
                              });
                            },
                          ),
                          Text(
                            selectedQuantities[dishName]?.toString() ?? '0',
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                selectedQuantities[dishName] =
                                    (selectedQuantities[dishName] ?? 0) + 1;
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DishDetailsScreen(dish: _dishes[index]),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Tổng tiền: ${NumberFormat.currency(locale: 'vi').format(_calculateTotal())} VND',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int tableId = widget.tableId;
                    double total = _calculateTotal();

                    for (var dish in _dishes) {
                      String dishName = dish['name'];
                      int quantity = selectedQuantities[dishName] ?? 0;
                      double price = dish['price'];

                      if (quantity > 0) {
                        List<Map<String, dynamic>> currentInvoiceItems =
                        await DatabaseHelper().getInvoiceItemsForTable(tableId);

                        bool isDishAlreadyInInvoice = false;
                        for (var item in currentInvoiceItems) {
                          if (item['dish_id'] == dish['id']) {
                            isDishAlreadyInInvoice = true;
                            break;
                          }
                        }

                        if (isDishAlreadyInInvoice) {
                          await DatabaseHelper().updateInvoiceItemQuantity(
                              tableId, dish['id'], quantity);
                        } else {
                          await DatabaseHelper().addDishToTable(
                              tableId, dish['id'],
                              total,
                              quantity: quantity);
                        }
                      }
                    }

                    selectedQuantities.clear();
                    Navigator.pop(context, total);

                    // Display success dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Món đã được chọn thành công'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                  child: Text('Chọn'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

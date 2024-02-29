import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

class EditCategoryDetailsScreen extends StatefulWidget {
  final int categoryId;

  EditCategoryDetailsScreen({required this.categoryId});

  @override
  _EditCategoryDetailsScreenState createState() => _EditCategoryDetailsScreenState();
}

class _EditCategoryDetailsScreenState extends State<EditCategoryDetailsScreen> {
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryDetails();
  }

  Future<void> _loadCategoryDetails() async {
    Map<String, dynamic> category = await DatabaseHelper().getCategoryById(widget.categoryId);
    if (category.isNotEmpty) {
      setState(() {
        _nameController.text = category['name'];
      });
    }
  }


  Future<void> _saveCategoryDetails() async {
    String name = _nameController.text;

    if (name.trim().isEmpty) {
      // Display an alert if the category name is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tên danh mục trống'),
            content: Text('Vui lòng nhập tên danh mục.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // End the function if the category name is empty
    }

    // Check if the category name already exists
    bool isDuplicate = await DatabaseHelper().isCategoryNameExists(widget.categoryId, name);
    if (isDuplicate) {
      // Display an alert if the category name already exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tên danh mục trùng lặp'),
            content: Text('Tên danh mục đã tồn tại. Vui lòng chọn tên khác.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // End the function if the category name is a duplicate
    }

    // Update or save the category details
    await DatabaseHelper().updateCategory(widget.categoryId, name);

    // Display a success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa danh mục thành công'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('OK'),
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
        title: Text('Chỉnh sửa thông tin danh mục'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên danh mục'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveCategoryDetails,
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

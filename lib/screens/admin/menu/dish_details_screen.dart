import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'dart:io';

import 'package:intl/intl.dart';
class DishDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> dish;

  DishDetailsScreen({required this.dish});

  @override
  _DishDetailsScreenState createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> {
  late Map<String, dynamic> category;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    int categoryId = widget.dish['category_id'];
    Map<String, dynamic> loadedCategory = await DatabaseHelper().getCategoryById(categoryId);

    setState(() {
      category = loadedCategory;
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

    // Nếu không có ảnh hoặc đường dẫn không tồn tại, hiển thị một container màu xám
    return Container(color: Colors.grey);
  }
  @override
  Widget build(BuildContext context) {
    String? imagePath = widget.dish['imagePath'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết món ăn'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: imagePath != null
                  ? Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              )
                  : Container(color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tên món ăn:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dish['name'],
              style: TextStyle(fontSize: 18.0),
            ),

            SizedBox(height: 8.0),
            Text(
              'Danh mục:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              category != null ? category['name'] : 'Unknown', // Check if category is not null
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Mô tả:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dish['describe'],
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Giá:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              // '${widget.dish['price']} VND'
              '${NumberFormat.currency(locale: 'vi').format(widget.dish['price'])}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

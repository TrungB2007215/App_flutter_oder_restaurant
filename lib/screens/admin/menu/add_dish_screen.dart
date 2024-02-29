import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../database/database_helper.dart';

class AddDishScreen extends StatefulWidget {
  @override
  _AddDishScreenState createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _describeController = TextEditingController();

  String selectedCategory = 'Danh mục món ăn';

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();  File? _image;

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _addDish() async {
    if (_nameController.text.trim().isEmpty) {
      _showAlertDialog('Tên món ăn trống', 'Vui lòng nhập tên món ăn.');
      return;
    }

    double price = double.tryParse(_priceController.text) ?? 0.0;
    if (price <= 0) {
      _showAlertDialog('Giá tiền không hợp lệ', 'Vui lòng nhập giá tiền hợp lệ.');
      return;
    }

    if (_categories.isEmpty) {
      _showAlertDialog('Không có danh mục', 'Vui lòng thêm danh mục trước khi thêm món ăn.');
      return;
    }

    // Kiểm tra xem tên món ăn có trùng không
    String dishName = _nameController.text;
    bool isDishExists = await DatabaseHelper().isDishExists(dishName);
    if (isDishExists) {
      _showAlertDialog('Món ăn đã tồn tại', 'Món ăn "$dishName" đã tồn tại trong danh sách.');
      return;
    }

    int categoryId = _categories.firstWhere((categories) => categories['name'] == selectedCategory)['id'];

    String imagePath = '';
    if (_image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      bool isJpgFormat = true;
      imagePath = isJpgFormat ? '$fileName.jpg' : '$fileName.png';
      // Lưu hình ảnh vào thư mục ứng dụng
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      await _image!.copy('$appDirPath/$imagePath');
      imagePath = '$appDirPath/$imagePath';
    }

    try {
      await DatabaseHelper().insertDish(
        _nameController.text,
        price,
        categoryId,
        imagePath,
        _describeController.text, //Thêm mô tả vào database
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thêm danh mục món thành công'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  Navigator.pop(context); // Trở về màn hình trước đó
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      ); // Thoát khỏi trang thêm
    } catch (error) {
      _showAlertDialog('Lỗi', 'Đã có lỗi xảy ra khi thêm món ăn. Vui lòng thử lại sau.');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String imagePath = '$fileName.jpg';

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      final File newImage = await File(pickedFile.path).copy('$appDirPath/$imagePath');

      setState(() {
        _image = newImage;
      });
    }
  }


  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    List<String> categoryNames = _categories.map((category) => category['name'].toString()).toList();
    if (!categoryNames.contains(selectedCategory)) {
      selectedCategory = categoryNames.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm món ăn'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _getImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(),
                  shape: BoxShape.circle,
                  image: _image != null
                      ? DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(_image!),
                  )
                      : null,
                ),
                child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên món ăn',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên món ăn.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Giá',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _describeController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCategory,
              items: categoryNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addDish();
              },
              child: Text('Thêm món ăn'),
            ),
          ],
        ),
      ),
    );
  }
}

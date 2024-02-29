import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../database/database_helper.dart';

class EditDishDetailsScreen extends StatefulWidget {
  final int dishId;

  EditDishDetailsScreen({required this.dishId});

  @override
  _EditDishDetailsScreenState createState() => _EditDishDetailsScreenState();
}

class _EditDishDetailsScreenState extends State<EditDishDetailsScreen> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _describeController = TextEditingController();
  String selectedCategory = 'Danh mục món ăn';
  File? _image;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadDishDetails();
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadDishDetails() async {
    Map<String, dynamic> dishDetails = await DatabaseHelper().getDishDetails(widget.dishId);

    if (dishDetails.isNotEmpty) {
      setState(() {
        _nameController.text = dishDetails['name'];
        _priceController.text = dishDetails['price'].toString();
        _describeController.text = dishDetails['describe'] ?? '';
        selectedCategory = dishDetails['categoryName'];
        String? imagePath = dishDetails['imagePath'];
        if (imagePath != null && imagePath.isNotEmpty) {
          _image = File(imagePath);
        }
      });
    }
  }

  Future<void> _updateDish() async {
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

    String dishName = _nameController.text;
    bool isDishExists = await DatabaseHelper().isDishExists(dishName, dishId: widget.dishId);
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
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      await _image!.copy('$appDirPath/$imagePath');
      imagePath = '$appDirPath/$imagePath';
    }

    String describe = _describeController.text;

    try {
      await DatabaseHelper().updateDish(
        widget.dishId,
        _nameController.text,
        price,
        categoryId,
        imagePath,
        describe,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cập nhật món ăn thành công'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      _showAlertDialog('Lỗi', 'Đã có lỗi xảy ra khi cập nhật món ăn. Vui lòng thử lại sau.');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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

  Widget buildImageWidget() {
    return GestureDetector(
      onTap: _getImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(),
          shape: BoxShape.circle,
        ),
        child: _image != null
            ? Image.file(
          _image!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        )
            : Icon(Icons.camera_alt, size: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> categoryNames = _categories.map((categories) => categories['name'].toString()).toList();
    if (!categoryNames.contains(selectedCategory)) {
      selectedCategory = categoryNames.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa món ăn'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildImageWidget(),
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
                _updateDish();
              },
              child: Text('Cập nhật món ăn'),
            ),
          ],
        ),
      ),
    );
  }
}

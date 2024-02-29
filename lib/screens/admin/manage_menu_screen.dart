import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
class ManageMenuScreen extends StatefulWidget {
  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  String selectedCategory = 'Danh mục món ăn';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý menu'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_home');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Danh mục món ăn';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: 150, // Độ rộng cố định cho nút
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.category, size: 35, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'Danh mục',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Món ăn';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: 150, // Độ rộng cố định cho nút
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.fastfood, size: 35, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'Món ăn',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategory == 'Danh mục món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/list_category');
                      } else if (selectedCategory == 'Món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/list_dish');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.info, size: 25),
                          Text('$selectedCategory', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedCategory == 'Danh mục món ăn') {
                        await Navigator.pushNamed(context, '/admin_home/manage_menu/add_category');
                        setState(() {});
                      } else if (selectedCategory == 'Món ăn') {
                        await Navigator.pushNamed(context, '/admin_home/manage_menu/add_dish');
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.add, size: 25),
                          Text('Thêm $selectedCategory', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategory == 'Danh mục món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/edit_category');
                      } else if (selectedCategory == 'Món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/edit_dish');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.edit, size: 25),
                          Text('Chỉnh sửa $selectedCategory', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategory == 'Danh mục món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/remove_category');
                      } else if (selectedCategory == 'Món ăn') {
                        Navigator.pushNamed(context, '/admin_home/manage_menu/remove_dish');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.delete, size: 25),
                          Text('Xóa $selectedCategory', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

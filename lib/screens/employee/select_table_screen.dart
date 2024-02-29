import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'select_dish_screen.dart';

class SelectTableScreen extends StatefulWidget {
  @override
  _SelectTableScreenState createState() => _SelectTableScreenState();
}

class _SelectTableScreenState extends State<SelectTableScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn bàn'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getTables(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> sortedTables = List.from(snapshot.data!);
            sortedTables.sort((a, b) => a['id'].compareTo(b['id']));

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: sortedTables.length,
              itemBuilder: (BuildContext context, int index) {
                bool isTableEmpty = sortedTables[index]['status'] == 0;

                return GestureDetector(
                  onTap: () async {
                    if (isTableEmpty) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectDishScreen(tableId: sortedTables[index]['id']),
                        ),
                      );

                      await _databaseHelper.updateTableStatus(sortedTables[index]['id'], 1);

                      setState(() {});
                    }
                  },

                  child: Container(
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: isTableEmpty ? Colors.green : Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        '${sortedTables[index]['name']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

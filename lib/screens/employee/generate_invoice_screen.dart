import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import 'invoice_detail_screen.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  @override
  _GenerateInvoiceScreenState createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  List<Map<String, dynamic>> _tables = [];

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    List<Map<String, dynamic>> tables = await DatabaseHelper().getTables();
    List<Map<String, dynamic>> reservedTables = tables.where((table) => table['status'] == 1).toList();

    setState(() {
      _tables = reservedTables;
    });
  }

  Future<void> _exportInvoice(int tableId) async {
    try {
      // Kiểm tra xem có hóa đơn tồn tại cho bàn không
      bool invoiceExists = await DatabaseHelper().checkInvoiceExists(tableId);

      if (invoiceExists) {
        await DatabaseHelper().exportInvoiceForTable(tableId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xuất hóa đơn thành công!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không tìm thấy hóa đơn cho bàn này.'),
          ),
        );
      }
    } catch (error) {
      print('Lỗi khi xuất hóa đơn: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi xuất hóa đơn. Vui lòng thử lại sau.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xuất hóa đơn'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _tables.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                int tableId = _tables[index]['id'];
                _exportInvoice(tableId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceDetailScreen(tableId: tableId),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_chart,
                      size: 50.0,
                      color: _tables[index]['status'] == 0 ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _tables[index]['name'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        int tableId = _tables[index]['id'];
                        _exportInvoice(tableId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceDetailScreen(tableId: tableId),
                          ),
                        );
                      },
                      child: Text('Xuất hóa đơn'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

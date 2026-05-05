import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_provider.dart';

class ManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("จัดการเมนูอาหาร")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
      body: ListView.builder(
        itemCount: auth.foods.length,

      itemBuilder: (context, i) {
        final food = auth.foods[i];
        return ListTile(
          leading: Image.network(food['image_url'], width: 50, errorBuilder: (c, e, s) => Icon(Icons.fastfood)),
          title: Text(food['name']),
          subtitle: Text("${food['calories']} kcal"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, food),
              ),
              
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final baseUrl = context.read<AppProvider>().baseUrl;
                  await http.delete(Uri.parse('$baseUrl/foods/${food['id']}'));
                  context.read<AppProvider>().fetchFoods();
                },
              ),
            ],
          ),
        );
      },


        
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final name = TextEditingController();
    final desc = TextEditingController();
    final p = TextEditingController();
    final c = TextEditingController();
    final f = TextEditingController();
    final img = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("เพิ่มเมนูใหม่"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: InputDecoration(labelText: "ชื่ออาหาร")),
              TextField(controller: desc, decoration: InputDecoration(labelText: "รายละเอียด")),
              TextField(controller: p, decoration: InputDecoration(labelText: "Protein (g)"), keyboardType: TextInputType.number),
              TextField(controller: c, decoration: InputDecoration(labelText: "Carb (g)"), keyboardType: TextInputType.number),
              TextField(controller: f, decoration: InputDecoration(labelText: "Fat (g)"), keyboardType: TextInputType.number),
              TextField(controller: img, decoration: InputDecoration(labelText: "Image URL")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("ยกเลิก")),
          ElevatedButton(
            onPressed: () async {
              final baseUrl = context.read<AppProvider>().baseUrl;
              await http.post(
                Uri.parse('$baseUrl/foods'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "name": name.text,
                  "description": desc.text,
                  "protein": double.parse(p.text),
                  "carb": double.parse(c.text),
                  "fat": double.parse(f.text),
                  "image_url": img.text,
                }),
              );
              context.read<AppProvider>().fetchFoods();
              Navigator.pop(ctx);
            },
            child: Text("บันทึก"),
          )
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map food) {
    
    final name = TextEditingController(text: food['name']);
    final desc = TextEditingController(text: food['description']);
    final p = TextEditingController(text: food['protein'].toString());
    final c = TextEditingController(text: food['carb'].toString());
    final f = TextEditingController(text: food['fat'].toString());
    final img = TextEditingController(text: food['image_url']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("แก้ไขเมนู: ${food['name']}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: InputDecoration(labelText: "ชื่ออาหาร")),
              TextField(controller: desc, decoration: InputDecoration(labelText: "รายละเอียด")),
              TextField(controller: p, decoration: InputDecoration(labelText: "Protein (g)"), keyboardType: TextInputType.number),
              TextField(controller: c, decoration: InputDecoration(labelText: "Carb (g)"), keyboardType: TextInputType.number),
              TextField(controller: f, decoration: InputDecoration(labelText: "Fat (g)"), keyboardType: TextInputType.number),
              TextField(controller: img, decoration: InputDecoration(labelText: "Image URL")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("ยกเลิก")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              final baseUrl = context.read<AppProvider>().baseUrl;
              
              await http.put(
                Uri.parse('$baseUrl/foods/${food['id']}'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "name": name.text,
                  "description": desc.text,
                  "protein": double.parse(p.text),
                  "carb": double.parse(c.text),
                  "fat": double.parse(f.text),
                  "image_url": img.text,
                }),
              );
              
              context.read<AppProvider>().fetchFoods();
              Navigator.pop(ctx);
            },
            child: Text("อัปเดตข้อมูล"),
          )
        ],
      ),
    );
  }


}
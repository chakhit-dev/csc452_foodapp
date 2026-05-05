import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class FoodDetailScreen extends StatefulWidget {
  final int foodId;
  FoodDetailScreen({required this.foodId});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Map? foodData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final baseUrl = context.read<AppProvider>().baseUrl;
    try {
      final res = await http.get(Uri.parse('$baseUrl/foods/${widget.foodId}'));
      if (res.statusCode == 200) {
        setState(() {
          foodData = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(foodData!['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(foodData!['image_url'], width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodData!['name'], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("${foodData!['calories']} kcal", style: TextStyle(fontSize: 22, color: Colors.orange)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _nutrientBox("Protein", "${foodData!['protein']}g", Colors.blue),
                      _nutrientBox("Carb", "${foodData!['carb']}g", Colors.green),
                      _nutrientBox("Fat", "${foodData!['fat']}g", Colors.red),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("รายละเอียด", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),
                  Text(foodData!['description'] ?? "ไม่มีข้อมูล", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _nutrientBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
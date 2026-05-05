import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppProvider with ChangeNotifier {
  bool _isLogin = false;
  String _role = 'user';
  String _nickname = '';
  List _foods = [];
  
  final String baseUrl = "http://localhost:3000"; 

  bool get isLogin => _isLogin;
  String get role => _role;
  String get nickname => _nickname;
  List get foods => _foods;

  Future<void> fetchFoods() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/foods'));
      if (res.statusCode == 200) {
        _foods = jsonDecode(res.body);
        notifyListeners();
      }
    } catch (e) {
      print("Fetch Foods Error: $e");
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body)['user'];
        _isLogin = true;
        _role = data['role'];
        _nickname = data['nickname'];
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return false;
  }

  void logout() {
    _isLogin = false;
    _role = 'user';
    _nickname = '';
    notifyListeners();
  }




  // --

  List _selectedFoods = [];
  List get selectedFoods => _selectedFoods;

  void toggleSelection(Map food) {
    if (_selectedFoods.contains(food)) {
      _selectedFoods.remove(food);
    } else {
      _selectedFoods.add(food);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedFoods.clear();
    notifyListeners();
  }

  double get totalSelectedCalories {
    double total = 0;
    for (var food in _selectedFoods) {
      total += double.parse(food['calories'].toString());
    }
    return total;
  }

}
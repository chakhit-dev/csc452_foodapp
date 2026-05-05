import 'package:flutter/material.dart';
import 'package:food_app/detail_screen.dart';
import 'package:food_app/manage_screen.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isSelectMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppProvider>().fetchFoods());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Food Calorie Counter"),
        backgroundColor: Colors.green,
        actions: [
  
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  isSelectMode = !isSelectMode;

                  if (!isSelectMode) auth.clearSelection();
                });
              },
              child: Text(
                isSelectMode ? "ยกเลิก" : "เลือก",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
      drawer: _buildDrawer(context, auth),
      body: auth.foods.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: auth.foods.length,
              itemBuilder: (context, i) {
                final food = auth.foods[i];
  
                final isSelected = auth.selectedFoods.contains(food);

                return Card(

                  shape: isSelected
                      ? RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (isSelectMode) {

                        auth.toggleSelection(food);
                      } else {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailScreen(foodId: food['id']),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                food['image_url'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(food['name'],
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${food['calories']} kcal",
                                      style: TextStyle(color: Colors.orange)),
                                ],
                              ),
                            )
                          ],
                        ),

                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 12,
                              child: Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: isSelectMode && auth.selectedFoods.isNotEmpty
          ? Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("เลือกแล้ว ${auth.selectedFoods.length} รายการ",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      Text(
                        "รวม: ${auth.totalSelectedCalories.toStringAsFixed(0)} kcal",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700]),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => auth.clearSelection(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("ล้างทั้งหมด", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildDrawer(BuildContext context, AppProvider auth) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            accountName: Text(auth.isLogin ? auth.nickname : "Guest"),
            accountEmail: Text(auth.isLogin ? "Role: ${auth.role}" : "Please Login"),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.green)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("หน้าแรก"),
            onTap: () => Navigator.pop(context),
          ),
          // ปุ่ม "คำนวณแคลอรี่" ใน Drawer จะทำงานเหมือนปุ่มขวาบน

          if (!auth.isLogin)
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
              onTap: () {
                Navigator.pop(context);
                _showLoginModal(context);
              },
            ),
          if (auth.isLogin && auth.role == 'admin')
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text("จัดการเมนูอาหาร"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageScreen()),
                );
              },
            ),
          if (auth.isLogin)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                auth.logout();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    final userController = TextEditingController();
    final passController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: userController, decoration: InputDecoration(labelText: "Username")),
            TextField(
                controller: passController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success =
                    await context.read<AppProvider>().login(userController.text, passController.text);
                if (success)
                  Navigator.pop(context);
                else
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Login Failed!")));
              },
              child: Text("Login"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
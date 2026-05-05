const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// --- 1. เชื่อมต่อ MySQL ---
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "121407",
  database: "food_app"
});

db.connect(err => {
    if (err) {
        console.error('Database connection failed: ' + err.stack);
        return;
    }
    console.log('MySQL Connected...');
});

// --- 2. Auth Endpoints ---

// Register
app.post('/register', (req, res) => {
    const { username, password, nickname } = req.body;
    db.query('INSERT INTO users (username, password, nickname) VALUES (?, ?, ?)', 
    [username, password, nickname], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'ลงทะเบียนสำเร็จ' });
    });
});

// Login
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    db.query('SELECT * FROM users WHERE username = ? AND password = ?', 
    [username, password], (err, results) => {
        if (results.length > 0) {
            res.json({ status: 'ok', user: results[0] });
        } else {
            res.status(401).json({ message: 'Username หรือ Password ผิด' });
        }
    });
});

// --- 3. Food CRUD Endpoints ---

// ดึงรายการอาหารทั้งหมด (สำหรับหน้า Home)
app.get('/foods', (req, res) => {
    db.query('SELECT * FROM foods', (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// ดึงรายละเอียดอาหารรายชิ้น (สำหรับหน้า Description)
app.get('/foods/:id', (req, res) => {
    db.query('SELECT * FROM foods WHERE id = ?', [req.params.id], (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length > 0) res.json(results[0]);
        else res.status(404).json({ message: 'ไม่พบเมนูนี้' });
    });
});

// เพิ่มเมนูอาหาร (Admin Only - มีการคำนวณแคลอรี่ที่นี่)
app.post('/foods', (req, res) => {
    const { name, description, protein, carb, fat, image_url } = req.body;
    
    // สูตรคำนวณ (4-4-9)
    const totalCal = (protein * 4) + (carb * 4) + (fat * 9);

    const sql = "INSERT INTO foods (name, description, protein, carb, fat, calories, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
    db.query(sql, [name, description, protein, carb, fat, totalCal, image_url], (err) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'เพิ่มเมนูสำเร็จ', calories: totalCal });
    });
});

// ลบเมนูอาหาร
app.delete('/foods/:id', (req, res) => {
    db.query('DELETE FROM foods WHERE id = ?', [req.params.id], (err) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'ลบสำเร็จ' });
    });
});

// 7. แก้ไขข้อมูลอาหาร (Update)
app.put('/foods/:id', (req, res) => {
    const { name, description, protein, carb, fat, image_url } = req.body;
    const foodId = req.params.id;

    // คำนวณแคลอรี่ใหม่จากค่าที่แก้ไขมา
    const totalCal = (parseFloat(protein) * 4) + (parseFloat(carb) * 4) + (parseFloat(fat) * 9);

    const sql = `
        UPDATE foods 
        SET name = ?, description = ?, protein = ?, carb = ?, fat = ?, calories = ?, image_url = ? 
        WHERE id = ?
    `;

    db.query(sql, [name, description, protein, carb, fat, totalCal, image_url, foodId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: "อัปเดตข้อมูลสำเร็จ", calculatedCalories: totalCal });
    });
});

// Start Server
app.listen(3000, () => {
    console.log('Backend running on http://localhost:3000');
});
# Food Calorie Counter & Management App

A full-stack mobile application built with **Flutter** and **Node.js (Express + MySQL)** for tracking food calories, managing nutritional information, and calculating total calories consumed.

---

## Features

- **User Authentication**: Register and login system with role-based access control (`user` and `admin`).
- **Food Catalog & Details**:
  - Grid view displaying food items with image, name, and total calories.
  - Detailed view showing macronutrient breakdown (Protein, Carbohydrates, Fat) and descriptions.
- **Calorie Calculator**: Interactive multi-select mode to calculate the total calorie count of selected food items.
- **Admin Management (CRUD)**:
  - Add new food items with automatic calorie calculation using the Atwater system formula:
    $$\text{Calories} = (\text{Protein} \times 4) + (\text{Carbohydrate} \times 4) + (\text{Fat} \times 9)$$
  - Edit existing food details and nutritional values.
  - Delete food items from the catalog.

---

## Tech Stack

### Frontend
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [http](https://pub.dev/packages/http)

### Backend
- **Runtime**: [Node.js](https://nodejs.org/)
- **Framework**: [Express.js](https://expressjs.com/)
- **Database**: [MySQL](https://www.mysql.com/) (`mysql2`)
- **Middleware**: `cors`, `body-parser`

---

## Project Structure

```text
├── backend/
│   ├── server.js              # Express server and database queries
│   └── package.json
└── frontend/lib/
    ├── main.dart              # App entry point and Provider setup
    ├── app_provider.dart      # Global state (Auth, Selection, Foods)
    ├── home_screen.dart       # Main grid view & multi-select calorie counter
    ├── detail_screen.dart     # Detailed food & macronutrient screen
    └── manage_screen.dart     # Admin CRUD dashboard
```

---

## Database Setup (MySQL)

Create a database named `food_app` and set up the following tables:

```sql
CREATE DATABASE food_app;
USE food_app;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(100),
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Foods Table
CREATE TABLE foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    protein DECIMAL(6,2) DEFAULT 0,
    carb DECIMAL(6,2) DEFAULT 0,
    fat DECIMAL(6,2) DEFAULT 0,
    calories DECIMAL(8,2) DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Getting Started

### 1. Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install express mysql2 cors body-parser
   ```
3. Update the MySQL credentials in `server.js`:
   ```javascript
   const db = mysql.createConnection({
     host: "localhost",
     user: "root",
     password: "YOUR_MYSQL_PASSWORD",
     database: "food_app"
   });
   ```
4. Start the server:
   ```bash
   node server.js
   ```
   The backend will be running at `http://localhost:3000`.

---

### 2. Frontend Setup (Flutter)

1. Open `frontend/lib/app_provider.dart` and update `baseUrl`:
   - **iOS Simulator / Web**: `http://localhost:3000`
   - **Android Emulator**: `http://10.0.2.2:3000`
   - **Physical Device**: `http://<YOUR_LOCAL_IP>:3000`

2. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/register` | Register a new user |
| `POST` | `/login` | User authentication |
| `GET` | `/foods` | Fetch all food items |
| `GET` | `/foods/:id` | Fetch details for a specific food item |
| `POST` | `/foods` | Create a new food item (Auto-calculates calories) |
| `PUT` | `/foods/:id` | Update food item details & recalculate calories |
| `DELETE` | `/foods/:id` | Delete a food item by ID |

---

## License

This project is licensed under the MIT License - feel free to modify and use it for your own projects.

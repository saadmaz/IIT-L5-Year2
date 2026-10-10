require("dotenv").config();
const express = require("express");
const mysql = require("mysql");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

// Database Connection
const db = mysql.createConnection({
    host: "localhost",
    user: "root", // Default MySQL user
    password: "", // Leave empty if no password is set
    database: "node", // Change this to your actual database name
});

db.connect(err => {
    if (err) {
        console.error("Database connection failed:", err);
        return;
    }
    console.log("Connected to MySQL database");
});

app.get("/api/strains", (req, res) => {
    const query = "SELECT * FROM muscle_strains";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching strains:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        res.json(results);
    });
});

app.get("/api/rehabilitation-exercises", (req, res) => {
    const query = "SELECT * FROM rehabilitation_exercises";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching rehabilitation exercises:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        res.json(results);
    });
});

app.get("/api/sports-injury-prevention", (req, res) => {
    const query = "SELECT * FROM sports_injury_prevention";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching sports injury prevention data:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        res.json(results);
    });
});



app.get("/api/stretching-techniques", (req, res) => {
    const query = "SELECT * FROM stretching_techniques";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching stretching techniques:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        res.json(results);
    });
});

app.get("/api/custom-remedies", (req, res) => {
  const sql = "SELECT * FROM custom_remedies";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

app.get("/api/muscle-groups/:remedyId", (req, res) => {
  const sql = "SELECT * FROM muscle_groups WHERE remedy_id = ?";
  db.query(sql, [req.params.remedyId], (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

app.get("/api/remedy-details/:muscleGroupId", (req, res) => {
  const sql = "SELECT * FROM remedy_details WHERE muscle_group_id = ?";
  db.query(sql, [req.params.muscleGroupId], (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results[0]); // assuming one detail per group
  });
});

app.get("/api/workouts", (req, res) => {
    db.query("SELECT * FROM rehabilitation_workouts", (err, results) => {
        if (err) {
            console.error("Error fetching workouts:", err);
            return res.status(500).json({ error: "Internal server error" });
        }
        res.json(results);
    });
});

app.get("/api/strength-workouts", (req, res) => {
    db.query("SELECT * FROM strength_workouts", (err, results) => {
        if (err) {
            console.error("Error fetching strength workouts:", err);
            return res.status(500).json({ error: "Internal server error" });
        }
        res.json(results);
    });
});

app.get("/api/flexibility-workouts", (req, res) => {
    db.query("SELECT * FROM flexibility_workouts", (err, results) => {
        if (err) {
            console.error("Error fetching flexibility workouts:", err);
            return res.status(500).json({ error: "Internal server error" });
        }
        res.json(results);
    });
});

app.get("/api/balance-workouts", (req, res) => {
    db.query("SELECT * FROM balance_workouts", (err, results) => {
        if (err) {
            console.error("Error fetching balance workouts:", err);
            return res.status(500).json({ error: "Internal server error" });
        }
        res.json(results);
    });
});

app.get("/api/cardio-workouts", (req, res) => {
    db.query("SELECT * FROM cardio_workouts", (err, results) => {
        if (err) {
            console.error("Error fetching cardio workouts:", err);
            return res.status(500).json({ error: "Internal server error" });
        }
        res.json(results);
    });
});


// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

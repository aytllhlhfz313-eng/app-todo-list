import express from "express";
import cors from "cors";
import { pool } from "./db/index";

const app = express();
const PORT = 8000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "Backend Todo List berjalan!" });
});

app.get("/api/tasks", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM tasks");
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal mengambil data tugas" });
  }
});

app.post("/api/tasks", async (req, res) => {
  try {
    const { title, description, status } = req.body;

    await pool.query(
      "INSERT INTO tasks (title, description, status) VALUES (?, ?, ?)",
      [title, description, status || "pending"]
    );

    res.status(201).json({
      message: "Tugas berhasil ditambahkan",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menambahkan tugas" });
  }
});

app.put("/api/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, status } = req.body;

    await pool.query(
      "UPDATE tasks SET title = ?, description = ?, status = ? WHERE id = ?",
      [title, description, status, id]
    );

    res.json({
      message: "Tugas berhasil diperbarui",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal memperbarui tugas" });
  }
});

app.delete("/api/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query(
      "DELETE FROM tasks WHERE id = ?",
      [id]
    );

    res.json({
      message: "Tugas berhasil dihapus",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menghapus tugas" });
  }
});

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
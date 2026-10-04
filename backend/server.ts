import express from "express";
import cors from "cors";
import { pool } from "./db/index";

const app = express();
const PORT = 8000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    message: "Backend Todo List berjalan!",
  });
});

app.post("/api/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        message: "Nama, email, dan password wajib diisi",
      });
    }

    // Cek apakah email sudah terdaftar
    const [existingUsers]: any = await pool.query(
      "SELECT id FROM users WHERE email = ?",
      [email]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({
        message: "Email sudah terdaftar",
      });
    }

    // Simpan user
    const [result]: any = await pool.query(
      "INSERT INTO users (name, email, password) VALUES (?, ?, ?)",
      [name, email, password]
    );

    res.status(201).json({
      message: "Registrasi berhasil",
      user: {
        id: result.insertId,
        name,
        email,
      },
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal melakukan registrasi",
    });
  }
});

app.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: "Email dan password wajib diisi",
      });
    }

    const [users]: any = await pool.query(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({
        message: "Email atau password salah",
      });
    }

    const user = users[0];

    if (password !== user.password) {
      return res.status(401).json({
        message: "Email atau password salah",
      });
    }

    res.json({
      message: "Login berhasil",
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal melakukan login",
    });
  }
});

app.get("/api/tasks", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        tasks.*,
        projects.name AS project_name,
        users.name AS user_name
      FROM tasks
      LEFT JOIN projects
        ON tasks.project_id = projects.id
      LEFT JOIN users
        ON tasks.user_id = users.id
      ORDER BY tasks.created_at DESC
    `);

    res.json(rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal mengambil data tugas",
    });
  }
});

app.get("/api/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [rows]: any = await pool.query(
      "SELECT * FROM tasks WHERE id = ?",
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Tugas tidak ditemukan",
      });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal mengambil tugas",
    });
  }
});

app.post("/api/tasks", async (req, res) => {
  try {
    const {
      user_id,
      project_id,
      title,
      description,
      status,
      priority,
      due_date,
      assignee,
    } = req.body;

    if (!title || !title.trim()) {
      return res.status(400).json({
        message: "Title wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      `
      INSERT INTO tasks
      (user_id, project_id, title, description, status, priority, due_date, assignee)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        user_id || null,
        project_id || null,
        title,
        description || null,
        status || "pending",
        priority || "medium",
        due_date || null,
        assignee || null,
      ]
    );

    res.status(201).json({
      message: "Tugas berhasil ditambahkan",
      id: result.insertId,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menambahkan tugas",
    });
  }
});

app.put("/api/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const {
      user_id,
      project_id,
      title,
      description,
      status,
      priority,
      due_date,
      assignee,
    } = req.body;

    if (!title || !title.trim()) {
      return res.status(400).json({
        message: "Title wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      `
      UPDATE tasks
      SET
        user_id = ?,
        project_id = ?,
        title = ?,
        description = ?,
        status = ?,
        priority = ?,
        due_date = ?,
        assignee = ?
      WHERE id = ?
      `,
      [
        user_id || null,
        project_id || null,
        title,
        description || null,
        status || "pending",
        priority || "medium",
        due_date || null,
        assignee || null,
        id,
      ]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Tugas tidak ditemukan",
      });
    }

    res.json({
      message: "Tugas berhasil diperbarui",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal memperbarui tugas",
    });
  }
});

app.delete("/api/tasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result]: any = await pool.query(
      "DELETE FROM tasks WHERE id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Tugas tidak ditemukan",
      });
    }

    res.json({
      message: "Tugas berhasil dihapus",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menghapus tugas",
    });
  }
});

app.get("/api/projects", async (req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT * FROM projects ORDER BY created_at DESC"
    );

    res.json(rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal mengambil project",
    });
  }
});

app.post("/api/projects", async (req, res) => {
  try {
    const { name, description } = req.body;

    if (!name || !name.trim()) {
      return res.status(400).json({
        message: "Nama project wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      "INSERT INTO projects (name, description) VALUES (?, ?)",
      [name, description || null]
    );

    res.status(201).json({
      message: "Project berhasil ditambahkan",
      id: result.insertId,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menambahkan project",
    });
  }
});

app.put("/api/projects/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;

    if (!name || !name.trim()) {
      return res.status(400).json({
        message: "Nama project wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      "UPDATE projects SET name = ?, description = ? WHERE id = ?",
      [name, description || null, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Project tidak ditemukan",
      });
    }

    res.json({
      message: "Project berhasil diperbarui",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal memperbarui project",
    });
  }
});

app.delete("/api/projects/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result]: any = await pool.query(
      "DELETE FROM projects WHERE id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Project tidak ditemukan",
      });
    }

    res.json({
      message: "Project berhasil dihapus",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menghapus project",
    });
  }
});

app.get("/api/tasks/:taskId/subtasks", async (req, res) => {
  try {
    const { taskId } = req.params;

    const [rows] = await pool.query(
      "SELECT * FROM subtasks WHERE task_id = ? ORDER BY id ASC",
      [taskId]
    );

    res.json(rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal mengambil subtask",
    });
  }
});

app.post("/api/tasks/:taskId/subtasks", async (req, res) => {
  try {
    const { taskId } = req.params;
    const { title } = req.body;

    if (!title || !title.trim()) {
      return res.status(400).json({
        message: "Title subtask wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      "INSERT INTO subtasks (task_id, title) VALUES (?, ?)",
      [taskId, title]
    );

    res.status(201).json({
      message: "Subtask berhasil ditambahkan",
      id: result.insertId,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menambahkan subtask",
    });
  }
});

app.put("/api/subtasks/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { title, is_completed } = req.body;

    if (!title || !title.trim()) {
      return res.status(400).json({
        message: "Title subtask wajib diisi",
      });
    }

    const [result]: any = await pool.query(
      `
      UPDATE subtasks
      SET title = ?, is_completed = ?
      WHERE id = ?
      `,
      [title, is_completed ?? false, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Subtask tidak ditemukan",
      });
    }

    res.json({
      message: "Subtask berhasil diperbarui",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal memperbarui subtask",
    });
  }
});

app.delete("/api/subtasks/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result]: any = await pool.query(
      "DELETE FROM subtasks WHERE id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Subtask tidak ditemukan",
      });
    }

    res.json({
      message: "Subtask berhasil dihapus",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menghapus subtask",
    });
  }
});

app.get("/api/notifications", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `
      SELECT
        notifications.*,
        users.name AS user_name
      FROM notifications
      LEFT JOIN users
        ON notifications.user_id = users.id
      ORDER BY notifications.created_at DESC
      `
    );

    res.json(rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal mengambil notifikasi",
    });
  }
});

app.put("/api/notifications/:id/read", async (req, res) => {
  try {
    const { id } = req.params;

    const [result]: any = await pool.query(
      "UPDATE notifications SET is_read = TRUE WHERE id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Notifikasi tidak ditemukan",
      });
    }

    res.json({
      message: "Notifikasi ditandai sudah dibaca",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal memperbarui notifikasi",
    });
  }
});

app.delete("/api/notifications/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result]: any = await pool.query(
      "DELETE FROM notifications WHERE id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Notifikasi tidak ditemukan",
      });
    }

    res.json({
      message: "Notifikasi berhasil dihapus",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Gagal menghapus notifikasi",
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
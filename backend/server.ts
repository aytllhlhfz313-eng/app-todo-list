import express, { Request, Response } from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

interface Task {
  id: number;
  title: string;
  description: string;
  status: string; // 'pending' | 'completed'
  project: string;
  priority: string; // 'Low' | 'Medium' | 'High'
}

let tasks: Task[] = [
  {
    id: 1,
    title: 'spreadsheet bulanan',
    description: 'di excel harus selesai hari ini',
    status: 'pending',
    project: 'Northstar Launch',
    priority: 'Medium',
  },
];

let nextId = 2;

// GET: Ambil semua task
app.get('/api/tasks', (req: Request, res: Response) => {
  res.json(tasks);
});

// POST: Tambah task baru
app.post('/api/tasks', (req: Request, res: Response) => {
  const { title, description, status, project, priority } = req.body;

  const newTask: Task = {
    id: nextId++,
    title: title || 'Untitled Task',
    description: description || '',
    status: status || 'pending',
    // PASTIKAN project tidak memaksa 'Northstar Launch' jika ada request project dari client
    project: project && project.trim() !== '' ? project : 'Inbox',
    priority: priority || 'Medium',
  };

  tasks.push(newTask);
  res.status(201).json(newTask);
});

// PUT: Update task
app.put('/api/tasks/:id', (req: Request, res: Response) => {
  const id = parseInt(String(req.params.id));
  const taskIndex = tasks.findIndex((t) => t.id === id);

  if (taskIndex === -1) {
    return res.status(404).json({ message: 'Task not found' });
  }

  const { title, description, status, project, priority } = req.body;

  tasks[taskIndex] = {
    ...tasks[taskIndex],
    title: title !== undefined ? title : tasks[taskIndex].title,
    description: description !== undefined ? description : tasks[taskIndex].description,
    status: status !== undefined ? status : tasks[taskIndex].status,
    project: project !== undefined && project.trim() !== '' ? project : tasks[taskIndex].project,
    priority: priority !== undefined ? priority : tasks[taskIndex].priority,
  };

  res.json(tasks[taskIndex]);
});

// DELETE: Hapus task
app.delete('/api/tasks/:id', (req: Request, res: Response) => {
  const id = parseInt(String(req.params.id));
  tasks = tasks.filter((t) => t.id !== id);
  res.json({ message: 'Task deleted successfully' });
});

const PORT = 8000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
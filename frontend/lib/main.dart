import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const TadaApp());
}

class TadaApp extends StatelessWidget {
  const TadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tada! - Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE05638),
          primary: const Color(0xFFE05638),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

// ==========================================
// 1. AUTH SCREEN
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _submitAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi email dan password')),
      );
      return;
    }

    final userName = isLogin ? (email.split('@').first) : _nameController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboardScreen(userName: userName, userEmail: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Color(0xFFE05638), size: 32),
                  SizedBox(width: 8),
                  Text('Tada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isLogin ? 'Welcome back! Please sign in.' : 'Create an account to get started.',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              if (!isLogin) ...[
                const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Alex Lim',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'alex@example.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE05638),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _submitAuth,
                  child: Text(isLogin ? 'Sign In' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In",
                    style: const TextStyle(color: Color(0xFFE05638), fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. PROFILE SCREEN
// ==========================================
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 450,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFE05638),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(userEmail, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Account Role'),
                trailing: const Text('Developer / Admin', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Log Out'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. MAIN DASHBOARD SCREEN
// ==========================================
class MainDashboardScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MainDashboardScreen({super.key, required this.userName, required this.userEmail});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final String baseUrl = 'http://localhost:8000/api/tasks';

  List tasks = [];
  List<String> projects = ['Northstar Launch', 'Personal Admin'];
  bool isLoading = true;
  String currentFilter = 'Today';
  bool showNotifications = false;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          tasks = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> addTask(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'status': 'pending',
        }),
      );
      if (response.statusCode == 201) fetchTasks();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateTask(int id, String title, String description, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'status': status,
        }),
      );
      if (response.statusCode == 200) fetchTasks();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> toggleTaskStatus(Map item) async {
    final int id = item['id'];
    final bool isDone = item['status'] == 'completed';
    final String newStatus = isDone ? 'pending' : 'completed';

    updateTask(id, item['title'], item['description'] ?? '', newStatus);
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) fetchTasks();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  List get filteredTasks {
    if (currentFilter == 'Completed') {
      return tasks.where((t) => t['status'] == 'completed').toList();
    } else if (currentFilter == 'Today' || currentFilter == 'Inbox') {
      return tasks.where((t) => t['status'] != 'completed').toList();
    }
    return tasks;
  }

  // ==========================================
  // DESAIN BARU: MODAL CREATE PROJECT
  // ==========================================
  void _showCreateProjectModal() {
    final projController = TextEditingController();
    IconData selectedIcon = Icons.rocket_launch;
    Color selectedColor = const Color(0xFF2DD4BF); // Teal default

    final List<IconData> iconOptions = [
      Icons.rocket_launch,
      Icons.star_border,
      Icons.favorite_border,
      Icons.cloud_outlined,
      Icons.menu_book,
      Icons.flash_on_outlined,
    ];

    final List<Color> colorOptions = [
      const Color(0xFFF87171), // Red
      const Color(0xFFFBBF24), // Amber
      const Color(0xFF2DD4BF), // Teal
      const Color(0xFF60A5FA), // Blue
      const Color(0xFFA78BFA), // Purple
      const Color(0xFF4ADE80), // Green
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 440,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Create a project', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Text('Group your tasks related to a specific place or topic.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 18),

                  const Text('Project Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: projController,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      hintText: 'e.g. Website Refresh',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Choose an icon', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: iconOptions.map((icon) {
                      bool isSelected = selectedIcon == icon;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedIcon = icon),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? selectedColor.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? selectedColor : const Color(0xFFE5E7EB), width: 1.5),
                          ),
                          child: Icon(icon, size: 20, color: isSelected ? selectedColor : Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text('Color Theme', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: colorOptions.map((color) {
                      bool isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
                          ),
                          child: CircleAvatar(radius: 12, backgroundColor: color),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // PREVIEW CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selectedColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(8)),
                          child: Icon(selectedIcon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              projController.text.isEmpty ? 'New Project' : projController.text,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const Text('Has 0 open tasks', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE05638),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          if (projController.text.isNotEmpty) {
                            setState(() => projects.add(projController.text));
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('+ Create Project'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // DESAIN BARU: MODAL ADD TASK
  // ==========================================
  void _showAddTaskModal() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final subtaskController = TextEditingController();
    
    String selectedProject = projects.isNotEmpty ? projects.first : 'Northstar Launch';
    String selectedPriority = 'Medium';
    DateTime selectedDate = DateTime(2026, 10, 5);
    String selectedAssignee = widget.userName;
    bool enableReminder = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add a new task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Text('Create a task that helps keep your team progress move.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 18),

                    const Text('Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'What needs to be done?',
                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add context, notes, or a helpful list...',
                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // DROPDOWN GRID (Project & Priority)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Project', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedProject,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.folder_outlined, size: 18, color: Colors.grey),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: projects.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (v) => setModalState(() => selectedProject = v!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedPriority,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.flag_outlined, size: 18, color: Colors.grey),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: ['Low', 'Medium', 'High']
                                    .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setModalState(() => selectedPriority = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // DROPDOWN GRID (Due Date & Assignee)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Due Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) setModalState(() => selectedDate = picked);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}', style: const TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Assignee', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedAssignee,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: [widget.userName, 'Alex Lim', 'Sarah C.']
                                    .map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setModalState(() => selectedAssignee = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const Text('Subtasks', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: subtaskController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add_task, size: 18, color: Colors.grey),
                        hintText: 'Add a subtask',
                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SWITCH REMINDER & FILE ATTACHMENT
                    Row(
                      children: [
                        Switch(
                          value: enableReminder,
                          activeColor: const Color(0xFFE05638),
                          onChanged: (v) => setModalState(() => enableReminder = v),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('15 minutes before', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file, size: 16, color: Colors.black87),
                          label: const Text('File Attachment', style: TextStyle(color: Colors.black87, fontSize: 12)),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE05638),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              addTask(titleController.text, descController.text);
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Save Task'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteProject(String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "$projectName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                projects.remove(projectName);
                if (currentFilter == projectName) currentFilter = 'Today';
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = tasks.length;
    int completedCount = tasks.where((t) => t['status'] == 'completed').length;
    int pendingCount = totalCount - completedCount;

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // SIDEBAR
              Container(
                width: 240,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Color(0xFFE05638), size: 28),
                        SizedBox(width: 8),
                        Text('Tada!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSidebarItem(Icons.today, 'Today', count: pendingCount),
                    _buildSidebarItem(Icons.inbox, 'Inbox', count: totalCount),
                    _buildSidebarItem(Icons.calendar_month, 'Upcoming', count: 12),
                    _buildSidebarItem(Icons.task_alt, 'Completed', count: completedCount),
                    const SizedBox(height: 20),
                    const Text('PROJECTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    ...projects.map((p) => _buildProjectItem(p)).toList(),
                    TextButton.icon(
                      onPressed: _showCreateProjectModal,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create Project'),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tiny steps, big wins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('Do one small step right now.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE5E7EB)),

              // MAIN CONTENT
              Expanded(
                child: Column(
                  children: [
                    // TOP BAR
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tasks, projects, or people...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () => setState(() => showNotifications = !showNotifications),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    userName: widget.userName,
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFE05638),
                              radius: 16,
                              child: Text(
                                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BODY CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Good morning, ${widget.userName}! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('Viewing category: $currentFilter', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE05638),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: _showAddTaskModal,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Task'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // METRIC CARDS
                            Row(
                              children: [
                                _buildMetricCard('Today', '$pendingCount', 'Pending'),
                                _buildMetricCard('In Progress', '$pendingCount', 'Active'),
                                _buildMetricCard('Upcoming', '12', 'Due soon'),
                                _buildMetricCard('Completed', '$completedCount', 'Done'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // TASK LIST TABLE
                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("$currentFilter tasks", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const Icon(Icons.filter_list, size: 20, color: Colors.grey),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  isLoading
                                      ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
                                      : filteredTasks.isEmpty
                                          ? _buildEmptyState()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: filteredTasks.length,
                                              itemBuilder: (context, index) {
                                                final item = filteredTasks[index];
                                                final bool isDone = item['status'] == 'completed';

                                                return Container(
                                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))),
                                                  child: ListTile(
                                                    leading: Checkbox(
                                                      value: isDone,
                                                      activeColor: const Color(0xFFE05638),
                                                      onChanged: (_) => toggleTaskStatus(item),
                                                    ),
                                                    title: Text(
                                                      item['title'] ?? '',
                                                      style: TextStyle(
                                                        decoration: isDone ? TextDecoration.lineThrough : null,
                                                        color: isDone ? Colors.grey : Colors.black87,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    subtitle: item['description'] != null && item['description'].toString().isNotEmpty
                                                        ? Text(item['description'], style: const TextStyle(fontSize: 12))
                                                        : null,
                                                    trailing: IconButton(
                                                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                                      onPressed: () => deleteTask(item['id']),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          if (showNotifications)
            Positioned(
              top: 65,
              right: 60,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 12),
                    Text('• New modals added successfully!', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {int? count}) {
    bool isActive = currentFilter == title;
    return InkWell(
      onTap: () => setState(() => currentFilter = title),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFEE2E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? const Color(0xFFE05638) : Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFFE05638) : Colors.black87,
                ),
              ),
            ),
            if (count != null) Text('$count', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(String title) {
    bool isActive = currentFilter == title;
    return InkWell(
      onTap: () => setState(() => currentFilter = title),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFEE2E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.folder, size: 18, color: isActive ? const Color(0xFFE05638) : Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFFE05638) : Colors.black87,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 14, color: Colors.grey),
              onPressed: () => _deleteProject(title),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String count, String subtitle) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, size: 50, color: Color(0xFFE05638)),
            const SizedBox(height: 12),
            const Text('No tasks found here', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Create a task or change your filter category.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
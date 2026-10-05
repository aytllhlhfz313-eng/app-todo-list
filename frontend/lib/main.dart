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
          seedColor: const Color(0xFFE05638), // Warna oranye khas Tada!
          primary: const Color(0xFFE05638),
        ),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final String baseUrl = 'http://localhost:8000/api/tasks';

  List tasks = [];
  Set<int> selectedTaskIds = {};
  bool isLoading = true;
  String currentFilter = 'Today'; // Menu aktif di Sidebar
  bool showNotifications = false;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  // 1. HTTP GET - Ambil Data
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
      _showSnackBar('Gagal terhubung ke server backend');
    }
  }

  // 2. HTTP POST - Tambah Tugas Baru
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

  // 3. HTTP PUT - Toggle Status
  Future<void> toggleTaskStatus(Map item) async {
    final int id = item['id'];
    final bool isDone = item['status'] == 'completed';
    final String newStatus = isDone ? 'pending' : 'completed';

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': item['title'],
          'description': item['description'] ?? '',
          'status': newStatus,
        }),
      );
      if (response.statusCode == 200) fetchTasks();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // 4. HTTP DELETE - Hapus Task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) fetchTasks();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  // MODAL: ADD NEW TASK
  void _showAddTaskModal() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add a new task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add context, notes, or a helpful list...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE05638),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        addTask(titleController.text, descController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MODAL: CREATE PROJECT
  void _showCreateProjectModal() {
    final projController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a project',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Group your tasks related to a specific place or topic.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: projController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Color',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children:
                    [
                          Colors.red,
                          Colors.orange,
                          Colors.amber,
                          Colors.green,
                          Colors.blue,
                          Colors.purple,
                        ]
                        .map(
                          (c) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE05638),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Create Project'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              // ------------------ SIDEBAR ------------------
              Container(
                width: 240,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFFE05638),
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tada!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSidebarItem(Icons.today, 'Today', count: totalCount),
                    _buildSidebarItem(Icons.inbox, 'Inbox', count: 4),
                    _buildSidebarItem(
                      Icons.calendar_month,
                      'Upcoming',
                      count: 12,
                    ),
                    _buildSidebarItem(
                      Icons.task_alt,
                      'Completed',
                      count: completedCount,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'PROJECTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSidebarItem(Icons.folder, 'Northstar Launch'),
                    _buildSidebarItem(Icons.folder, 'Personal Admin'),
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
                          Text(
                            'Tiny steps, big wins',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Do one small step right now.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),

              // ------------------ MAIN CONTENT AREA ------------------
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
                                hintText:
                                    'Search tasks, projects, or people...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () => setState(
                              () => showNotifications = !showNotifications,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE05638),
                            radius: 16,
                            child: Text(
                              'A',
                              style: TextStyle(color: Colors.white),
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
                                  children: const [
                                    Text(
                                      'Good morning, Alex! 👋',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Thursday, October 5. You have 3 tasks to move forward today.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE05638),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _showAddTaskModal,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Task'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // STATUS CARDS OVERVIEW
                            Row(
                              children: [
                                _buildMetricCard(
                                  'Today',
                                  '$totalCount',
                                  '5 total',
                                ),
                                _buildMetricCard(
                                  'In Progress',
                                  '$pendingCount',
                                  '3 left',
                                ),
                                _buildMetricCard('Upcoming', '12', 'Due soon'),
                                _buildMetricCard(
                                  'Completed',
                                  '$completedCount',
                                  'Done',
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // TASK LIST TABLE / EMPTY STATE
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Today's tasks",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.filter_list,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  isLoading
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(40),
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : tasks.isEmpty
                                      ? _buildEmptyState()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: tasks.length,
                                          itemBuilder: (context, index) {
                                            final item = tasks[index];
                                            final bool isDone =
                                                item['status'] == 'completed';
                                            final int id = item['id'];

                                            return Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xFFF3F4F6),
                                                  ),
                                                ),
                                              ),
                                              child: ListTile(
                                                leading: Checkbox(
                                                  value: isDone,
                                                  activeColor: const Color(
                                                    0xFFE05638,
                                                  ),
                                                  onChanged: (_) =>
                                                      toggleTaskStatus(item),
                                                ),
                                                title: Text(
                                                  item['title'] ?? '',
                                                  style: TextStyle(
                                                    decoration: isDone
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                    color: isDone
                                                        ? Colors.grey
                                                        : Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle:
                                                    item['description'] !=
                                                            null &&
                                                        item['description']
                                                            .toString()
                                                            .isNotEmpty
                                                    ? Text(
                                                        item['description'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    : null,
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isDone
                                                            ? Colors
                                                                  .green
                                                                  .shade50
                                                            : Colors
                                                                  .amber
                                                                  .shade50,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        item['status'] ??
                                                            'pending',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: isDone
                                                              ? Colors.green
                                                              : Colors
                                                                    .amber
                                                                    .shade900,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                        size: 18,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () =>
                                                          deleteTask(id),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // OVERLAY NOTIFICATION DROPDOWN
          if (showNotifications)
            Positioned(
              top: 65,
              right: 60,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNotifItem(
                      'Alex mentioned you',
                      'Can you review the PR for DB migration?',
                    ),
                    _buildNotifItem(
                      'New task assigned',
                      'Prepare weekly product update',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Sidebar Item
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
            Icon(
              icon,
              size: 18,
              color: isActive ? const Color(0xFFE05638) : Colors.grey,
            ),
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
            if (count != null)
              Text(
                '$count',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Metric Overview Cards
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
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.task_alt, size: 60, color: Color(0xFFE05638)),
            const SizedBox(height: 12),
            const Text(
              'Welcome to Tada!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Turn your tasks into progress, one friendly checkbox at a time.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05638),
                foregroundColor: Colors.white,
              ),
              onPressed: _showAddTaskModal,
              child: const Text('Create your first task'),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Notification Item
  Widget _buildNotifItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const CircleAvatar(radius: 4, backgroundColor: Color(0xFFE05638)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

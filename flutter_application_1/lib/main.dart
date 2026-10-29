
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DailyLifeApp());
}

class DailyLifeApp extends StatelessWidget {
  const DailyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Daily Life',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const SessionGate(),
    );
  }
}

// LOGIN SESSION
class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  String? email;
  String? name;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      email = prefs.getString('email');
      name = prefs.getString('name');
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (email != null) {
      return DailyHome(
        email: email!,
        name: name ?? 'User',
      );
    }

    return LoginPage(onLogin: loadSession);
  }
}

// EMAIL LOGIN
class LoginPage extends StatefulWidget {
  final Future<void> Function() onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty ||
        !email.contains('@') ||
        !email.contains('.') ||
        password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter name, valid email and password (6+ characters)',
          ),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);

    // Demo login: password is validated but not stored.
    if (!mounted) return;
    await widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.checklist,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'My Daily Life',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Plan your day. Reflect. Grow.'),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text(
                      'Login / Create Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Demo login: enter your name, email and a password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TASK MODEL
class DailyTask {
  String title;
  bool completed;

  DailyTask(this.title, {this.completed = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
      };

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }
}

// MAIN APP
class DailyHome extends StatefulWidget {
  final String email;
  final String name;

  const DailyHome({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  State<DailyHome> createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  int selectedIndex = 0;
  late String userName;
  late String userEmail;

  List<DailyTask> tasks = [];

  final whatIDidController = TextEditingController();
  final regretController = TextEditingController();
  final achievementsController = TextEditingController();

  bool loading = true;

  String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  String get journalKey => 'journal_$todayKey';

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    userEmail = widget.email;
    loadData();
  }

  @override
  void dispose() {
    whatIDidController.dispose();
    regretController.dispose();
    achievementsController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTasks = prefs.getString('tasks');
    if (savedTasks != null) {
      try {
        final decoded = jsonDecode(savedTasks) as List;
        tasks = decoded
            .map((item) => DailyTask.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList();
      } catch (_) {
        tasks = [];
      }
    }

    final journal = prefs.getString(journalKey);
    if (journal != null) {
      try {
        final data = jsonDecode(journal) as Map<String, dynamic>;
        whatIDidController.text = data['did'] ?? '';
        regretController.text = data['regret'] ?? '';
        achievementsController.text = data['achievements'] ?? '';
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'tasks',
      jsonEncode(tasks.map((task) => task.toJson()).toList()),
    );
  }

  Future<void> saveJournal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      journalKey,
      jsonEncode({
        'did': whatIDidController.text,
        'regret': regretController.text,
        'achievements': achievementsController.text,
      }),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Today\'s reflection saved!')),
    );
  }

  Future<void> editProfile() async {
    final nameCtrl = TextEditingController(text: userName);
    final emailCtrl = TextEditingController(text: userEmail);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              final newEmail = emailCtrl.text.trim();

              if (newName.isEmpty ||
                  !newEmail.contains('@') ||
                  !newEmail.contains('.')) {
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', newName);
              await prefs.setString('email', newEmail);

              if (!mounted) return;
              setState(() {
                userName = newName;
                userEmail = newEmail;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameCtrl.dispose();
    emailCtrl.dispose();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('name');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const SessionGate(),
      ),
      (_) => false,
    );
  }

  Future<void> addTask() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'What do you need to do?',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            final title = controller.text.trim();
            if (title.isNotEmpty) {
              setState(() => tasks.add(DailyTask(title)));
              saveTasks();
              Navigator.pop(dialogContext);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                setState(() => tasks.add(DailyTask(title)));
                saveTasks();
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    controller.dispose();
  }

  int get completedCount => tasks.where((t) => t.completed).length;
  int get pendingCount => tasks.where((t) => !t.completed).length;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = [
      buildDashboard(),
      buildTasksPage(),
      buildReflectionPage(),
      buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['My Daily Life', 'What I Do', 'Daily Reflection', 'My Profile']
              [selectedIndex],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: pages[selectedIndex],
      floatingActionButton: selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: addTask,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: 'Reflect',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildDashboard() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          'Hello, $userName! 👋',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Today: ${DateTime.now().day}/'
          '${DateTime.now().month}/${DateTime.now().year}',
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Daily Progress',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
                const SizedBox(height: 12),
                Text(
                  '$completedCount Completed  •  $pendingCount Pending',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: tasks.isEmpty
                      ? 0
                      : completedCount / tasks.length,
                  color: Colors.white,
                  backgroundColor: Colors.white30,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        dashboardCard(
          'What I Do',
          '$pendingCount tasks pending',
          Icons.checklist,
          Colors.orange,
          () => setState(() => selectedIndex = 1),
        ),
        dashboardCard(
          'What I Did',
          '$completedCount tasks completed',
          Icons.task_alt,
          Colors.green,
          () => setState(() => selectedIndex = 2),
        ),
        dashboardCard(
          'Regret of the Day',
          'Think, learn and improve',
          Icons.favorite_outline,
          Colors.pink,
          () => setState(() => selectedIndex = 2),
        ),
        dashboardCard(
          'Achievements',
          'Celebrate your progress',
          Icons.emoji_events,
          Colors.amber.shade800,
          () => setState(() => selectedIndex = 2),
        ),
      ],
    );
  }

  Widget dashboardCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget buildTasksPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: statusCard(
                  'Pending',
                  pendingCount,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: statusCard(
                  'Completed',
                  completedCount,
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? const Center(
                  child: Text('No tasks yet. Tap Add Task!'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      child: CheckboxListTile(
                        value: task.completed,
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          task.completed ? 'Completed' : 'Pending',
                        ),
                        activeColor: Colors.deepPurple,
                        onChanged: (value) {
                          setState(() {
                            task.completed = value ?? false;
                          });
                          saveTasks();
                        },
                        secondary: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() => tasks.removeAt(index));
                            saveTasks();
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget statusCard(String title, int count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 28,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget buildReflectionPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Reflect on Your Day 🌱',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Be honest with yourself. Every day is a new chance.'),
        const SizedBox(height: 20),
        reflectionField(
          '1. What I Do',
          'What tasks do I need to do today?',
          whatIDidController,
          Icons.today,
        ),
        reflectionField(
          '2. What I Did',
          'What did I actually do today? What did I finish?',
          whatIDidController,
          Icons.check_circle_outline,
        ),
        reflectionField(
          '3. Regret of the Day',
          'What could I have avoided today? What would I do differently?',
          regretController,
          Icons.favorite_outline,
        ),
        reflectionField(
          '4. Achievements',
          'What am I proud of today? Write even a small achievement.',
          achievementsController,
          Icons.emoji_events,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: saveJournal,
            icon: const Icon(Icons.save),
            label: const Text('Save Today\'s Reflection'),
          ),
        ),
      ],
    );
  }

  Widget reflectionField(
    String title,
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 65, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            userName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(child: Text(userEmail)),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: editProfile,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Tasks Completed'),
            trailing: Text('$completedCount'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text('Tasks Pending'),
            trailing: Text('$pendingCount'),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}

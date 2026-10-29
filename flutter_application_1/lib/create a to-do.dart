import 'dart:convert'; // Imports a library needed by the application.
import 'dart:io'; // Imports a library needed by the application.

import 'package:flutter/material.dart'; // Imports a library needed by the application.
import 'package:image_picker/image_picker.dart'; // Imports a library needed by the application.
import 'package:path_provider/path_provider.dart'; // Imports a library needed by the application.
import 'package:shared_preferences/shared_preferences.dart'; // Imports a library needed by the application.

void main() async {
  // App entry point: initialize Flutter plugins before loading local preferences. Defines a method that performs an action without returning a value.
  WidgetsFlutterBinding
      .ensureInitialized(); // Initializes Flutter before using platform plugins.
  runApp(
      const TaskFlowApp()); // Starts the Flutter application with its root widget.
}

const Color kYellow =
    Color(0xFFFFD600); // Defines a reusable color for the app theme.
const Color kInk =
    Color(0xFF151515); // Defines a reusable color for the app theme.
const Color kCanvas =
    Color(0xFFF7F7F2); // Defines a reusable color for the app theme.
const Color kMuted =
    Color(0xFF777777); // Defines a reusable color for the app theme.

class TaskFlowApp extends StatelessWidget {
  // Defines the TaskFlowApp widget or data class.
  const TaskFlowApp({super.key}); // Creates an immutable widget or value.

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    return MaterialApp(
      // Returns the result of this expression.
      title: 'TaskFlow', // Sets the title or task title.
      debugShowCheckedModeBanner:
          false, // Configures the debugShowCheckedModeBanner property for this widget.
      theme: ThemeData(
        // Configures the theme property for this widget.
        useMaterial3:
            true, // Configures the useMaterial3 property for this widget.
        scaffoldBackgroundColor:
            kCanvas, // Configures the scaffoldBackgroundColor property for this widget.
        colorScheme: ColorScheme.fromSeed(
          // Configures the colorScheme property for this widget.
          seedColor:
              kYellow, // Configures the seedColor property for this widget.
          primary: kInk, // Configures the primary property for this widget.
          secondary:
              kYellow, // Configures the secondary property for this widget.
          surface:
              Colors.white, // Configures the surface property for this widget.
        ),
        fontFamily:
            'Roboto', // Configures the fontFamily property for this widget.
        appBarTheme: const AppBarTheme(
          // Configures the appBarTheme property for this widget.
          backgroundColor: kCanvas, // Sets the background color.
          foregroundColor: kInk, // Sets the foreground or text color.
          elevation: 0, // Configures the elevation property for this widget.
          centerTitle:
              false, // Configures the centerTitle property for this widget.
        ),
        inputDecorationTheme: InputDecorationTheme(
          // Configures the inputDecorationTheme property for this widget.
          filled: true, // Configures the filled property for this widget.
          fillColor: Colors
              .white, // Configures the fillColor property for this widget.
          contentPadding: // Configures the contentPadding property for this widget.
              const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      16), // Applies symmetric horizontal or vertical spacing.
          border: OutlineInputBorder(
            // Sets the border appearance.
            borderRadius: BorderRadius.circular(16), // Sets rounded corners.
            borderSide: BorderSide
                .none, // Configures the borderSide property for this widget.
          ),
          enabledBorder: OutlineInputBorder(
            // Configures the enabledBorder property for this widget.
            borderRadius: BorderRadius.circular(16), // Sets rounded corners.
            borderSide: const BorderSide(
                color: Color(
                    0xFFE9E9E2)), // Configures the borderSide property for this widget.
          ),
          focusedBorder: OutlineInputBorder(
            // Configures the focusedBorder property for this widget.
            borderRadius: BorderRadius.circular(16), // Sets rounded corners.
            borderSide: const BorderSide(
                color: kInk,
                width:
                    1.4), // Configures the borderSide property for this widget.
          ),
        ),
      ),
      home: const SessionGate(), // Sets the first page displayed by the app.
    );
  }
}

class SessionGate extends StatefulWidget {
  // SessionGate checks whether the demo user previously logged in. If the session is saved, show the main app; otherwise show LoginPage. Defines the SessionGate widget or data class.
  const SessionGate({super.key}); // Creates an immutable widget or value.

  @override // Overrides a method from the parent class.
  State<SessionGate> createState() =>
      _SessionGateState(); // Creates the state object for this stateful widget.
}

class _SessionGateState extends State<SessionGate> {
  // Defines the _SessionGateState widget or data class.
  bool _loading = true; // Stores a true or false state value.
  bool _loggedIn = false; // Stores a true or false state value.

  @override // Overrides a method from the parent class.
  void initState() {
    // Defines a method that performs an action without returning a value.
    super.initState(); // Runs the parent widget initialization.
    _loadSession(); // Updates or uses the corresponding application state.
  }

  Future<void> _loadSession() async {
    // Defines an asynchronous method for this operation.
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    if (!mounted) return; // Stops if this widget is no longer active.
    setState(() {
      // Updates state and rebuilds the affected UI.
      _loggedIn = prefs.getBool('isLoggedIn') ??
          false; // Updates or uses the corresponding application state.
      _loading = false; // Updates or uses the corresponding application state.
    });
  }

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    if (_loading) {
      // Checks a condition before continuing.
      return const Scaffold(
          body: Center(
              child:
                  CircularProgressIndicator())); // Returns the result of this expression.
    }
    return _loggedIn // Returns the result of this expression.
        ? const MainShell() // Selects a value from a conditional expression.
        : LoginPage(
            onLogin: () => setState(() => _loggedIn =
                true)); // Selects a value from a conditional expression.
  }
}

class LoginPage extends StatefulWidget {
  // Defines the LoginPage widget or data class.
  const LoginPage(
      {super.key,
      required this.onLogin}); // Creates an immutable widget or value.
  final VoidCallback
      onLogin; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  State<LoginPage> createState() =>
      _LoginPageState(); // Creates the state object for this stateful widget.
}

class _LoginPageState extends State<LoginPage> {
  // Defines the _LoginPageState widget or data class.
  final _username = TextEditingController(
      text: 'demo'); // Declares a value used by this widget or operation.
  final _password = TextEditingController(
      text: '1234'); // Declares a value used by this widget or operation.
  bool _obscure = true; // Stores a true or false state value.
  bool _busy = false; // Stores a true or false state value.
  String? _error; // Stores a text value.

  @override // Overrides a method from the parent class.
  void dispose() {
    // Defines a method that performs an action without returning a value.
    _username.dispose(); // Updates or uses the corresponding application state.
    _password.dispose(); // Updates or uses the corresponding application state.
    super.dispose(); // Runs the parent widget cleanup.
  }

  Future<void> _login() async {
    // Defines an asynchronous method for this operation.
    FocusScope.of(context)
        .unfocus(); // Configures this part of the application logic or interface.
    if (_username.text.trim() != 'demo' || _password.text != '1234') {
      // Checks a condition before continuing.
      setState(() => _error =
          'Invalid details. Use the demo account below.'); // Updates state and rebuilds the affected UI.
      return; // Configures this part of the application logic or interface.
    }
    setState(() {
      // Updates state and rebuilds the affected UI.
      _busy = true; // Updates or uses the corresponding application state.
      _error = null; // Updates or uses the corresponding application state.
    });
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    await prefs.setBool(
        'isLoggedIn', true); // Waits for this asynchronous operation to finish.
    if ((prefs.getString('userName') ?? '').isEmpty) {
      // Checks a condition before continuing.
      await prefs.setString('userName',
          'Demo User'); // Waits for this asynchronous operation to finish.
    }
    if (!mounted) return; // Stops if this widget is no longer active.
    widget.onLogin(); // Accesses data or callbacks passed to this widget.
  }

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    return Scaffold(
      // Returns the result of this expression.
      body: SafeArea(
        // Configures the body property for this widget.
        child: Center(
          // Sets the widget contained inside this widget.
          child: SingleChildScrollView(
            // Sets the widget contained inside this widget.
            padding: const EdgeInsets.all(24), // Sets internal spacing.
            child: ConstrainedBox(
              // Sets the widget contained inside this widget.
              constraints: const BoxConstraints(
                  maxWidth:
                      440), // Configures the constraints property for this widget.
              child: Column(
                // Sets the widget contained inside this widget.
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Controls alignment across the main layout direction.
                children: [
                  // Defines the widgets displayed inside this layout.
                  Image.asset(
                      'assets/images/app_logo.png', // Brand logo asset shown on the login screen. Loads an image from the app assets.
                      height: 88,
                      fit: BoxFit.contain), // Sets the widget height.
                  const SizedBox(height: 32), // Adds fixed spacing or size.
                  const Text(
                      'MAKE ROOM\nFOR WHAT MATTERS.', // Displays text on the screen.
                      style: TextStyle(
                          // Configures the visual style.
                          fontSize: 34, // Sets the text size.
                          height: 1.08, // Sets the widget height.
                          fontWeight: FontWeight
                              .w900, // Sets the thickness of the text.
                          letterSpacing:
                              -1.2)), // Sets the spacing between letters.
                  const SizedBox(height: 12), // Adds fixed spacing or size.
                  const Text(
                      'Your day, organized. One task at a time.', // Displays text on the screen.
                      style: TextStyle(
                          color: kMuted,
                          fontSize: 15)), // Configures the visual style.
                  const SizedBox(height: 34), // Adds fixed spacing or size.
                  const Text('Username', // Displays text on the screen.
                      style: TextStyle(
                          fontWeight:
                              FontWeight.w700)), // Configures the visual style.
                  const SizedBox(height: 8), // Adds fixed spacing or size.
                  TextField(
                    // Accepts text entered by the user.
                    controller:
                        _username, // Connects the text field to its controller.
                    textInputAction: TextInputAction
                        .next, // Configures the textInputAction property for this widget.
                    decoration: const InputDecoration(
                        // Configures the widget appearance.
                        prefixIcon: Icon(Icons
                            .person_outline), // Configures the prefixIcon property for this widget.
                        hintText:
                            'Enter username'), // Shows placeholder text in an input.
                  ),
                  const SizedBox(height: 18), // Adds fixed spacing or size.
                  const Text('Password', // Displays text on the screen.
                      style: TextStyle(
                          fontWeight:
                              FontWeight.w700)), // Configures the visual style.
                  const SizedBox(height: 8), // Adds fixed spacing or size.
                  TextField(
                    // Accepts text entered by the user.
                    controller:
                        _password, // Connects the text field to its controller.
                    obscureText:
                        _obscure, // Configures the obscureText property for this widget.
                    onSubmitted: (_) =>
                        _login(), // Runs this callback when the user submits the text.
                    decoration: InputDecoration(
                      // Configures the widget appearance.
                      prefixIcon: const Icon(Icons
                          .lock_outline), // Configures the prefixIcon property for this widget.
                      hintText:
                          'Enter password', // Shows placeholder text in an input.
                      suffixIcon: IconButton(
                        // Configures the suffixIcon property for this widget.
                        onPressed: () => setState(() => _obscure =
                            !_obscure), // Defines the action when this button is pressed.
                        icon: Icon(_obscure // Sets the displayed icon.
                            ? Icons
                                .visibility_outlined // Selects a value from a conditional expression.
                            : Icons
                                .visibility_off_outlined), // Selects a value from a conditional expression.
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    // Checks a condition before continuing.
                    const SizedBox(height: 12), // Adds fixed spacing or size.
                    Text(_error!, // Displays text on the screen.
                        style: const TextStyle(
                            // Configures the visual style.
                            color: Colors.red,
                            fontWeight:
                                FontWeight.w600)), // Sets the displayed color.
                  ],
                  const SizedBox(height: 24), // Adds fixed spacing or size.
                  SizedBox(
                    // Adds fixed spacing or size.
                    width: double.infinity, // Sets the widget width.
                    height: 56, // Sets the widget height.
                    child: FilledButton(
                      // Sets the widget contained inside this widget.
                      onPressed: _busy
                          ? null
                          : _login, // Defines the action when this button is pressed.
                      style: FilledButton.styleFrom(
                        // Configures the visual style.
                        backgroundColor: kYellow, // Sets the background color.
                        foregroundColor:
                            kInk, // Sets the foreground or text color.
                        shape: RoundedRectangleBorder(
                            // Configures the shape property for this widget.
                            borderRadius: BorderRadius.circular(
                                16)), // Sets rounded corners.
                      ),
                      child:
                          _busy // Sets the widget contained inside this widget.
                              ? const SizedBox(
                                  // Selects a value from a conditional expression.
                                  height: 22, // Sets the widget height.
                                  width: 22, // Sets the widget width.
                                  child: CircularProgressIndicator(
                                      strokeWidth:
                                          2)) // Sets the widget contained inside this widget.
                              : const Text(
                                  'LOGIN  →', // Selects a value from a conditional expression.
                                  style: TextStyle(
                                      // Configures the visual style.
                                      fontWeight: FontWeight
                                          .w900, // Sets the thickness of the text.
                                      letterSpacing:
                                          1)), // Sets the spacing between letters.
                    ),
                  ),
                  const SizedBox(height: 20), // Adds fixed spacing or size.
                  Container(
                    // Creates a customizable layout box.
                    width: double.infinity, // Sets the widget width.
                    padding: const EdgeInsets.all(16), // Sets internal spacing.
                    decoration: BoxDecoration(
                        // Configures the widget appearance.
                        color: Colors.white, // Sets the displayed color.
                        borderRadius:
                            BorderRadius.circular(18), // Sets rounded corners.
                        border: Border.all(
                            color: const Color(
                                0xFFE9E9E2))), // Sets the border appearance.
                    child: const Column(
                      // Sets the widget contained inside this widget.
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Controls alignment across the main layout direction.
                      children: [
                        // Defines the widgets displayed inside this layout.
                        Text('DEMO ACCOUNT', // Displays text on the screen.
                            style: TextStyle(
                                // Configures the visual style.
                                fontSize: 11, // Sets the text size.
                                letterSpacing:
                                    1.3, // Sets the spacing between letters.
                                fontWeight: FontWeight
                                    .w900, // Sets the thickness of the text.
                                color: kMuted)), // Sets the displayed color.
                        SizedBox(height: 8), // Adds fixed spacing or size.
                        Text('Username:  demo', // Displays text on the screen.
                            style: TextStyle(
                                fontWeight: FontWeight
                                    .w700)), // Configures the visual style.
                        SizedBox(height: 4), // Adds fixed spacing or size.
                        Text('Password:  1234', // Displays text on the screen.
                            style: TextStyle(
                                fontWeight: FontWeight
                                    .w700)), // Configures the visual style.
                      ],
                    ),
                  ),
                  const SizedBox(height: 18), // Adds fixed spacing or size.
                  const Center(
                      // Centers its child widget.
                      child: Text(
                          'Local demo • No account server needed', // Sets the widget contained inside this widget.
                          style: TextStyle(
                              color: kMuted,
                              fontSize: 12))), // Configures the visual style.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum TaskStatus {
  pending,
  completed
} // Defines the possible status values for a task.

class TaskItem {
  // Model class: one task's data. toJson/fromJson let us save and restore it as JSON. Defines the TaskItem widget or data class.
  TaskItem(
      // Creates a task with the provided details.
      {required this.id, // Configures this part of the application logic or interface.
      required this.title, // Requires this parameter when creating the widget.
      required this.createdAt, // Requires this parameter when creating the widget.
      this.status = TaskStatus
          .pending}); // Initializes this field from the constructor parameter.
  final String id; // Declares a value used by this widget or operation.
  String title; // Stores a text value.
  final DateTime
      createdAt; // Declares a value used by this widget or operation.
  TaskStatus status; // Stores the current completion status of the task.

  Map<String, dynamic> toJson() => {
        // Configures this part of the application logic or interface.
        'id': id, // Sets this JSON field using the task data.
        'title': title, // Sets this JSON field using the task data.
        'createdAt': createdAt
            .toIso8601String(), // Sets this JSON field using the task data.
        'status': status.name, // Sets this JSON field using the task data.
      };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        // Creates a task object from previously saved JSON data.
        id: json['id'] as String, // Configures the id property for this widget.
        title: json['title'] as String, // Sets the title or task title.
        createdAt: DateTime.tryParse(json['createdAt'] as String? ??
                '') ?? // Configures the createdAt property for this widget.
            DateTime
                .now(), // Configures this part of the application logic or interface.
        status: (json['status'] ==
                'completed') // Configures the status property for this widget.
            ? TaskStatus
                .completed // Selects a value from a conditional expression.
            : TaskStatus
                .pending, // Selects a value from a conditional expression.
      );
}

class MainShell extends StatefulWidget {
  // MainShell holds the shared task list and switches between Tasks and Profile tabs. Defines the MainShell widget or data class.
  const MainShell({super.key}); // Creates an immutable widget or value.

  @override // Overrides a method from the parent class.
  State<MainShell> createState() =>
      _MainShellState(); // Creates the state object for this stateful widget.
}

class _MainShellState extends State<MainShell> {
  // Defines the _MainShellState widget or data class.
  int _tab = 0; // Stores a whole-number value.
  bool _loading = true; // Stores a true or false state value.
  final List<TaskItem> _tasks =
      []; // Declares a value used by this widget or operation.
  String _userName = 'Demo User'; // Stores a text value.
  String? _photoPath; // Stores a text value.

  @override // Overrides a method from the parent class.
  void initState() {
    // Defines a method that performs an action without returning a value.
    super.initState(); // Runs the parent widget initialization.
    _loadData(); // Updates or uses the corresponding application state.
  }

  Future<void> _loadData() async {
    // Defines an asynchronous method for this operation.
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    final raw = prefs.getString('tasks') ??
        '[]'; // Reads the saved task list or uses an empty list.
    try {
      // Attempts an operation that may fail.
      final list = (jsonDecode(raw) as List<
              dynamic>) // Declares a value used by this widget or operation.
          .map((e) => TaskItem.fromJson(Map<String, dynamic>.from(
              e as Map))) // Transforms each item in the collection.
          .toList(); // Converts the resulting collection into a list.
      _tasks // Configures this part of the application logic or interface.
        ..clear() // Updates the existing list without creating a new one.
        ..addAll(list); // Updates the existing list without creating a new one.
    } catch (_) {
      // Configures this part of the application logic or interface.
      _tasks.clear(); // Updates or uses the corresponding application state.
    }
    _userName = prefs.getString('userName') ??
        'Demo User'; // Updates or uses the corresponding application state.
    _photoPath = prefs.getString(
        'photoPath'); // Updates or uses the corresponding application state.
    if (!mounted) return; // Stops if this widget is no longer active.
    setState(
        () => _loading = false); // Updates state and rebuilds the affected UI.
  }

  Future<void> _saveTasks() async {
    // Convert tasks to JSON and save them on this device (no server/database). Defines an asynchronous method for this operation.
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    await prefs.setString(
        // Waits for this asynchronous operation to finish.
        'tasks',
        jsonEncode(_tasks
            .map((e) => e.toJson())
            .toList())); // Configures this part of the application logic or interface.
  }

  Future<void> _saveName(String name) async {
    // Defines an asynchronous method for this operation.
    final clean =
        name.trim(); // Declares a value used by this widget or operation.
    if (clean.isEmpty) return; // Checks a condition before continuing.
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    await prefs.setString(
        'userName', clean); // Waits for this asynchronous operation to finish.
    if (!mounted) return; // Stops if this widget is no longer active.
    setState(
        () => _userName = clean); // Updates state and rebuilds the affected UI.
  }

  Future<void> _pickPhoto() async {
    // Pick an image from the gallery and copy it into app-owned storage so the path persists. Defines an asynchronous method for this operation.
    try {
      // Attempts an operation that may fail.
      final picked = await ImagePicker().pickImage(
          // Declares a value used by this widget or operation.
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1200); // Configures the source property for this widget.
      if (picked == null) return; // Checks a condition before continuing.
      final directory =
          await getApplicationDocumentsDirectory(); // Declares a value used by this widget or operation.
      final extension = // Declares a value used by this widget or operation.
          picked.path.contains('.')
              ? picked.path.split('.').last
              : 'jpg'; // Configures this part of the application logic or interface.
      final saved = await File(
              picked.path) // Declares a value used by this widget or operation.
          .copy(
              '${directory.path}/profile_photo.$extension'); // Configures this part of the application logic or interface.
      final prefs = await SharedPreferences
          .getInstance(); // Opens local preferences stored on this device.
      await prefs.setString('photoPath',
          saved.path); // Waits for this asynchronous operation to finish.
      if (!mounted) return; // Stops if this widget is no longer active.
      setState(() => _photoPath =
          saved.path); // Updates state and rebuilds the affected UI.
      _message(
          'Profile photo updated'); // Updates or uses the corresponding application state.
    } catch (e) {
      // Configures this part of the application logic or interface.
      _message(
          'Could not open gallery. Please try again.'); // Updates or uses the corresponding application state.
    }
  }

  void _message(String text) {
    // Defines a method that performs an action without returning a value.
    if (!mounted) return; // Stops if this widget is no longer active.
    ScaffoldMessenger.of(context).showSnackBar(
        // Shows a temporary message at the bottom of the screen.
        SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior
                .floating)); // Configures this part of the application logic or interface.
  }

  Future<void> _addTask() async {
    // Ask for a title, create a task object, update the UI, then persist the list. Defines an asynchronous method for this operation.
    final title =
        await _taskDialog(); // Declares a value used by this widget or operation.
    if (title == null || title.trim().isEmpty)
      return; // Checks a condition before continuing.
    setState(() => _tasks.insert(
        // Updates state and rebuilds the affected UI.
        0, // Supplies a numeric value to this widget or method.
        TaskItem(
          // Creates a task with the provided details.
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(), // Configures the id property for this widget.
          title: title.trim(), // Sets the title or task title.
          createdAt: DateTime
              .now(), // Configures the createdAt property for this widget.
        )));
    await _saveTasks(); // Saves the updated tasks to local storage.
  }

  Future<void> _editTask(TaskItem task) async {
    // Reuse the task dialog with the existing title, then update and save the task. Defines an asynchronous method for this operation.
    final title = await _taskDialog(
        initial: task.title,
        heading:
            'Edit task'); // Declares a value used by this widget or operation.
    if (title == null || title.trim().isEmpty)
      return; // Checks a condition before continuing.
    setState(() => task.title =
        title.trim()); // Updates state and rebuilds the affected UI.
    await _saveTasks(); // Saves the updated tasks to local storage.
  }

  Future<String?> _taskDialog(
      // Opens the shared Add/Edit dialog. The dialog owns its controller so it is disposed only when the dialog widget itself is removed from the widget tree. Defines an asynchronous method for this operation.
      {String initial = '',
      String heading = 'Add a new task'}) {
    // Configures this part of the application logic or interface.
    return showDialog<String>(
      // Returns the result of this expression.
      context: context, // Configures the context property for this widget.
      builder: (_) => _TaskEditorDialog(
          initial: initial,
          heading: heading), // Builds the widget or dialog requested here.
    );
  }

  Future<void> _deleteTask(TaskItem task) async {
    // Confirm deletion first so a task is not removed accidentally. Defines an asynchronous method for this operation.
    final confirmed = await showDialog<bool>(
      // Declares a value used by this widget or operation.
      context: context, // Configures the context property for this widget.
      builder: (dialogContext) => AlertDialog(
        // Builds the widget or dialog requested here.
        title: const Text('Delete task?'), // Sets the title or task title.
        content: Text(
            '“${task.title}” will be removed from your list.'), // Configures the content property for this widget.
        actions: [
          // Configures the actions property for this widget.
          TextButton(
              // Creates a text-style button.
              onPressed: () => Navigator.pop(dialogContext,
                  false), // Defines the action when this button is pressed.
              child: const Text(
                  'Cancel')), // Sets the widget contained inside this widget.
          FilledButton(
            // Creates a filled action button.
            style: FilledButton.styleFrom(
                backgroundColor: kInk), // Configures the visual style.
            onPressed: () => Navigator.pop(dialogContext,
                true), // Defines the action when this button is pressed.
            child: const Text(
                'Delete'), // Sets the widget contained inside this widget.
          ),
        ],
      ),
    );
    if (confirmed != true) return; // Checks a condition before continuing.
    setState(() => _tasks.removeWhere(
        (e) => e.id == task.id)); // Updates state and rebuilds the affected UI.
    await _saveTasks(); // Saves the updated tasks to local storage.
    _message(
        'Task deleted'); // Updates or uses the corresponding application state.
  }

  Future<void> _toggleTask(TaskItem task, bool completed) async {
    // Checkbox updates the task status and immediately saves the new status. Defines an asynchronous method for this operation.
    setState(() => // Updates state and rebuilds the affected UI.
        task.status = completed
            ? TaskStatus.completed
            : TaskStatus
                .pending); // Configures this part of the application logic or interface.
    await _saveTasks(); // Saves the updated tasks to local storage.
  }

  Future<void> _logout() async {
    // Defines an asynchronous method for this operation.
    final prefs = await SharedPreferences
        .getInstance(); // Opens local preferences stored on this device.
    await prefs.setBool('isLoggedIn',
        false); // Waits for this asynchronous operation to finish.
    if (!mounted) return; // Stops if this widget is no longer active.
    Navigator.of(context).pushAndRemoveUntil(
      // Navigates between pages or closes a dialog.
      MaterialPageRoute(
          builder: (_) =>
              const SessionGate()), // Defines the page to navigate to.
      (route) =>
          false, // Configures this part of the application logic or interface.
    );
  }

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    if (_loading) // Checks a condition before continuing.
      return const Scaffold(
          body: Center(
              child:
                  CircularProgressIndicator())); // Returns the result of this expression.
    final completed = // Declares a value used by this widget or operation.
        _tasks
            .where((t) => t.status == TaskStatus.completed)
            .length; // Updates or uses the corresponding application state.
    final pending = _tasks.length -
        completed; // Declares a value used by this widget or operation.
    return Scaffold(
      // Returns the result of this expression.
      appBar: AppBar(
        // Configures the appBar property for this widget.
        title: Row(
          // Sets the title or task title.
          children: [
            // Defines the widgets displayed inside this layout.
            Image.asset(
                'assets/images/app_logo.png', // Reuse the same logo asset in the app header. Loads an image from the app assets.
                height: 36,
                width: 145,
                fit: BoxFit.contain), // Sets the widget height.
          ],
        ),
        actions: [
          // Configures the actions property for this widget.
          IconButton(
              // Creates a tappable icon button.
              tooltip:
                  'Log out', // Configures the tooltip property for this widget.
              onPressed:
                  _logout, // Defines the action when this button is pressed.
              icon:
                  const Icon(Icons.logout_rounded)), // Sets the displayed icon.
          const SizedBox(width: 6), // Adds fixed spacing or size.
        ],
      ),
      body: IndexedStack(
        // Configures the body property for this widget.
        index: _tab, // Selects the visible stack page.
        children: [
          // Defines the widgets displayed inside this layout.
          TasksPage(
            // Configures this part of the application logic or interface.
            tasks: _tasks, // Passes the list of tasks to this widget.
            completed: completed, // Passes the number of completed tasks.
            pending: pending, // Passes the number of pending tasks.
            onAdd: _addTask, // Passes the callback for adding a task.
            onEdit: _editTask, // Passes the callback for editing a task.
            onDelete: _deleteTask, // Passes the callback for deleting a task.
            onToggle:
                _toggleTask, // Passes the callback for changing task completion.
          ),
          ProfilePage(
            // Configures this part of the application logic or interface.
            name: _userName, // Passes the user display name.
            photoPath: _photoPath, // Passes the saved profile photo location.
            total:
                _tasks.length, // Configures the total property for this widget.
            completed: completed, // Passes the number of completed tasks.
            pending: pending, // Passes the number of pending tasks.
            onSaveName:
                _saveName, // Passes the callback for saving the profile name.
            onPickPhoto:
                _pickPhoto, // Passes the callback for selecting a profile photo.
          ),
        ],
      ),
      floatingActionButton: _tab ==
              0 // Configures the floatingActionButton property for this widget.
          ? FloatingActionButton.extended(
              // Selects a value from a conditional expression.
              onPressed:
                  _addTask, // Defines the action when this button is pressed.
              backgroundColor: kYellow, // Sets the background color.
              foregroundColor: kInk, // Sets the foreground or text color.
              icon: const Icon(Icons.add_rounded), // Sets the displayed icon.
              label: const Text('New task', // Sets the label shown to the user.
                  style: TextStyle(
                      fontWeight:
                          FontWeight.w800)), // Configures the visual style.
            )
          : null, // Selects a value from a conditional expression.
      bottomNavigationBar: NavigationBar(
        // Configures the bottomNavigationBar property for this widget.
        selectedIndex: _tab, // Sets the currently selected navigation tab.
        onDestinationSelected: (value) => setState(() =>
            _tab = value), // Switches to the selected bottom navigation tab.
        backgroundColor: Colors.white, // Sets the background color.
        indicatorColor: kYellow.withValues(
            alpha:
                0.45), // Configures the indicatorColor property for this widget.
        destinations: const [
          // Configures the destinations property for this widget.
          NavigationDestination(
              // Defines a bottom navigation tab.
              icon: Icon(Icons.checklist_rounded), // Sets the displayed icon.
              selectedIcon: Icon(Icons
                  .checklist_rounded), // Configures the selectedIcon property for this widget.
              label: 'Tasks'), // Sets the label shown to the user.
          NavigationDestination(
              // Defines a bottom navigation tab.
              icon: Icon(
                  Icons.person_outline_rounded), // Sets the displayed icon.
              selectedIcon: Icon(Icons
                  .person_rounded), // Configures the selectedIcon property for this widget.
              label: 'Profile'), // Sets the label shown to the user.
        ],
      ),
    );
  }
}

class _TaskEditorDialog extends StatefulWidget {
  // A separate StatefulWidget gives the TextEditingController the same lifecycle as the dialog. This avoids disposing the controller while the closing dialog may still be finishing its route transition. Defines the _TaskEditorDialog widget or data class.
  const _TaskEditorDialog(
      {required this.initial,
      required this.heading}); // Creates an immutable widget or value.

  final String initial; // Declares a value used by this widget or operation.
  final String heading; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  State<_TaskEditorDialog> createState() =>
      _TaskEditorDialogState(); // Creates the state object for this stateful widget.
}

class _TaskEditorDialogState extends State<_TaskEditorDialog> {
  // Defines the _TaskEditorDialogState widget or data class.
  late final TextEditingController
      _controller; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  void initState() {
    // Defines a method that performs an action without returning a value.
    super.initState(); // Runs the parent widget initialization.
    _controller = TextEditingController(
        text: widget
            .initial); // For Add, initial is empty. For Edit, it contains the current task title. Updates or uses the corresponding application state.
  }

  @override // Overrides a method from the parent class.
  void dispose() {
    // Defines a method that performs an action without returning a value.
    _controller
        .dispose(); // Always release the controller when Flutter disposes this dialog. Updates or uses the corresponding application state.
    super.dispose(); // Runs the parent widget cleanup.
  }

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    return AlertDialog(
      // Returns the result of this expression.
      title: Text(widget.heading, // Sets the title or task title.
          style: const TextStyle(
              fontWeight: FontWeight.w900)), // Configures the visual style.
      content: TextField(
        // Configures the content property for this widget.
        controller: _controller, // Connects the text field to its controller.
        autofocus: true, // Configures the autofocus property for this widget.
        maxLength: 120, // Limits the number of characters.
        textCapitalization: TextCapitalization
            .sentences, // Configures the textCapitalization property for this widget.
        onSubmitted: (_) => Navigator.pop(
            context,
            _controller
                .text), // Runs this callback when the user submits the text.
        decoration: // Configures the widget appearance.
            const InputDecoration(
                hintText:
                    'e.g. Finish project report'), // Sets the appearance of a text input.
      ),
      actions: [
        // Configures the actions property for this widget.
        TextButton(
          // Creates a text-style button.
          onPressed: () => Navigator.pop(
              context), // Defines the action when this button is pressed.
          child: const Text(
              'Cancel'), // Sets the widget contained inside this widget.
        ),
        FilledButton(
          // Creates a filled action button.
          style: FilledButton.styleFrom(
              // Configures the visual style.
              backgroundColor: kYellow,
              foregroundColor: kInk), // Sets the background color.
          onPressed: () => Navigator.pop(
              context,
              _controller
                  .text), // Defines the action when this button is pressed.
          child: const Text(
              'Save task'), // Sets the widget contained inside this widget.
        ),
      ],
    );
  }
}

class TasksPage extends StatefulWidget {
  // TasksPage displays the list, filters, progress summary, and task action buttons. Defines the TasksPage widget or data class.
  const TasksPage({
    // Creates an immutable widget or value.
    super.key, // Passes the optional widget key to the parent constructor.
    required this.tasks, // Requires this parameter when creating the widget.
    required this.completed, // Requires this parameter when creating the widget.
    required this.pending, // Requires this parameter when creating the widget.
    required this.onAdd, // Requires this parameter when creating the widget.
    required this.onEdit, // Requires this parameter when creating the widget.
    required this.onDelete, // Requires this parameter when creating the widget.
    required this.onToggle, // Requires this parameter when creating the widget.
  });

  final List<TaskItem>
      tasks; // Declares a value used by this widget or operation.
  final int completed; // Declares a value used by this widget or operation.
  final int pending; // Declares a value used by this widget or operation.
  final Future<void> Function()
      onAdd; // Declares a value used by this widget or operation.
  final Future<void> Function(TaskItem)
      onEdit; // Declares a value used by this widget or operation.
  final Future<void> Function(TaskItem)
      onDelete; // Declares a value used by this widget or operation.
  final Future<void> Function(TaskItem, bool)
      onToggle; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  State<TasksPage> createState() =>
      _TasksPageState(); // Creates the state object for this stateful widget.
}

class _TasksPageState extends State<TasksPage> {
  // Defines the _TasksPageState widget or data class.
  String _filter = 'All'; // Stores a text value.

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    final visible = widget.tasks.where((task) {
      // Declares a value used by this widget or operation.
      if (_filter == 'Completed')
        return task.status ==
            TaskStatus.completed; // Checks a condition before continuing.
      if (_filter == 'Pending')
        return task.status ==
            TaskStatus.pending; // Checks a condition before continuing.
      return true; // Returns the result of this expression.
    }).toList(); // Configures this part of the application logic or interface.

    return SafeArea(
      // Returns the result of this expression.
      child: ListView(
        // Sets the widget contained inside this widget.
        padding:
            const EdgeInsets.fromLTRB(20, 8, 20, 100), // Sets internal spacing.
        children: [
          // Defines the widgets displayed inside this layout.
          const Text('YOUR SPACE', // Displays text on the screen.
              style: TextStyle(
                  // Configures the visual style.
                  color: kMuted, // Sets the displayed color.
                  fontSize: 11, // Sets the text size.
                  fontWeight:
                      FontWeight.w900, // Sets the thickness of the text.
                  letterSpacing: 2)), // Sets the spacing between letters.
          const SizedBox(height: 8), // Adds fixed spacing or size.
          const Text('Get things\ndone.', // Displays text on the screen.
              style: TextStyle(
                  // Configures the visual style.
                  fontSize: 36, // Sets the text size.
                  height: 1.05, // Sets the widget height.
                  fontWeight:
                      FontWeight.w900, // Sets the thickness of the text.
                  letterSpacing: -1.2)), // Sets the spacing between letters.
          const SizedBox(height: 22), // Adds fixed spacing or size.
          Container(
            // Creates a customizable layout box.
            padding: const EdgeInsets.all(20), // Sets internal spacing.
            decoration: BoxDecoration(
                // Configures the widget appearance.
                color: kInk,
                borderRadius:
                    BorderRadius.circular(24)), // Sets the displayed color.
            child: Column(
              // Sets the widget contained inside this widget.
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Controls alignment across the main layout direction.
              children: [
                // Defines the widgets displayed inside this layout.
                const Text(
                    'YOUR DAILY PROGRESS', // Displays text on the screen.
                    style: TextStyle(
                        // Configures the visual style.
                        color: kYellow, // Sets the displayed color.
                        fontSize: 11, // Sets the text size.
                        fontWeight:
                            FontWeight.w900, // Sets the thickness of the text.
                        letterSpacing:
                            1.4)), // Sets the spacing between letters.
                const SizedBox(height: 16), // Adds fixed spacing or size.
                Row(
                  // Arranges child widgets horizontally.
                  children: [
                    // Defines the widgets displayed inside this layout.
                    Expanded(
                        // Uses available space within a row or column.
                        child: _ProgressStat(
                            // Sets the widget contained inside this widget.
                            value:
                                '${widget.tasks.length}', // Sets the current value.
                            label:
                                'TOTAL TASKS')), // Sets the label shown to the user.
                    Expanded(
                        // Uses available space within a row or column.
                        child: _ProgressStat(
                            // Sets the widget contained inside this widget.
                            value: '${widget.completed}',
                            label: 'COMPLETED')), // Sets the current value.
                    Expanded(
                        // Uses available space within a row or column.
                        child: _ProgressStat(
                            // Sets the widget contained inside this widget.
                            value: '${widget.pending}',
                            label: 'PENDING')), // Sets the current value.
                  ],
                ),
                const SizedBox(height: 18), // Adds fixed spacing or size.
                ClipRRect(
                  // Clips content using rounded corners.
                  borderRadius:
                      BorderRadius.circular(10), // Sets rounded corners.
                  child: LinearProgressIndicator(
                    // Sets the widget contained inside this widget.
                    value: widget.tasks.isEmpty // Sets the current value.
                        ? 0 // Selects a value from a conditional expression.
                        : widget.completed /
                            widget.tasks
                                .length, // Selects a value from a conditional expression.
                    minHeight:
                        8, // Configures the minHeight property for this widget.
                    backgroundColor:
                        Colors.white24, // Sets the background color.
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        kYellow), // Configures the valueColor property for this widget.
                  ),
                ),
                const SizedBox(height: 8), // Adds fixed spacing or size.
                Text(
                    // Displays text on the screen.
                    widget.tasks
                            .isEmpty // Accesses data or callbacks passed to this widget.
                        ? 'Add a task to start your progress.' // Selects a value from a conditional expression.
                        : '${(widget.completed / widget.tasks.length * 100).round()}% of your tasks completed', // Selects a value from a conditional expression.
                    style: // Configures the visual style.
                        const TextStyle(
                            color: Colors.white70,
                            fontSize:
                                12)), // Sets text appearance and formatting.
              ],
            ),
          ),
          const SizedBox(height: 26), // Adds fixed spacing or size.
          Row(
            // Arranges child widgets horizontally.
            children: [
              // Defines the widgets displayed inside this layout.
              const Expanded(
                  // Uses available space within a row or column.
                  child: Text(
                      'My tasks', // Sets the widget contained inside this widget.
                      style: TextStyle(
                          // Configures the visual style.
                          fontSize: 22, // Sets the text size.
                          fontWeight: FontWeight
                              .w900, // Sets the thickness of the text.
                          letterSpacing:
                              -0.5))), // Sets the spacing between letters.
              Text('${visible.length} items', // Displays text on the screen.
                  style: const TextStyle(
                      // Configures the visual style.
                      color: kMuted, // Sets the displayed color.
                      fontSize: 12, // Sets the text size.
                      fontWeight:
                          FontWeight.w600)), // Sets the thickness of the text.
            ],
          ),
          const SizedBox(height: 14), // Adds fixed spacing or size.
          SingleChildScrollView(
            // Allows content to scroll when needed.
            scrollDirection: Axis
                .horizontal, // Configures the scrollDirection property for this widget.
            child: Row(
              // Sets the widget contained inside this widget.
              children: ['All', 'Pending', 'Completed'].map((filter) {
                // Defines the widgets displayed inside this layout.
                final selected = _filter ==
                    filter; // Declares a value used by this widget or operation.
                return Padding(
                  // Returns the result of this expression.
                  padding:
                      const EdgeInsets.only(right: 8), // Sets internal spacing.
                  child: ChoiceChip(
                    // Sets the widget contained inside this widget.
                    label: Text(filter), // Sets the label shown to the user.
                    selected: selected, // Marks the current option as selected.
                    onSelected: (_) => setState(() => _filter =
                        filter), // Updates the currently selected task filter.
                    backgroundColor: Colors.white, // Sets the background color.
                    selectedColor:
                        kYellow, // Configures the selectedColor property for this widget.
                    side: BorderSide(
                        // Configures the side property for this widget.
                        color: selected
                            ? kYellow
                            : const Color(
                                0xFFE9E9E2)), // Sets the displayed color.
                    labelStyle: // Configures the labelStyle property for this widget.
                        TextStyle(
                            fontWeight: FontWeight.w800,
                            color:
                                kInk), // Sets text appearance and formatting.
                  ),
                );
              }).toList(), // Configures this part of the application logic or interface.
            ),
          ),
          const SizedBox(height: 12), // Adds fixed spacing or size.
          if (visible.isEmpty) // Checks a condition before continuing.
            Container(
              // Creates a customizable layout box.
              padding: const EdgeInsets.symmetric(
                  vertical: 32, horizontal: 20), // Sets internal spacing.
              decoration: BoxDecoration(
                  // Configures the widget appearance.
                  color: Colors.white, // Sets the displayed color.
                  borderRadius:
                      BorderRadius.circular(22), // Sets rounded corners.
                  border: Border.all(
                      color: const Color(
                          0xFFE9E9E2))), // Sets the border appearance.
              child: Column(
                // Sets the widget contained inside this widget.
                children: [
                  // Defines the widgets displayed inside this layout.
                  Container(
                    // Creates a customizable layout box.
                    height: 58, // Sets the widget height.
                    width: 58, // Sets the widget width.
                    decoration: const BoxDecoration(
                        // Configures the widget appearance.
                        color: kYellow,
                        shape: BoxShape.circle), // Sets the displayed color.
                    child: const Icon(Icons.add_task_rounded,
                        size:
                            28), // Sets the widget contained inside this widget.
                  ),
                  const SizedBox(height: 14), // Adds fixed spacing or size.
                  Text(
                      // Displays text on the screen.
                      widget.tasks
                              .isEmpty // Accesses data or callbacks passed to this widget.
                          ? 'A fresh start.' // Selects a value from a conditional expression.
                          : 'Nothing in this filter.', // Selects a value from a conditional expression.
                      style: const TextStyle(
                          // Configures the visual style.
                          fontSize: 17,
                          fontWeight: FontWeight.w900)), // Sets the text size.
                  const SizedBox(height: 6), // Adds fixed spacing or size.
                  Text(
                      // Displays text on the screen.
                      widget.tasks
                              .isEmpty // Accesses data or callbacks passed to this widget.
                          ? 'Add your first task and make it happen.' // Selects a value from a conditional expression.
                          : 'Try another filter to see your tasks.', // Selects a value from a conditional expression.
                      textAlign: TextAlign
                          .center, // Configures the textAlign property for this widget.
                      style: const TextStyle(
                          color: kMuted)), // Configures the visual style.
                  if (widget.tasks.isEmpty) ...[
                    // Checks a condition before continuing.
                    const SizedBox(height: 16), // Adds fixed spacing or size.
                    FilledButton(
                      // Creates a filled action button.
                      onPressed: widget
                          .onAdd, // Defines the action when this button is pressed.
                      style: FilledButton.styleFrom(
                          // Configures the visual style.
                          backgroundColor: kYellow,
                          foregroundColor: kInk), // Sets the background color.
                      child: const Text(
                          'Create a task'), // Sets the widget contained inside this widget.
                    ),
                  ],
                ],
              ),
            )
          else
            ...visible.map((task) => _TaskCard(
                  // Updates the existing list without creating a new one.
                  task: task, // Configures the task property for this widget.
                  onEdit: () => widget
                      .onEdit(task), // Passes the callback for editing a task.
                  onDelete: () => widget.onDelete(
                      task), // Passes the callback for deleting a task.
                  onToggle: (value) => widget.onToggle(task,
                      value), // Passes the callback for changing task completion.
                )),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  // Defines the _ProgressStat widget or data class.
  const _ProgressStat(
      {required this.value,
      required this.label}); // Creates an immutable widget or value.
  final String value; // Declares a value used by this widget or operation.
  final String label; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) => Column(
        // Builds and returns the visible widget layout.
        crossAxisAlignment: CrossAxisAlignment
            .start, // Controls alignment across the main layout direction.
        children: [
          // Defines the widgets displayed inside this layout.
          Text(value, // Displays text on the screen.
              style: const TextStyle(
                  // Configures the visual style.
                  color: Colors.white, // Sets the displayed color.
                  fontSize: 26, // Sets the text size.
                  fontWeight:
                      FontWeight.w900, // Sets the thickness of the text.
                  letterSpacing: -1)), // Sets the spacing between letters.
          const SizedBox(height: 3), // Adds fixed spacing or size.
          Text(label, // Displays text on the screen.
              style: const TextStyle(
                  // Configures the visual style.
                  color: Colors.white60, // Sets the displayed color.
                  fontSize: 9, // Sets the text size.
                  fontWeight:
                      FontWeight.w800, // Sets the thickness of the text.
                  letterSpacing: 0.5)), // Sets the spacing between letters.
        ],
      );
}

class _TaskCard extends StatelessWidget {
  // Defines the _TaskCard widget or data class.
  const _TaskCard(
      // Creates an immutable widget or value.
      {required this.task, // Configures this part of the application logic or interface.
      required this.onEdit, // Requires this parameter when creating the widget.
      required this.onDelete, // Requires this parameter when creating the widget.
      required this.onToggle}); // Requires this parameter when creating the widget.
  final TaskItem task; // Declares a value used by this widget or operation.
  final VoidCallback
      onEdit; // Declares a value used by this widget or operation.
  final VoidCallback
      onDelete; // Declares a value used by this widget or operation.
  final ValueChanged<bool>
      onToggle; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    final done = task.status ==
        TaskStatus
            .completed; // Declares a value used by this widget or operation.
    return Container(
      // Returns the result of this expression.
      margin: const EdgeInsets.only(bottom: 10), // Sets outer spacing.
      padding:
          const EdgeInsets.fromLTRB(12, 10, 6, 10), // Sets internal spacing.
      decoration: BoxDecoration(
          // Configures the widget appearance.
          color: Colors.white, // Sets the displayed color.
          borderRadius: BorderRadius.circular(18), // Sets rounded corners.
          border: Border.all(
              color: const Color(0xFFE9E9E2))), // Sets the border appearance.
      child: Row(
        // Sets the widget contained inside this widget.
        children: [
          // Defines the widgets displayed inside this layout.
          Checkbox(
            // Shows and updates the task completion checkbox.
            value: done, // Sets the current value.
            onChanged: (value) =>
                onToggle(value ?? false), // Handles changes to the input value.
            activeColor:
                kInk, // Configures the activeColor property for this widget.
            shape: // Configures the shape property for this widget.
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        6)), // Configures this part of the application logic or interface.
          ),
          Expanded(
            // Uses available space within a row or column.
            child: InkWell(
              // Sets the widget contained inside this widget.
              onTap: onEdit, // Defines the action when this area is tapped.
              child: Padding(
                // Sets the widget contained inside this widget.
                padding: const EdgeInsets.symmetric(
                    vertical: 8), // Sets internal spacing.
                child: Column(
                  // Sets the widget contained inside this widget.
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Controls alignment across the main layout direction.
                  children: [
                    // Defines the widgets displayed inside this layout.
                    Text(task.title, // Displays text on the screen.
                        style: TextStyle(
                            // Configures the visual style.
                            fontWeight: FontWeight
                                .w800, // Sets the thickness of the text.
                            fontSize: 14, // Sets the text size.
                            decoration: // Configures the widget appearance.
                                done
                                    ? TextDecoration.lineThrough
                                    : null, // Configures this part of the application logic or interface.
                            color: done
                                ? kMuted
                                : kInk)), // Sets the displayed color.
                    const SizedBox(height: 5), // Adds fixed spacing or size.
                    Text(
                        done
                            ? 'COMPLETED'
                            : 'NOT COMPLETED', // Displays text on the screen.
                        style: TextStyle(
                            // Configures the visual style.
                            fontSize: 9, // Sets the text size.
                            letterSpacing:
                                1, // Sets the spacing between letters.
                            fontWeight: FontWeight
                                .w900, // Sets the thickness of the text.
                            color: done
                                ? const Color(0xFF2E7D32)
                                : kMuted)), // Sets the displayed color.
                  ],
                ),
              ),
            ),
          ),
          IconButton(
              // Creates a tappable icon button.
              tooltip:
                  'Edit task', // Configures the tooltip property for this widget.
              onPressed:
                  onEdit, // Defines the action when this button is pressed.
              icon: const Icon(Icons.edit_outlined,
                  size: 19)), // Sets the displayed icon.
          IconButton(
              // Creates a tappable icon button.
              tooltip:
                  'Delete task', // Configures the tooltip property for this widget.
              onPressed:
                  onDelete, // Defines the action when this button is pressed.
              icon: const Icon(
                  Icons.delete_outline_rounded, // Sets the displayed icon.
                  size: 20,
                  color: Color(
                      0xFFB3261E))), // Configures the size property for this widget.
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  // ProfilePage lets the user edit their display name, change their photo, and view stats. Defines the ProfilePage widget or data class.
  const ProfilePage({
    // Creates an immutable widget or value.
    super.key, // Passes the optional widget key to the parent constructor.
    required this.name, // Requires this parameter when creating the widget.
    required this.photoPath, // Requires this parameter when creating the widget.
    required this.total, // Requires this parameter when creating the widget.
    required this.completed, // Requires this parameter when creating the widget.
    required this.pending, // Requires this parameter when creating the widget.
    required this.onSaveName, // Requires this parameter when creating the widget.
    required this.onPickPhoto, // Requires this parameter when creating the widget.
  });
  final String name; // Declares a value used by this widget or operation.
  final String? photoPath; // Declares a value used by this widget or operation.
  final int total; // Declares a value used by this widget or operation.
  final int completed; // Declares a value used by this widget or operation.
  final int pending; // Declares a value used by this widget or operation.
  final Future<void> Function(String)
      onSaveName; // Declares a value used by this widget or operation.
  final Future<void> Function()
      onPickPhoto; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  State<ProfilePage> createState() =>
      _ProfilePageState(); // Creates the state object for this stateful widget.
}

class _ProfilePageState extends State<ProfilePage> {
  // Defines the _ProfilePageState widget or data class.
  late final TextEditingController
      _nameController; // Declares a value used by this widget or operation.
  bool _editing = false; // Stores a true or false state value.

  @override // Overrides a method from the parent class.
  void initState() {
    // Defines a method that performs an action without returning a value.
    super.initState(); // Runs the parent widget initialization.
    _nameController = TextEditingController(
        text: widget
            .name); // Updates or uses the corresponding application state.
  }

  @override // Overrides a method from the parent class.
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    // Defines a method that performs an action without returning a value.
    super.didUpdateWidget(
        oldWidget); // Updates the parent widget when its properties change.
    if (oldWidget.name != widget.name &&
        !_editing) // Checks a condition before continuing.
      _nameController.text =
          widget.name; // Updates or uses the corresponding application state.
  }

  @override // Overrides a method from the parent class.
  void dispose() {
    // Defines a method that performs an action without returning a value.
    _nameController
        .dispose(); // Updates or uses the corresponding application state.
    super.dispose(); // Runs the parent widget cleanup.
  }

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) {
    // Builds and returns the visible widget layout.
    final completion = // Declares a value used by this widget or operation.
        widget.total == 0
            ? 0.0
            : widget.completed /
                widget
                    .total; // Accesses data or callbacks passed to this widget.
    final photoExists = // Declares a value used by this widget or operation.
        widget.photoPath != null &&
            File(widget.photoPath!)
                .existsSync(); // Accesses data or callbacks passed to this widget.
    return SafeArea(
      // Returns the result of this expression.
      child: ListView(
        // Sets the widget contained inside this widget.
        padding:
            const EdgeInsets.fromLTRB(20, 8, 20, 30), // Sets internal spacing.
        children: [
          // Defines the widgets displayed inside this layout.
          const Text('YOUR ACCOUNT', // Displays text on the screen.
              style: TextStyle(
                  // Configures the visual style.
                  color: kMuted, // Sets the displayed color.
                  fontSize: 11, // Sets the text size.
                  fontWeight:
                      FontWeight.w900, // Sets the thickness of the text.
                  letterSpacing: 2)), // Sets the spacing between letters.
          const SizedBox(height: 8), // Adds fixed spacing or size.
          const Text('Profile', // Displays text on the screen.
              style: TextStyle(
                  // Configures the visual style.
                  fontSize: 36, // Sets the text size.
                  fontWeight:
                      FontWeight.w900, // Sets the thickness of the text.
                  letterSpacing: -1.2)), // Sets the spacing between letters.
          const SizedBox(height: 24), // Adds fixed spacing or size.
          Container(
            // Creates a customizable layout box.
            padding: const EdgeInsets.all(22), // Sets internal spacing.
            decoration: BoxDecoration(
                // Configures the widget appearance.
                color: kYellow,
                borderRadius:
                    BorderRadius.circular(26)), // Sets the displayed color.
            child: Column(
              // Sets the widget contained inside this widget.
              children: [
                // Defines the widgets displayed inside this layout.
                Stack(
                  // Layers widgets on top of each other.
                  children: [
                    // Defines the widgets displayed inside this layout.
                    CircleAvatar(
                      // Displays a circular profile image.
                      radius:
                          49, // Configures the radius property for this widget.
                      backgroundColor:
                          Colors.white, // Sets the background color.
                      backgroundImage:
                          photoExists // Configures the backgroundImage property for this widget.
                              ? FileImage(File(widget
                                  .photoPath!)) // Selects a value from a conditional expression.
                              : null, // Selects a value from a conditional expression.
                      child:
                          photoExists // Sets the widget contained inside this widget.
                              ? null // Selects a value from a conditional expression.
                              : const Icon(
                                  Icons
                                      .person_rounded, // Selects a value from a conditional expression.
                                  size: 52,
                                  color:
                                      kInk), // Configures the size property for this widget.
                    ),
                    Positioned(
                      // Positions a widget within a stack.
                      right:
                          0, // Configures the right property for this widget.
                      bottom:
                          0, // Configures the bottom property for this widget.
                      child: Material(
                        // Sets the widget contained inside this widget.
                        color: kInk, // Sets the displayed color.
                        shape:
                            const CircleBorder(), // Configures the shape property for this widget.
                        child: InkWell(
                          // Sets the widget contained inside this widget.
                          customBorder:
                              const CircleBorder(), // Configures the customBorder property for this widget.
                          onTap: widget
                              .onPickPhoto, // Defines the action when this area is tapped.
                          child: const Padding(
                              // Sets the widget contained inside this widget.
                              padding:
                                  EdgeInsets.all(9), // Sets internal spacing.
                              child: Icon(
                                  Icons
                                      .camera_alt_rounded, // Sets the widget contained inside this widget.
                                  color: Colors.white,
                                  size: 18)), // Sets the displayed color.
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Adds fixed spacing or size.
                Text(widget.name, // Displays text on the screen.
                    textAlign: TextAlign
                        .center, // Configures the textAlign property for this widget.
                    style: const TextStyle(
                        // Configures the visual style.
                        fontSize: 23, // Sets the text size.
                        fontWeight:
                            FontWeight.w900, // Sets the thickness of the text.
                        letterSpacing:
                            -0.5)), // Sets the spacing between letters.
                const SizedBox(height: 5), // Adds fixed spacing or size.
                const Text('TASKFLOW MEMBER', // Displays text on the screen.
                    style: TextStyle(
                        // Configures the visual style.
                        fontSize: 10, // Sets the text size.
                        fontWeight:
                            FontWeight.w900, // Sets the thickness of the text.
                        letterSpacing:
                            1.8)), // Sets the spacing between letters.
                const SizedBox(height: 14), // Adds fixed spacing or size.
                OutlinedButton.icon(
                  // Configures this part of the application logic or interface.
                  onPressed: widget
                      .onPickPhoto, // Defines the action when this button is pressed.
                  icon: const Icon(Icons.photo_library_outlined,
                      size: 18), // Sets the displayed icon.
                  label: const Text(
                      'Change photo'), // Sets the label shown to the user.
                  style: OutlinedButton.styleFrom(
                      // Configures the visual style.
                      foregroundColor:
                          kInk, // Sets the foreground or text color.
                      side: const BorderSide(
                          color:
                              kInk), // Configures the side property for this widget.
                      shape: RoundedRectangleBorder(
                          // Configures the shape property for this widget.
                          borderRadius: BorderRadius.circular(
                              14))), // Sets rounded corners.
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Adds fixed spacing or size.
          const Text('Personal details', // Displays text on the screen.
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900)), // Configures the visual style.
          const SizedBox(height: 12), // Adds fixed spacing or size.
          Container(
            // Creates a customizable layout box.
            padding: const EdgeInsets.all(16), // Sets internal spacing.
            decoration: BoxDecoration(
                // Configures the widget appearance.
                color: Colors.white, // Sets the displayed color.
                borderRadius:
                    BorderRadius.circular(20), // Sets rounded corners.
                border: Border.all(
                    color: const Color(
                        0xFFE9E9E2))), // Sets the border appearance.
            child: Column(
              // Sets the widget contained inside this widget.
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Controls alignment across the main layout direction.
              children: [
                // Defines the widgets displayed inside this layout.
                const Text('DISPLAY NAME', // Displays text on the screen.
                    style: TextStyle(
                        // Configures the visual style.
                        fontSize: 10, // Sets the text size.
                        color: kMuted, // Sets the displayed color.
                        fontWeight:
                            FontWeight.w900, // Sets the thickness of the text.
                        letterSpacing:
                            1.3)), // Sets the spacing between letters.
                const SizedBox(height: 9), // Adds fixed spacing or size.
                TextField(
                    // Accepts text entered by the user.
                    controller:
                        _nameController, // Connects the text field to its controller.
                    enabled: _editing, // Enables or disables user input.
                    maxLength: 40, // Limits the number of characters.
                    decoration: const InputDecoration(
                        // Configures the widget appearance.
                        hintText: 'Your name',
                        counterText:
                            '')), // Shows placeholder text in an input.
                const SizedBox(height: 10), // Adds fixed spacing or size.
                SizedBox(
                  // Adds fixed spacing or size.
                  width: double.infinity, // Sets the widget width.
                  child: FilledButton(
                    // Sets the widget contained inside this widget.
                    onPressed: () async {
                      // Defines the action when this button is pressed.
                      if (_editing) {
                        // Checks a condition before continuing.
                        if (_nameController.text.trim().isEmpty) {
                          // Checks a condition before continuing.
                          ScaffoldMessenger.of(context).showSnackBar(
                              // Shows a temporary message at the bottom of the screen.
                              const SnackBar(
                                  // Creates an immutable widget or value.
                                  content: Text(
                                      'Name cannot be empty'))); // Configures the content property for this widget.
                          return; // Configures this part of the application logic or interface.
                        }
                        await widget.onSaveName(_nameController
                            .text); // Waits for this asynchronous operation to finish.
                        if (mounted)
                          setState(() => _editing =
                              false); // Checks a condition before continuing.
                      } else {
                        // Configures this part of the application logic or interface.
                        setState(() => _editing =
                            true); // Updates state and rebuilds the affected UI.
                      }
                    },
                    style: FilledButton.styleFrom(
                        // Configures the visual style.
                        backgroundColor: kInk, // Sets the background color.
                        foregroundColor:
                            Colors.white, // Sets the foreground or text color.
                        padding: const EdgeInsets.symmetric(
                            vertical: 14)), // Sets internal spacing.
                    child: Text(
                        _editing
                            ? 'Save changes'
                            : 'Edit name', // Sets the widget contained inside this widget.
                        style: const TextStyle(
                            fontWeight: FontWeight
                                .w800)), // Configures the visual style.
                  ),
                ),
                if (_editing) // Checks a condition before continuing.
                  Center(
                      // Centers its child widget.
                      child: TextButton(
                          // Sets the widget contained inside this widget.
                          onPressed: () {
                            // Defines the action when this button is pressed.
                            setState(() {
                              // Updates state and rebuilds the affected UI.
                              _editing =
                                  false; // Updates or uses the corresponding application state.
                              _nameController.text = widget
                                  .name; // Updates or uses the corresponding application state.
                            });
                          },
                          child: const Text(
                              'Cancel'))), // Sets the widget contained inside this widget.
              ],
            ),
          ),
          const SizedBox(height: 24), // Adds fixed spacing or size.
          const Text('Task statistics', // Displays text on the screen.
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900)), // Configures the visual style.
          const SizedBox(height: 12), // Adds fixed spacing or size.
          Row(
            // Arranges child widgets horizontally.
            children: [
              // Defines the widgets displayed inside this layout.
              Expanded(
                  // Uses available space within a row or column.
                  child: _ProfileStat(
                      // Sets the widget contained inside this widget.
                      value: '${widget.total}', // Sets the current value.
                      label: 'TOTAL', // Sets the label shown to the user.
                      icon:
                          Icons.list_alt_rounded)), // Sets the displayed icon.
              const SizedBox(width: 10), // Adds fixed spacing or size.
              Expanded(
                  // Uses available space within a row or column.
                  child: _ProfileStat(
                      // Sets the widget contained inside this widget.
                      value: '${widget.completed}', // Sets the current value.
                      label: 'COMPLETED', // Sets the label shown to the user.
                      icon: Icons
                          .check_circle_outline_rounded)), // Sets the displayed icon.
              const SizedBox(width: 10), // Adds fixed spacing or size.
              Expanded(
                  // Uses available space within a row or column.
                  child: _ProfileStat(
                      // Sets the widget contained inside this widget.
                      value: '${widget.pending}', // Sets the current value.
                      label: 'PENDING', // Sets the label shown to the user.
                      icon: Icons
                          .pending_actions_rounded)), // Sets the displayed icon.
            ],
          ),
          const SizedBox(height: 18), // Adds fixed spacing or size.
          Container(
            // Creates a customizable layout box.
            padding: const EdgeInsets.all(18), // Sets internal spacing.
            decoration: BoxDecoration(
                // Configures the widget appearance.
                color: Colors.white, // Sets the displayed color.
                borderRadius:
                    BorderRadius.circular(20), // Sets rounded corners.
                border: Border.all(
                    color: const Color(
                        0xFFE9E9E2))), // Sets the border appearance.
            child: Column(
              // Sets the widget contained inside this widget.
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Controls alignment across the main layout direction.
              children: [
                // Defines the widgets displayed inside this layout.
                Row(children: [
                  // Arranges child widgets horizontally.
                  const Expanded(
                      // Uses available space within a row or column.
                      child: Text(
                          'Completion rate', // Sets the widget contained inside this widget.
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w800))), // Configures the visual style.
                  Text(
                      '${(completion * 100).round()}%', // Displays text on the screen.
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.w900)), // Configures the visual style.
                ]),
                const SizedBox(height: 12), // Adds fixed spacing or size.
                ClipRRect(
                  // Clips content using rounded corners.
                  borderRadius:
                      BorderRadius.circular(8), // Sets rounded corners.
                  child: LinearProgressIndicator(
                      // Sets the widget contained inside this widget.
                      value: completion, // Sets the current value.
                      minHeight:
                          9, // Configures the minHeight property for this widget.
                      backgroundColor:
                          const Color(0xFFEFEFE9), // Sets the background color.
                      valueColor: const AlwaysStoppedAnimation(
                          kYellow)), // Configures the valueColor property for this widget.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  // Defines the _ProfileStat widget or data class.
  const _ProfileStat(
      // Creates an immutable widget or value.
      {required this.value,
      required this.label,
      required this.icon}); // Configures this part of the application logic or interface.
  final String value; // Declares a value used by this widget or operation.
  final String label; // Declares a value used by this widget or operation.
  final IconData icon; // Declares a value used by this widget or operation.

  @override // Overrides a method from the parent class.
  Widget build(BuildContext context) => Container(
        // Builds and returns the visible widget layout.
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 8), // Sets internal spacing.
        decoration: BoxDecoration(
            // Configures the widget appearance.
            color: Colors.white, // Sets the displayed color.
            borderRadius: BorderRadius.circular(18), // Sets rounded corners.
            border: Border.all(
                color: const Color(0xFFE9E9E2))), // Sets the border appearance.
        child: Column(
          // Sets the widget contained inside this widget.
          children: [
            // Defines the widgets displayed inside this layout.
            Icon(icon, size: 21, color: kInk), // Displays an icon.
            const SizedBox(height: 9), // Adds fixed spacing or size.
            Text(value, // Displays text on the screen.
                style: // Configures the visual style.
                    const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight
                            .w900)), // Sets text appearance and formatting.
            const SizedBox(height: 4), // Adds fixed spacing or size.
            Text(label, // Displays text on the screen.
                textAlign: TextAlign
                    .center, // Configures the textAlign property for this widget.
                style: const TextStyle(
                    // Configures the visual style.
                    fontSize: 8, // Sets the text size.
                    letterSpacing: 0.7, // Sets the spacing between letters.
                    color: kMuted, // Sets the displayed color.
                    fontWeight:
                        FontWeight.w900)), // Sets the thickness of the text.
          ],
        ),
      );
}
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../widgets/task_list.dart';
import '../services/voice_recognition_service.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceRecognitionService _voiceRecognitionService = VoiceRecognitionService();
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _voiceRecognitionService.initialize();
    Provider.of<TasksProvider>(context, listen: false).fetchTasks();
  }

  Future<void> handleVoiceInput() async {
    String command = await _voiceRecognitionService.listen();
    if (command.isNotEmpty) {
      Task newTask = Task(id: DateTime.now().toString(), title: command);
      Provider.of<TasksProvider>(context, listen: false).addTask(newTask);
      await flutterTts.speak('Task added: $command');
    }
    _voiceRecognitionService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice-Driven To-Do List')),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: handleVoiceInput,
        child: Icon(Icons.mic),
      ),
    );
  }
}

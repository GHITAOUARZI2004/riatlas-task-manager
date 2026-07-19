import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final response = _generateResponse(text);
      setState(() {
        _messages.add({'role': 'ai', 'text': response});
        _isTyping = false;
      });
    });
  }

  String _generateResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! I\'m your RiAtlas AI assistant. How can I help you today?';
    }
    if (lower.contains('task') || lower.contains('todo')) {
      return 'I can help you organize your tasks! Try breaking large tasks into smaller subtasks, and prioritize by urgency.';
    }
    if (lower.contains('productivity') || lower.contains('focus')) {
      return 'For better productivity: 1) Use the Pomodoro technique (25 min work, 5 min break), 2) Tackle high-priority tasks first, 3) Limit distractions.';
    }
    if (lower.contains('motivation') || lower.contains('tired')) {
      return 'Remember: progress, not perfection. Even completing one small task is a win. You\'ve got this! 💪';
    }
    return 'That\'s interesting! I\'m here to help with task management, productivity tips, and motivation. What would you like to explore?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.amber, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('AI Assistant'),
          ],
        ),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20).copyWith(
                              bottomRight: isUser ? const Radius.circular(4) : null,
                              bottomLeft: !isUser ? const Radius.circular(4) : null,
                            ),
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(0),
                        const SizedBox(width: 4),
                        _buildDot(1),
                        const SizedBox(width: 4),
                        _buildDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, size: 48, color: AppColors.amber),
          ),
          const SizedBox(height: 20),
          const Text(
            'RiAtlas AI',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ask me about productivity, task management, or just say hello!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
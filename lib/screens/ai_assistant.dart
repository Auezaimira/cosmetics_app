import 'package:cosmetics_app/network/api_service.dart';
import 'package:flutter/material.dart';

class AIConsultantPage extends StatefulWidget {
  const AIConsultantPage({super.key});

  @override
  State<AIConsultantPage> createState() => _AIConsultantPageState();
}

class _AIConsultantPageState extends State<AIConsultantPage> {
  static const mainColor = Color(0xFFF48FB1);
  final apiService = ApiService();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {
      'text':
          'Здравствуйте! Я рад помочь вам с профессиональными советами по уходу за телом.',
      'isUserMessage': false
    }
  ];
  bool isAwaitingResponse = false;

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();
    setState(() {
      isAwaitingResponse = true;
      messages.insert(0, {'text': text, 'isUserMessage': true});
    });

    try {
      final response = await apiService.getResponse(text);
      setState(() {
        isAwaitingResponse = false;
        messages.insert(0, {'text': response, 'isUserMessage': false});
      });
    } catch (e) {
      setState(() {
        isAwaitingResponse = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title:
            const Text('AI Consultant', style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isUserMessage = message['isUserMessage'];
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.purple[300] : Colors.pink[200],
                      borderRadius: isUserMessage
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                    ),
                    child: Text(
                      message['text'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isAwaitingResponse)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Assistant is typing...",
                  ),
                ],
              ),
            ),
          const Divider(
            height: 1,
            thickness: 0,
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      color: mainColor,
      child: SafeArea(
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.primary),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Send a message',
                        hintStyle: TextStyle(color: Colors.white70)),
                    enabled: !isAwaitingResponse,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: isAwaitingResponse
                        ? null
                        : () => _handleSubmitted(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

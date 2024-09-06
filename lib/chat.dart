import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessageListScreen(),
    );
  }
}

class MessageListScreen extends StatelessWidget {
  static const String id = 'chat_screen';

  final List<Message> messages = [
    Message(
      firstName: 'John',
      lastName: 'Doe',
      imageUrl: 'https://via.placeholder.com/150',
      message: 'Hello, how are you?',
    ),
    Message(
      firstName: 'Jane',
      lastName: 'Smith',
      imageUrl: 'https://via.placeholder.com/150',
      message: 'Hi! Long time no see.',
    ),
    Message(
      firstName: 'Alex',
      lastName: 'Johnson',
      imageUrl: 'https://via.placeholder.com/150',
      message: 'Are we still on for lunch?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(message.imageUrl),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text('${message.firstName} ${message.lastName}'),
                    subtitle: Text(message.message),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConversationScreen(client: message),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  final Message client;

  ConversationScreen({required this.client});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<MessageBubble> conversation = [
    MessageBubble(text: 'Salut, comment ça va ?', isSentByMe: false),
    MessageBubble(text: 'Ça va bien, merci. Et toi ?', isSentByMe: true),
    // Ajoutez d'autres messages ici
  ];

  final TextEditingController _controller = TextEditingController();
  bool _showOptions = false;
  final ImagePicker _picker = ImagePicker();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        conversation
            .add(MessageBubble(text: _controller.text, isSentByMe: true));
        _controller.clear();
      });
    }
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
    });
  }

  void _sendLocation() {
    setState(() {
      conversation.add(MessageBubble(
          text: 'Localisation: 48.8566, 2.3522', isSentByMe: true));
      _showOptions = false;
    });
  }

  Future<void> _addImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        conversation.add(
            MessageBubble(text: 'Image: ${pickedFile.path}', isSentByMe: true));
        _showOptions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.client.firstName} ${widget.client.lastName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                final bubble = conversation[index];
                return bubble;
              },
            ),
          ),
          if (_showOptions)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: InkWell(
                      onTap: _sendLocation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            Text('Envoyer votre localisation'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Card(
                    child: InkWell(
                      onTap: _addImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.image, color: Colors.blue),
                            Text('Ajouter une image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _toggleOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Tapez un message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String message;

  Message({
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.message,
  });
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSentByMe;

  MessageBubble({required this.text, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    bool isImage = text.startsWith('Image:');
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: isImage
            ? Image.file(
                File(text.replaceFirst('Image: ', '')),
                width: 222, // Largeur de l'image
                height: 222, // Hauteur de l'image
                fit: BoxFit
                    .cover, // Ajustement de l'image pour remplir le conteneur
              )
            : Text(
                text,
                style: TextStyle(
                  color: isSentByMe ? Colors.white : Colors.black,
                ),
              ),
      ),
    );
  }
}

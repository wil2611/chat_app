import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late String remoteUserUid;
  late String remoteEmail;
  dynamic argumentData = Get.arguments;

  ChatController chatController = Get.find();
  AuthenticationController authenticationController = Get.find();

  @override
  void initState() {
    super.initState();
    remoteUserUid = argumentData[0];
    remoteEmail = argumentData[1];

    _controller = TextEditingController();
    _scrollController = ScrollController();

    chatController.subscribeToUpdated(remoteUserUid);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    chatController.unsubscribe();
    super.dispose();
  }

  Widget _item(Message element, int position, String uid) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: uid == element.senderUid
          ? const Color.fromARGB(255, 99, 82, 62)
          : const Color.fromARGB(255, 46, 57, 63),
      child: ListTile(
        title: Text(
          element.msg,
          style: const TextStyle(color: Colors.white),
          textAlign:
              uid == element.senderUid ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _list() {
    String uid = authenticationController.getUid();
    logInfo('Current user $uid');
    return GetX<ChatController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      return ListView.builder(
        itemCount: chatController.messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var element = chatController.messages[index];
          return _item(element, index, uid);
        },
      );
    });
  }

  Future<void> _sendMsg(String text) async {
    logInfo("Calling _sendMsg with $text");
    await chatController.sendChat(remoteUserUid, text);
  }

  Widget _textInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: _buildTextField(
                labelText: 'Your message',
                controller: _controller,
                keyboardType: TextInputType.text,
                icon: Icons.message,
              ),
            ),
          ),
          IconButton(
            key: const Key('sendButton'),
            icon: const Icon(Icons.send),
            color: Colors.white,
            onPressed: () {
              if (_controller.text.isEmpty) return;
              _sendMsg(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool obscureText = false,
    required IconData icon,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD9A76A), width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0417),
        title: Text(
          "Chat with $remoteEmail",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0417),
              Color.fromARGB(255, 29, 9, 2),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: _list(),
            ),
            _textInput(),
          ],
        ),
      ),
    );
  }
}

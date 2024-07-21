
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class TravelDealsPage extends StatefulWidget {
  @override
  _TravelDealsPageState createState() => _TravelDealsPageState();
}

class _TravelDealsPageState extends State<TravelDealsPage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "user");
  ChatUser geminiuser = ChatUser(
    id: "1",
    firstName: "bot",
    profileImage:
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fbot&psig=AOvVaw3ppJL5HzeH49i2f7MTg4k7&ust=1715005112756000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKi5i4ra9oUDFQAAAAAdAAAAABAE",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Travel Deals'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(
              Icons.image,
            ),
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(
      () {
        messages = [
          chatMessage,
          ...messages,
        ]; // adding chatMessage to the beginning of the messages list and assigning the resulting list back to messages.
        try {
          String question = chatMessage.text;
          List<Uint8List>? images;
          if (chatMessage.medias?.isNotEmpty ?? false) {
            images = [
              File(chatMessage.medias!.first.url).readAsBytesSync(),
            ];
          }
          gemini
              .streamGenerateContent(
            question,
            images: images,
          )
              .listen((event) {
            ChatMessage? lastMessage = messages.firstOrNull;
            if (lastMessage != null && lastMessage.user == geminiuser) {
              lastMessage = messages.removeAt(0);
              String response = event.content?.parts?.fold(
                      "", (previous, current) => "$previous ${current.text}") ??
                  "";
              lastMessage.text += response;
              setState(() {
                messages = [
                  lastMessage!,
                  ...messages,
                ]; // adding chatMessage to the beginning of the messages list and assigning the resulting list back to messages.
              });
            } else {
              String response = event.content?.parts?.fold(
                      "", (previous, current) => "$previous ${current.text}") ??
                  "";

              ChatMessage message = ChatMessage(
                user: geminiuser,
                createdAt: DateTime.now(),
                text: response,
              );
              setState(() {
                messages = [
                  message,
                  ...messages,
                ]; // adding chatMessage to the beginning of the messages list and assigning the resulting list back to messages.
              });
            }
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "describe this picture ?",
        medias: [
          ChatMedia(url: file.path, type: MediaType.image, fileName: "")
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
import 'dart:async';

import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

import '../services/navigation_service.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messageStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessage();
    listenToKeyboardChange();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  void listenToMessage() {
    try {
      _messageStream = _db.streamMessageForChat(_chatId).listen((_snapshot) {
        List<ChatMessage> _messages = _snapshot.docs.map((_m) {
          Map<String, dynamic> _messageData = _m.data() as Map<String, dynamic>;
          return ChatMessage.fromJson(_messageData);
        }).toList();
        messages = _messages;
        notifyListeners();
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (_messagesListViewController.hasClients) {
            _messagesListViewController
                .jumpTo(_messagesListViewController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print('Error getting messages.');
      print(e);
    }
  }

  void listenToKeyboardChange() {
    _keyboardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(
        _chatId,
        {"is_activity": _event},
      );
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
          senderID: _auth.user.uid,
          type: MessageType.TEXT,
          content: _message!,
          sentTime: DateTime.now());
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _doumloadUrl = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
            senderID: _auth.user.uid,
            type: MessageType.IMAGE,
            content: _doumloadUrl!,
            sentTime: DateTime.now());
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print('Error sending image messages.');
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}

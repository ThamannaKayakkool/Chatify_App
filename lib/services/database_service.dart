import 'package:chatify_app/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(String _uid, String _email, String _name,
      String _imageUrl) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          'email': _email,
          'name': _name,
          'last_active': DateTime.now().toUtc(),
          'image': _imageUrl,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(USER_COLLECTION);
    if (name != null) {
      _query = _query.where("name", isGreaterThanOrEqualTo: name).where(
          "name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }


  Stream<QuerySnapshot> getChatsForUset(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatId) async {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessageForChat(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatId, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGE_COLLECTION)
          .add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String _chatId,
      Map<String, dynamic> _data) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLatSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print(e);
    }
  }
  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async{
  try {
  DocumentReference _chat=await _db.collection(CHAT_COLLECTION).add(_data);
  return _chat;
  } catch (e) {
  print(e);
  }
  }
}

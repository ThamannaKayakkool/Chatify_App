import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/pages/chat_page.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;
  late NavigationService _navigation;
  List<ChatUser>? users;
  late List<ChatUser> _selectUsers;

  List<ChatUser> get selectUsers {
    return _selectUsers;
  }

  UsersPageProvider(this._auth) {
    _selectUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectUsers = [];
    try {
      _db.getUsers(name: name).then((_snapshot) {
        users = _snapshot.docs.map(
          (_doc) {
            Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
            _data['uid'] = _doc.id;
            return ChatUser.fromJson(_data);
          },
        ).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }

  void updateSelectedUser(ChatUser _user) {
    if (_selectUsers.contains(_user)) {
      _selectUsers.remove(_user);
    } else {
      _selectUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _memberId = _selectUsers.map((_user) => _user.uid).toList();
      _memberId.add(_auth.user.uid);
      bool _isGroup = _selectUsers.length > 1;
      DocumentReference? _doc = await _db.createChat(
          {"is_group": _isGroup, "is_activity": false, "members": _memberId});
      List<ChatUser> _members = [];
      for (var _uid in _memberId) {
        DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(ChatUser.fromJson(_userData));
      }
      ChatPage _chatPage = ChatPage(
          chat: Chat(
              uid: _doc!.id,
              currentUserUid: _auth.user.uid,
              activity: false,
              group: _isGroup,
              members: _members,
              messages: []));
      _selectUsers=[];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
    } catch (e) {
      print("Error creating chats.");
      print(e);
    }
  }
}

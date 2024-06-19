import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  final List<ChatMessage> messages;
  late final List<ChatUser> _recepients;

  Chat(
      {required this.uid,
      required this.currentUserUid,
      required this.activity,
      required this.group,
      required this.members,
      required this.messages}) {
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients
            .map(
              (_user) => _user.name,
            )
            .join(",");
  }

  String imageUrl() {
    return !group
        ? _recepients.first.imageUrl
        : "https://cdn.vectorstock.com/i/500p/70/00/abstract-logo-letter-t-design-vector-40897000.jpg";
  }
}

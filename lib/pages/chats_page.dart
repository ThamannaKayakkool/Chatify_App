import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/pages/chat_page.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/provider/chats_page_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_list_view_title.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatsPageProvider>(
        create: (BuildContext context) => ChatsPageProvider(_auth),
      )
    ], child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  )),
            ),
            _chatList(),
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _chats = _pageProvider.chats;
    return Expanded(child: (() {
      if (_chats != null) {
        if (_chats.length != 0) {
          return ListView.builder(
            itemBuilder: (BuildContext _context, int _index) {
              return _chatTile(_chats[_index]);
            }, itemCount: _chats.length,);
        } else {
          return const Text(
            'No Chats Found.', style: TextStyle(color: Colors.white),);
        }
      }
      else {
        return const Center(
            child: CircularProgressIndicator(color: Colors.white,));
      }
    })());
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subTitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subTitleText =
      _chat.messages.first.type != MessageType.TEXT ? "Media Attachment" : _chat
          .messages.first.content;
    }
    return CustomListViewTitleWithActivity(
        height: _deviceHeight * 0.10,
        title: _chat.title(),
        subtitle: _subTitleText,
        imagePath: _chat.imageUrl(),
        isActive: _isActive,
        isActivity: _chat.activity,
        onTap: () {
          _navigation.navigateToPage(ChatPage(chat: _chat));

        });
  }
}

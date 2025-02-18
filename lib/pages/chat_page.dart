import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/provider/chat_page_provider.dart';
import 'package:chatify_app/widgets/custom_input_field.dart';
import 'package:chatify_app/widgets/custom_list_view_title.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../services/navigation_service.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;
  late ChatPageProvider _pageProvider;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatPageProvider>(
        create: (BuildContext context) => ChatPageProvider(
          widget.chat.uid,
          _auth,
          _messagesListViewController,
        ),
      )
    ], child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopBar(
                  widget.chat.title(),
                  fontSize: 10,
                  primaryAction: IconButton(
                    onPressed: () {
                      _pageProvider.deleteChat();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                  secondaryAction: IconButton(
                    onPressed: () {
                      _pageProvider.goBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                ),
                _messageListView(),
                _sendMessageForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messageListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _pageProvider.messages![_index];
              bool _isOwnMessage = _message.senderID == _auth.user.uid;
              return Container(
                  child: CustomChatListViewTitle(
                      width: _deviceWidth * 0.80,
                      deviceHeight: _deviceHeight,
                      isOwnMessage: _isOwnMessage,
                      message: _message,
                      sender: this
                          .widget
                          .chat
                          .members
                          .where((_m) => _m.uid == _message.senderID)
                          .first));
            },
            itemCount: _pageProvider.messages!.length,
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 29, 37, 1.0),
          borderRadius: BorderRadius.circular(
            100,
          )),
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.04, vertical: _deviceHeight * 0.03),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
          onSaved: (value) {
            setState(() {
              _pageProvider.message = value;
            });
          },
          regEx: r"^(?!\s*$).+",
          hintText: "Type a message",
          obscureText: false),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
          onPressed: () {
            if(_messageFormState.currentState!.validate()){
              _messageFormState.currentState!.save();
              _pageProvider.sendTextMessage();
              _messageFormState.currentState!.reset();
            }
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: (){
          _pageProvider.sendImageMessage();
          if(_messageFormState.currentState!.validate()){
            _messageFormState.currentState!.save();
            _messageFormState.currentState!.reset();
          }
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}

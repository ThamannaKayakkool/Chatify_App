import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/pages/chat_page.dart';
import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/provider/chats_page_provider.dart';
import 'package:chatify_app/provider/users_page_provider.dart';
import 'package:chatify_app/widgets/custom_input_field.dart';
import 'package:chatify_app/widgets/custom_list_view_title.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  final TextEditingController _searchFieldTextEditingController =
  TextEditingController();
  late UsersPageProvider _pageProvider;

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersPageProvider>(
            create: (BuildContext context) => UsersPageProvider(_auth),
          )
        ],
        child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(
        builder: (BuildContext _context) {
          _pageProvider = _context.watch<UsersPageProvider>();
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02),
            height: _deviceHeight * 0.98,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopBar(
                  'Users',
                  primaryAction: IconButton(
                      onPressed: () {
                        _auth.logout();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      )),
                ),
                CustomTextField(
                  onEditingComplete: (value) {
                    _pageProvider.getUsers(name: value);
                    FocusScope.of(context).unfocus();
                  },
                  controller: _searchFieldTextEditingController,
                  hintText: "Search..",
                  obscureText: false,
                  icon: Icons.search,
                ),
                _userList(),
                _createChatButton()
              ],
            ),
          );
        }
    );
  }

  Widget _userList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: (() {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTitle(
                  height: _deviceHeight * 0.10,
                  title: _users[_index].name,
                  subtitle: "Lat Active : ${_users[_index].lastDayActive()} ",
                  imagePath: _users[_index].imageUrl,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected: _pageProvider.selectUsers.contains(
                      _users[_index]),
                  onTap: () {
                    _pageProvider.updateSelectedUser(_users[_index]);
                  });
            },
            itemCount: _users.length,
          );
        } else {
          return const Text(
            'No Users Found.',
            style: TextStyle(color: Colors.white),
          );
        }
      } else {
        return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ));
      }
    })());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectUsers.isNotEmpty,
      child: RoundedButton(
          name: _pageProvider.selectUsers.length == 1 ? "Chat With ${_pageProvider
              .selectUsers.first.name}":"Create Group Chat",
          height: _deviceHeight * 0.08,
          width: _deviceWidth * 0.80,
          onPressed: (){
            _pageProvider.createChat();
          }),
    );
  }

}

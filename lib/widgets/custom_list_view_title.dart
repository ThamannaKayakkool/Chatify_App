import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/widgets/message_bubbles.dart';
import 'package:chatify_app/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListViewTitle extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomListViewTitle(
      {super.key,
      required this.height,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.isActive,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        minVerticalPadding: height * 0.20,
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
        leading: RoundedImageNetworkWithStatusIndicator(
          key: UniqueKey(),
          size: height / 2,
          imagePath: imagePath,
          isActive: isActive,
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
              color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w400),
        ));
    ;
  }
}

class CustomListViewTitleWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final VoidCallback onTap;

  const CustomListViewTitleWithActivity(
      {super.key,
      required this.height,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.isActive,
      required this.isActivity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        minVerticalPadding: height * 0.20,
        leading: RoundedImageNetworkWithStatusIndicator(
          key: UniqueKey(),
          size: height / 2,
          imagePath: imagePath,
          isActive: isActive,
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: isActivity
            ? Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SpinKitThreeBounce(
                    color: Colors.white54,
                    size: height * 0.10,
                  )
                ],
              )
            : Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ));
  }
}

class CustomChatListViewTitle extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  const CustomChatListViewTitle(
      {super.key,
      required this.width,
      required this.deviceHeight,
      required this.isOwnMessage,
      required this.message,
      required this.sender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  imagePath: sender.imageUrl,
                  size: width * 0.08,
                  key: UniqueKey(),
                )
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubbles(
                  width: width,
                  height: deviceHeight * 0.06,
                  isOwnMessage: isOwnMessage,
                  message: message)
              : ImageMessageBubbles(
                  width: width * 0.55,
                  height: deviceHeight * 0.30,
                  isOwnMessage: isOwnMessage,
                  message: message),
        ],
      ),
    );
  }
}

import 'package:chatify_app/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessageBubbles extends StatelessWidget {
  final double width;
  final double height;
  final bool isOwnMessage;
  final ChatMessage message;

  const TextMessageBubbles(
      {super.key,
      required this.width,
      required this.height,
      required this.isOwnMessage,
      required this.message});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            const Color.fromRGBO(0, 136, 249, 1.0),
            const Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];
    return Container(
      height: height + (message.content.length) / 20 * 6.0,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: const [0.30, 0.70],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}

class ImageMessageBubbles extends StatelessWidget {
  final double width;
  final double height;
  final bool isOwnMessage;
  final ChatMessage message;

  const ImageMessageBubbles(
      {super.key,
      required this.width,
      required this.height,
      required this.isOwnMessage,
      required this.message});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            const Color.fromRGBO(0, 136, 249, 1.0),
            const Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];
    DecorationImage _image = DecorationImage(
        image: NetworkImage(message.content), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: const [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
   Container(
     height: height,
     width: width,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(15),
       image: _image
     ),
   ),
          SizedBox(height: height * 0.02,),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}

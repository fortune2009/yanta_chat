import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:yanta/commons/space.dart';
import 'package:yanta/commons/utils.dart';
import 'package:yanta/getIt.dart';
import 'package:yanta/model/core/all_conversation_model.dart';
import 'package:yanta/view_model/chat_vm.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatData});
  final MessageData chatData;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AfterLayoutMixin {
  final provider = getIt<ChatViewModel>();

  @override
  void initState() {
    super.initState();
    // final provider = getIt<ChatViewModel>();
    // final provider = Provider.of<ChatViewModel>(context);
    provider.setChatId(widget.chatData.id!);
    provider.loadMessages(widget.chatData);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // provider.loadMessages(widget.chatData);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Styles.semiBoldTextStyle(
            widget.chatData.topic ?? widget.chatData.members!.first),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.video_call_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          const WSpace(12),
        ],
      ),
      body: Theme(
        data: ThemeData(),
        child: Chat(
          messages: provider.messages,
          onAttachmentPressed: () {
            provider.handleAttachmentPressed(context);
            setState(() {});
          },
          onMessageTap: provider.handleMessageTap,
          onPreviewDataFetched: (x, y) {
            provider.handlePreviewDataFetched(x, y);
            setState(() {});
          },
          onSendPressed: (v) {
            provider.handleSendPressed(v);
            provider.listening();
            // provider.messages.add(provider.response[0]);
            setState(() {});
          },
          showUserAvatars: true,
          showUserNames: true,
          user: provider.user,
          theme: DefaultChatTheme(
            seenIcon: Styles.regularTextStyle(
              'read',
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}

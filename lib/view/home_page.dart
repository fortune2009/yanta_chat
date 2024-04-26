import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:yanta/commons/utils.dart';
import 'package:yanta/getIt.dart';
import 'package:yanta/model/core/all_conversation_model.dart';
import 'package:yanta/model/glitch/no_internet_glitch.dart';
import 'package:yanta/view/chat.dart';
import 'package:yanta/view/theme_setting.dart';
import 'package:yanta/view/widgets/conversation_tile.dart';
import 'package:yanta/view/widgets/error_tile.dart';
import 'package:yanta/view_model/conversations_vm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin {
  final provider = getIt<ConversationsViewModel>();
  List<Widget> failedConversations = [];
  List<Widget> conversations = [];
  List<MessageData>? messages;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    provider.getConversations();

    provider.yantaStream.listen((snapshot) {
      snapshot.fold((l) {
        if (l is NoInternetGlitch) {
          Color randomColor = Color.fromRGBO(Random().nextInt(255),
              Random().nextInt(255), Random().nextInt(255), 1);
          failedConversations
              .add(YantaErrorTile(randomColor, "Unable to Connect"));
        }
      },
          (r) => {
                messages = r.data!,
                for (var msg in messages!)
                  {
                    conversations.add(GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    chatData: msg,
                                  ))),
                      child: ChatTile(
                        topic: msg.topic ?? msg.members!.first,
                        lastMessage: msg.lastMessage!,
                        timestamp: msg.modifiedAt!,
                      ),
                    ))
                  },
                setState(() {}),
              });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Styles.largeBoldTextStyle(
            "Yanta",
          ),
        ),
        leadingWidth: deviceWidth(context) / 2,
        actions: [
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme_settings') {
                // Navigate to theme settings page or show settings dialog
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ThemeSettings()));
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'theme_settings',
                child: Text('Theme Settings'),
              ),
            ],
          ),
        ],
      ),
      body: messages == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: failedConversations.isNotEmpty
                  ? failedConversations
                  : conversations,
            ),
    );
  }
}

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:yanta/model/core/all_conversation_model.dart';
import 'package:yanta/model/glitch/glitch.dart';
import 'package:yanta/model/helper/yanta_helper.dart';

class ConversationsViewModel extends ChangeNotifier {
  final _helper = YantaHelper();
  List<MessageData>? messages;
  final _streamController =
      StreamController<Either<Glitch, AllConversationModel>>();
  Stream<Either<Glitch, AllConversationModel>> get yantaStream {
    return _streamController.stream;
  }

  Future<void> getConversations() async {
    // for (int i = 0; i < 20; i++) {
    final chat = await _helper.getAllConversation();
    _streamController.add(chat);
    // }
  }
}

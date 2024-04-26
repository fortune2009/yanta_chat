import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:yanta/model/Service/yanta_api_service.dart';
import 'package:yanta/model/core/all_conversation_model.dart';
import 'package:yanta/model/core/conversation_model.dart';
import 'package:yanta/model/glitch/glitch.dart';
import 'package:yanta/model/glitch/no_internet_glitch.dart';

class YantaHelper {
  final api = YantaApi();
  Future<Either<Glitch, AllConversationModel>> getAllConversation() async {
    final apiResult = await api
        .getApi("/api/v1/chat_room/")
        .timeout(const Duration(seconds: 30));
    return apiResult.fold((l) {
      // There can be many types of error but, for simplicity, we are going
      // to assume only NoInternetGlitch
      debugPrint("See helper error $l");
      return Left(NoInternetGlitch());
    }, (r) {
      // the API returns breed, id, url, width, height, category, details etc
      // but we will take only the information we need in our app and ignore
      // the rest
      // here we will decode API result to CatPhoto
      debugPrint("See helper result $r");
      final chats = AllConversationModel.fromJson(jsonDecode(r));
      return Right(chats);
    });
  }

  Future<Either<Glitch, ConversationModel>> getChat(int chatId) async {
    final apiResult = await api
        .getApi("/api/v1/chat_room/$chatId")
        .timeout(const Duration(seconds: 30));
    return apiResult.fold((l) {
      debugPrint("See getChat error $l");
      return Left(NoInternetGlitch());
    }, (r) {
      debugPrint("See getChat result $r");
      final chat = ConversationModel.fromJson(jsonDecode(r));
      return Right(chat);
    });
  }
}

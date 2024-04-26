import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yanta/model/core/all_conversation_model.dart';
import 'package:yanta/model/core/conversation_model.dart';
import 'package:yanta/model/glitch/glitch.dart';
import 'package:yanta/model/glitch/no_internet_glitch.dart';
import 'package:yanta/model/helper/yanta_helper.dart';

class ChatViewModel extends ChangeNotifier {
  final _helper = YantaHelper();
  List<types.Message> messages = [];
  List<types.Message> response = [];
  late types.User user;
  // = const types.User(id: "82091008-a484-4a89-ae75-a22bf8d6f3ac");
  int? chatId;

  setChatId(int id) {
    chatId = id;
    user = types.User(id: "$id");
    notifyListeners();
  }

  final _streamController =
      StreamController<Either<Glitch, ConversationModel>>.broadcast();
  Stream<Either<Glitch, ConversationModel>> get yantaStream {
    return _streamController.stream;
  }

  // Future<void> getConversationReply(int chatId) async {
  //   final chat = await _helper.getChat(chatId);
  //   _streamController.add(chat);
  // }

  Future<void> getConversationResponse(int chatId) async {
    final chat = await _helper.getChat(chatId);
    _streamController.add(chat);
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
    notifyListeners();
  }

  void handleAttachmentPressed(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection();
                  notifyListeners();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleFileSelection();
                  notifyListeners();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      addMessage(message);
    }
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);
      notifyListeners();
    }
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          // setState(() {
          messages[index] = updatedMessage;
          // });
          notifyListeners();

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          // setState(() {
          messages[index] = updatedMessage;
          // });
          notifyListeners();
        }
      }
      await OpenFilex.open(localPath);
    }
    notifyListeners();
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    getConversationResponse(chatId!);
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    messages[index] = updatedMessage;
    notifyListeners();
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      // id: "${chatData.id}",
      text: message.text,
    );
    addMessage(textMessage);
    // getConversationReply(chatId!);
    messages.add(response[0]);
    notifyListeners();
  }

  void listening() {
    yantaStream.listen((snapshot) {
      snapshot.fold(
        (l) {
          if (l is NoInternetGlitch) {
            debugPrint("Error $l");
          }
        },
        (r) {
          final messageData = r.data;
          if (messageData != null) {
            final message = types.Message.fromJson({
              "author": {
                "firstName": messageData.sender ?? "",
                "id": "${messageData.id}",
                "lastName": ""
              },
              "createdAt": messageData.modifiedAt ??
                  DateTime.now().millisecondsSinceEpoch,
              "id": "${messageData.id}",
              "status": "seen",
              "text": messageData.message ?? "",
              "type": "text"
            });
            response.insert(0, message);
            notifyListeners();
          }
        },
      );
    });
  }

  void loadMessages(MessageData chatData) {
    // messages[0] = types.Message.fromJson(jsonDecode(jsonEncode({})));
    messages = [];
    debugPrint("Message lst ${messages.length}");
    final messagesList = (jsonDecode(jsonEncode([
      {
        "author": {
          "firstName": chatData.members!.first,
          "id": "${chatData.id}",
          "lastName": ""
        },
        "createdAt": chatData.modifiedAt,
        "id": "${chatData.id}",
        "status": "seen",
        "text": chatData.lastMessage,
        "type": "text"
      }
    ])) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    response = messagesList;
    // messages = List.filled(2, response[0]);
    // messages.insert(0, response[0]);
    // messages.add(response[0]);
    notifyListeners();
  }
}

class ConversationModel {
  String? currentUrl;
  String? message;
  Data? data;
  String? status;

  ConversationModel({
    this.currentUrl,
    this.message,
    this.data,
    this.status,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        currentUrl: json["currentUrl"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "currentUrl": currentUrl,
        "message": message,
        "data": data?.toJson(),
        "status": status,
      };
}

class Data {
  int? id;
  int? chatId;
  String? sender;
  String? message;
  int? modifiedAt;

  Data({
    this.id,
    this.chatId,
    this.sender,
    this.message,
    this.modifiedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        chatId: json["chat_id"],
        sender: json["sender"],
        message: json["message"],
        modifiedAt: json["modified_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chat_id": chatId,
        "sender": sender,
        "message": message,
        "modified_at": modifiedAt,
      };
}

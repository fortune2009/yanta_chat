class AllConversationModel {
  String? currentUrl;
  String? message;
  List<MessageData>? data;
  String? status;

  AllConversationModel({
    this.currentUrl,
    this.message,
    this.data,
    this.status,
  });

  factory AllConversationModel.fromJson(Map<String, dynamic> json) =>
      AllConversationModel(
        currentUrl: json["currentUrl"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MessageData>.from(
                json["data"]!.map((x) => MessageData.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "currentUrl": currentUrl,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}

class MessageData {
  int? id;
  String? lastMessage;
  List<String>? members;
  String? topic;
  int? modifiedAt;

  MessageData({
    this.id,
    this.lastMessage,
    this.members,
    this.topic,
    this.modifiedAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        id: json["id"],
        lastMessage: json["last_message"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"]!.map((x) => x)),
        topic: json["topic"],
        modifiedAt: json["modified_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "last_message": lastMessage,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "topic": topic,
        "modified_at": modifiedAt,
      };
}

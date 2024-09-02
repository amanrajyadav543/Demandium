
import 'package:demandium/feature/conversation/model/conversation_user.dart';

class ChannelModel {
  String? responseCode;
  String? message;
  ChannelContent? conversationContent;

  ChannelModel({this.responseCode, this.message, this.conversationContent});

  ChannelModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    conversationContent = json['content'] != null ? ChannelContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (conversationContent != null) {
      data['content'] = conversationContent!.toJson();
    }
    return data;
  }
}

class ChannelContent {
  int? currentPage;
  List<ChannelData>? conversationList;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ChannelContent(
      {this.currentPage,
        this.conversationList,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ChannelContent.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      conversationList = <ChannelData>[];
      json['data'].forEach((v) {
        conversationList!.add(ChannelData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];

    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (conversationList != null) {
      data['data'] = conversationList!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;

    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ChannelData {
  String? id;
  String? referenceId;
  String? referenceType;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? channelUsersCount;
  String? lastSentMessage;
  String? lastSentAttachmentType;
  String? lastMessageSentUser;
  int? lastSentFileCount;
  List<ConversationUserModel>? channelUsers;

  ChannelData(
      {this.id,
        this.referenceId,
        this.referenceType,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.channelUsersCount,
        this.channelUsers,
        this.lastSentMessage,
        this.lastSentAttachmentType,
        this.lastMessageSentUser,
        this.lastSentFileCount
      });

  ChannelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceId = json['reference_id'];
    referenceType = json['reference_type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    lastSentMessage = json['last_sent_message'];
    lastSentAttachmentType = json['last_sent_attachment_type'];
    lastMessageSentUser = json['last_message_sent_user'];
    channelUsersCount =int.tryParse( json['channel_users_count'].toString());
    lastSentFileCount =int.tryParse( json['last_sent_files_count'].toString());
    if (json['channel_users'] != null) {
      channelUsers = <ConversationUserModel>[];
      json['channel_users'].forEach((v) {
        channelUsers!.add(ConversationUserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference_id'] = referenceId;
    data['reference_type'] = referenceType;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['updated_at'] = lastSentMessage;
    data['last_sent_message'] = lastSentAttachmentType;
    data['channel_users_count'] = channelUsersCount;
    data['last_message_sent_user'] = lastMessageSentUser;
    data['last_sent_files_count'] = lastSentFileCount;
    if (channelUsers != null) {
      data['channel_users'] =
          channelUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:demandium/components/core_export.dart';

class ConversationRepo {

  final ApiClient apiClient;
  ConversationRepo({required this.apiClient});

  Future<Response> createChannel(String userID,String referenceID) async {
    return await apiClient.postData(AppConstants.createChannel, {"to_user": userID,"reference_id":referenceID, "reference_type":"booking_id"});
  }

  Future<Response> getChannelList(int offset, {String type = ""}) async {
    return await apiClient.getData('${AppConstants.getChannelListUrl}?limit=10&offset=$offset&type=$type');
  }

  Future<Response> searchChannelList({String? queryText}) async {
    return await apiClient.postData(AppConstants.searchChannelListUrl, {
      "limit" : "50",
      "offset": "1",
      "search": queryText
    });
  }

  // Future<Response> getChannelListBasedOnReferenceId(int offset,String referenceID) async {
  //   return await apiClient.getData('${AppConstants.getChannelListUrl}offset=$offset&reference_id=$referenceID&reference_type=booking_id');
  // }

  Future<Response> getConversation(String channelID,int offset) async {
    return await apiClient.getData('${AppConstants.getConversation}?channel_id=$channelID&offset=$offset');
  }

  Future<Response> sendMessage(String? message,String channelID,  List<MultipartBody>? file, List<PlatformFile>? platformFile) async {
    return await apiClient.postMultipartDataConversation(
        AppConstants.sendMessage,
        {"message": message??"","channel_id" : channelID},
        file ,
        otherFile: platformFile
    );
  }
}
import 'package:demandium/core/helper/image_size_checker.dart';
import 'package:demandium/feature/conversation/model/conversation_user.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:demandium/components/core_export.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


class ConversationController extends GetxController with GetSingleTickerProviderStateMixin implements GetxService{
  final ConversationRepo conversationRepo;
  ConversationController({required this.conversationRepo});


  TabController? tabController;

  List <XFile>? _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;


  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;

  bool _pickedFIleCrossMaxLimit = false;
  bool get pickedFIleCrossMaxLimit => _pickedFIleCrossMaxLimit;

  String _onMessageTimeShowID = '';
  String get onMessageTimeShowID => _onMessageTimeShowID;

  String _onImageOrFileTimeShowID = '';
  String get onImageOrFileTimeShowID => _onImageOrFileTimeShowID;

  bool _isClickedOnMessage = false;
  bool get isClickedOnMessage => _isClickedOnMessage;

  bool _isClickedOnImageOrFile = false;
  bool get isClickedOnImageOrFile => _isClickedOnImageOrFile;

  File? _file;
  List<PlatformFile>? objFile;
  File? get file=> _file;

  List<MultipartBody> _selectedImageList = [];
  List<MultipartBody> get selectedImageList => _selectedImageList;
  bool _paginationLoading = true;
  bool get paginationLoading => _paginationLoading;

  int? _messagePageSize;
  int? _messageOffset = 1;
  int? get messagePageSize => _messagePageSize;
  int? get messageOffset => _messageOffset;

  int? _channelPageSize;
  int? _channelOffset = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final String _name='';
  String get name => _name;
  final String _image='';
  String get image => _image;


  bool _isActiveSuffixIcon = false;
  bool get isActiveSuffixIcon => _isActiveSuffixIcon;

  bool _isSearchComplete = true;
  bool get isSearchComplete => _isSearchComplete;

  bool _pickedFIleCrossMaxLength = false;
  bool get pickedFIleCrossMaxLength => _pickedFIleCrossMaxLength;

  bool _singleFIleCrossMaxLimit = false;
  bool get singleFIleCrossMaxLimit => _singleFIleCrossMaxLimit;

  List<ChannelData>? _providerChannelList ;
  List<ChannelData>? get providerChannelList => _providerChannelList;

  List<ChannelData>? _servicemanChannelList ;
  List<ChannelData>? get servicemanChannelList => _servicemanChannelList;

  List<ChannelData>? _searchedChannelList = [];
  List<ChannelData>? get searchedChannelList => _searchedChannelList;
  
  List<ChannelData>? _searchedProviderChannelList = [];
  List<ChannelData>? get searchedProviderChannelList => _searchedProviderChannelList;


  List<ChannelData>? _searchedServicemanChannelList = [];
  List<ChannelData>? get searchedServicemanChannelList => _searchedServicemanChannelList;

  List<ConversationData>? _conversationList;
  List<ConversationData>? get conversationList => _conversationList;

  // ConversationUserModel? _adminConversationModel;
  // ConversationUserModel? get adminConversationModel => _adminConversationModel;

  ChannelData? _adminConversation;
  ChannelData? get adminConversationModel => _adminConversation;

  final ScrollController channelScrollController1 = ScrollController();
  final ScrollController channelScrollController2 = ScrollController();
  final ScrollController messageScrollController = ScrollController();
  int? get pageSize => _channelPageSize;
  int? get offset => _channelOffset;

  var conversationController = TextEditingController();
  var searchController = TextEditingController();

  String _channelId = '';
  String get channelId => _channelId;
  String _userTypeImage ='';
  String get  userTypeImage => _userTypeImage;

  void setChannelId(String channelId){
    _channelId = channelId;
  }


  @override
  void onInit(){
    super.onInit();
    conversationController.text = '';
    tabController = TabController(vsync: this, length: 2);
    channelScrollController1.addListener(() {
      if (channelScrollController1.position.pixels == channelScrollController1.position.maxScrollExtent){
        if (_channelOffset! < _channelPageSize!) {
          getChannelList(_channelOffset!+1, isFromPagination: true);
        }
      }
    });

    messageScrollController.addListener(() {
      if (messageScrollController.position.pixels == messageScrollController.position.maxScrollExtent) {
        if (_messageOffset! < _messagePageSize!) {
          getConversation(_channelId,_messageOffset!+1, isFromPagination: true);
        }
      }
    });
  }


  Future<void> pickMultipleImage(bool isRemove,{int? index}) async {

    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    _singleFIleCrossMaxLimit = false;
    if(isRemove) {
      if(index != null){
        _pickedImageFiles!.removeAt(index);
        _selectedImageList.removeAt(index);
      }
    }else {

      List<XFile> pickImages = await ImagePicker().pickMultiImage();
      _pickedImageFiles = [];
      _selectedImageList = [];
      objFile = [];

      for (var element in pickImages) {
        if(await ImageSize.getImageSizeFromXFile(element) > AppConstants.maxSizeOfASingleFile ){
          _singleFIleCrossMaxLimit = true;
        }else{
          if((await ImageSize.getMultipleImageSizeFromXFile(_pickedImageFiles!) + await ImageSize.getImageSizeFromXFile(element)) < AppConstants.maxLimitOfFileSentINConversation && _pickedImageFiles!.length < AppConstants.maxLimitOfTotalFileSent){
            _pickedImageFiles!.add(element);
            _selectedImageList.add(MultipartBody('files[${_selectedImageList.length}]', element));
          }
        }
      }

      if(_pickedImageFiles?.length == AppConstants.maxLimitOfTotalFileSent && pickImages.length > AppConstants.maxLimitOfTotalFileSent){
        _pickedFIleCrossMaxLength = true;
      }
      if( _pickedImageFiles?.length == AppConstants.maxLimitOfTotalFileSent && await ImageSize.getMultipleImageSizeFromXFile(pickImages) > AppConstants.maxLimitOfFileSentINConversation){
        _pickedFIleCrossMaxLimit = true;
      }
    }
    update();
  }

  Future<void> pickOtherFile(bool isRemove, {int? index}) async {

    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    _singleFIleCrossMaxLimit = false;
    if(isRemove){
      if(objFile!=null){
        objFile!.removeAt(index!);
      }
    }else{

      List<PlatformFile>? platformFile = (await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withReadStream: true,
      ))?.files ;

      objFile = [];
      _pickedImageFiles = [];
      _selectedImageList = [];

      platformFile?.forEach((element) {
        if(ImageSize.getFileSizeFromPlatformFileToDouble(element) > AppConstants.maxSizeOfASingleFile) {
          _singleFIleCrossMaxLimit = true;
        } else{
          if(  objFile!.length < AppConstants.maxLimitOfTotalFileSent){
            if((ImageSize.getMultipleFileSizeFromPlatformFiles(objFile!) + ImageSize.getFileSizeFromPlatformFileToDouble(element)) < AppConstants.maxLimitOfFileSentINConversation){
              objFile!.add(element);
            }
          }

        }
      });

      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null &&   platformFile.length > AppConstants.maxLimitOfTotalFileSent){
        _pickedFIleCrossMaxLength = true;
      }
      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null && ImageSize.getMultipleFileSizeFromPlatformFiles(platformFile) > AppConstants.maxLimitOfFileSentINConversation){
        _pickedFIleCrossMaxLimit = true;
      }
    }
    update();
  }


  void removeFile() async {
    _otherFile=null;
    update();
  }


  Future<void> getChannelList(int offset, {bool isFromPagination = false,bool reload = false, bool isFirst = false, String type = "provider"}) async{
    _channelOffset = offset;

    if(reload){
      // _customerChannelList = null;
      // _servicemanChannelList = null;
      if(!isFirst){
        update();
      }
    }

    Response response = await conversationRepo.getChannelList(offset, type: type);

    if(response.statusCode == 200){

      if(_channelOffset==1){
        if(type == "provider"){
          _providerChannelList = [];
          response.body['content']['channelList']['data'].forEach((channel){
            _providerChannelList!.add(ChannelData.fromJson(channel));
          });
        }else{
          _servicemanChannelList = [];
          response.body['content']['channelList']['data'].forEach((channel){
            _servicemanChannelList!.add(ChannelData.fromJson(channel));
          });
        }
      }else{
        if(type == "provider"){
          response.body['content']['channelList']['data'].forEach((channel){
            _providerChannelList!.add(ChannelData.fromJson(channel));
          });
        }else{
          response.body['content']['channelList']['data'].forEach((channel){
            _servicemanChannelList!.add(ChannelData.fromJson(channel));
          });
        }
      }

      _channelPageSize =response.body['content']['channelList']['last_page'];

      if(response.body['content']['adminChannel'] !=null) {
        _adminConversation = ChannelData.fromJson( response.body['content']['adminChannel']);
      }

    }else{
      ApiChecker.checkApi(response);
    }

    _paginationLoading = false;
    _isLoading = false;
    update();
  }

  Future<void> getSearchedChannelList({String? query, }) async{
    _searchedChannelList = null;
    _isSearchComplete = false;
    _searchedProviderChannelList = [];
    _searchedServicemanChannelList = [];
    update();

    Response response = await conversationRepo.searchChannelList(queryText: query);

    if(response.statusCode == 200){
      _searchedChannelList = [];
      response.body['content']['data'].forEach((channel){
        _searchedChannelList!.add(ChannelData.fromJson(channel));
      });

      if(_searchedChannelList!.isNotEmpty){
        ConversationUserModel? conversationUser;
        for(var item in _searchedChannelList!){
          conversationUser = item.channelUsers?[0].user?.userType == 'customer' ? item.channelUsers![1] : item.channelUsers![0];
          if(conversationUser.user?.userType == 'provider-admin'){
            _searchedProviderChannelList?.add(item);
          }else if(conversationUser.user?.userType == 'provider-serviceman'){
            _searchedServicemanChannelList?.add(item);
          }
        }
      }

      if(tabController?.index == 0 && _searchedProviderChannelList!.isEmpty && _searchedServicemanChannelList!.isNotEmpty){
        tabController?.index = 1;
      }else if(tabController?.index == 1 && _searchedProviderChannelList!.isNotEmpty && _searchedServicemanChannelList!.isEmpty){
        tabController?.index = 0;
      }

    }else{
      ApiChecker.checkApi(response);
    }

    _isSearchComplete = true;
    update();
  }


  Future<void> createChannel(String userID,String referenceID,{String name='Chatting Page',
    String image='',bool fromBookingDetailsPage = false,String phone='',bool shouldUpdate = true, String userType=""}) async{
    _isLoading = true;
    if(shouldUpdate){
      update();
    }
    Response response = await conversationRepo.createChannel(userID,referenceID);
    if(response.statusCode == 200){
      if(fromBookingDetailsPage){
        Get.back();
        Get.toNamed(RouteHelper.getChatScreenRoute(response.body['content']['id'],name,image,phone,userType));
      } else {
        Get.toNamed(RouteHelper.getChatScreenRoute(response.body['content']['id'],name,image,phone,userType));
      }
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

   cleanOldData(){
    conversationController.text = "";
    _pickedImageFiles = [];
    objFile = [];
    _selectedImageList = [];
    _otherFile = null;
    _file = null;
  }


  Future<void> getConversation(String channelID, int offset,{ bool isFromPagination = false, bool isInitial = false}) async{

    if(!isFromPagination && isInitial){
      _conversationList = null;
    }
    _messageOffset = offset;
    Response response = await conversationRepo.getConversation(channelID, offset);
    if(response.statusCode == 200){
      if(!isFromPagination){
        _conversationList = [];
      }
      response.body['content']['data'].forEach((conversation){_conversationList!.add(ConversationData.fromJson(conversation));
      _messagePageSize =  response.body['content']['last_page'];
      });
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> sendMessage(String channelID) async{
    _isLoading = true;
    update();
    Response response = await conversationRepo.sendMessage(conversationController.value.text,channelID ,_selectedImageList, objFile);
    if(response.statusCode == 200){
      getConversation(channelID,1,);
      conversationController.text='';
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile=null;
      _file=null;
    }
    else if(response.statusCode == 400){
      String message = response.body['errors'][0]['message'];
      if(message.contains("png  jpg  jpeg  csv  txt  xlx  xls  pdf")){
        message = "the_files_types_must_be";
      }
      if(message.contains("failed to upload")){
        message = "failed_to_upload";
      }
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile=null;
      _file=null;
      customSnackBar(message.tr);
    }
    else{
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile=null;
      _file=null;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }
  void downloadFileForWeb(String url) {
    html.AnchorElement anchorElement =  html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
  void setUserImageType(String userType){
    _userTypeImage = userType;
    update();
  }

  void showSuffixIcon(context,String text){
    if(text.isNotEmpty){
      _isActiveSuffixIcon = true;
    }else if(text.isEmpty){
      _isActiveSuffixIcon = false;
      searchController.clear();
      _isSearchComplete = false;
    }
    update();
  }

  void clearSearchController({bool shouldUpdate = true} ){
    searchController.clear();
    _isSearchComplete = false;
    _isActiveSuffixIcon = false;
    tabController?.index = 0;
    if(shouldUpdate){
      update();
    }
  }

  void resetImageFile(){
    _pickedImageFiles = [];
    update();
  }

  String getChatTime (String todayChatTimeInUtc , String? nextChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalDate(todayChatTimeInUtc);

    if (kDebugMode) {
      print("Current Message DataTime: $todayConversationDateTime");
    }

    DateTime nextConversationDateTime;
    DateTime currentDate = DateTime.now();

    if(nextChatTimeInUtc == null){
      return chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
    }else{
      nextConversationDateTime = DateConverter.isoUtcStringToLocalDate(nextChatTimeInUtc);
      if (kDebugMode) {
        print("Next Message DateTime: $nextConversationDateTime");
        print("The Difference between this two : ${todayConversationDateTime.difference(nextConversationDateTime)}");
        print("Today message Weekday: ${todayConversationDateTime.weekday}\n Next Message WeekDay: ${nextConversationDateTime.weekday}");
      }


      if(todayConversationDateTime.difference(nextConversationDateTime) < const Duration(minutes: 30) &&
          todayConversationDateTime.weekday == nextConversationDateTime.weekday){
        chatTime = '';
      }else if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        if( (currentDate.weekday -1 == 0 ? 7 : currentDate.weekday -1) == todayConversationDateTime.weekday){
          chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, false);
        }else{
          chatTime = DateConverter.convertStringTimeToDateTime(todayConversationDateTime);
        }

      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, true);
      }else{
        chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      }
    }
    return chatTime;
  }


  String getChatTimeWithPrevious (ConversationData currentChat, ConversationData? previousChat) {
    DateTime todayConversationDateTime = DateConverter
        .isoUtcStringToLocalDate(currentChat.createdAt ?? "");

    DateTime previousConversationDateTime;

    if (previousChat?.createdAt == null) {
      return 'Not-Same';
    } else {
      previousConversationDateTime =
          DateConverter.isoUtcStringToLocalDate(previousChat!.createdAt!);
      if (kDebugMode) {
        print("The Difference is ${previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30)}");
      }
      if (previousConversationDateTime.difference(todayConversationDateTime) <
          const Duration(minutes: 30) &&
          todayConversationDateTime.weekday ==
              previousConversationDateTime.weekday && isSameUserWithPreviousMessage(currentChat, previousChat)) {
        return '';
      } else {
        return 'Not-Same';
      }
    }
  }



  bool isSameUserWithPreviousMessage( ConversationData ? previousConversation, ConversationData? currentConversation){
    if(previousConversation?.userId == currentConversation?.userId && previousConversation?.message != null && currentConversation?.message !=null){
      return true;
    }
    return false;
  }


  bool isSameUserWithNextMessage( ConversationData? currentConversation, ConversationData? nextConversation){
    if(currentConversation?.userId == nextConversation?.userId && nextConversation?.message != null && currentConversation?.message !=null){
      return true;
    }
    return false;
  }


  String? getOnPressChatTime(ConversationData currentConversation){

    if(currentConversation.id == _onMessageTimeShowID || currentConversation.id == _onImageOrFileTimeShowID){
      DateTime currentDate = DateTime.now();
      DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalDate(
          currentConversation.createdAt ?? ""
      );

      if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return DateConverter.convertStringTimeToDate(todayConversationDateTime);
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return  DateConverter.convert24HourTimeTo12HourTime(todayConversationDateTime);
      }else{
        return DateConverter.isoStringToLocalDateAndTime(currentConversation.createdAt!);
      }
    }else{
      return null;
    }
  }

  void toggleOnClickMessage ({required String onMessageTimeShowID}){
    _onImageOrFileTimeShowID = '';
    _isClickedOnImageOrFile = false;
    if(_isClickedOnMessage && _onMessageTimeShowID != onMessageTimeShowID){
      _onMessageTimeShowID = onMessageTimeShowID;
    }else if(_isClickedOnMessage && _onMessageTimeShowID == onMessageTimeShowID){
      _isClickedOnMessage = false;
      _onMessageTimeShowID = '';
    }else{
      _isClickedOnMessage = true;
      _onMessageTimeShowID = onMessageTimeShowID;
    }
    update();
  }

  void toggleOnClickImageAndFile ({required String onImageOrFileTimeShowID}){
    _onMessageTimeShowID = '';
    _isClickedOnMessage = false;
    if(_isClickedOnImageOrFile && _onImageOrFileTimeShowID != onImageOrFileTimeShowID){
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    }else if(_isClickedOnImageOrFile && _onImageOrFileTimeShowID == onImageOrFileTimeShowID){
      _isClickedOnImageOrFile = false;
      _onImageOrFileTimeShowID = '';
    }else{
      _isClickedOnImageOrFile = true;
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    }
    update();
  }





}
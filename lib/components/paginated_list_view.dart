import 'package:demandium/components/custom_loader_widget.dart';
import 'package:demandium/feature/home/widget/bottom_create_post_dialog.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final Widget itemView;
  final bool showBottomSheet;
  final double bottomPadding;
  const PaginatedListView({
    super.key, required this.scrollController, required this.onPaginate, required this.totalSize, this.showBottomSheet = false,
    required this.offset, required this.itemView, this.bottomPadding = Dimensions.paddingSizeExtraLarge * 2,
  }) ;

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _offset;
  List<int>? _offsetList;
  bool _isLoading = false;
  bool showBottomSheet = false;

  @override
  void initState() {
    super.initState();
    _offset = 1;
    _offsetList = [1];
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent && widget.totalSize != null && !_isLoading) {
        if(mounted && !ResponsiveHelper.isDesktop(context)) {
          _paginate();
        }
      }
    });
  }
  void _paginate() async {
    int pageSize = (widget.totalSize! / 10).ceil();
    if (_offset < pageSize && !_offsetList!.contains(_offset+1)) {

      setState(() {
        _offset = _offset + 1;
        _offsetList!.add(_offset);
        _isLoading = true;
      });

      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if(pageSize != 0 && _offset>=pageSize-1  &&  widget.showBottomSheet &&  Get.find<SplashController>().configModel.content?.biddingStatus==1 ){
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: Get.context!,
          builder: (BuildContext context){
        return const BottomCreatePostDialog();
      });
      Get.find<CreatePostController>().resetCreatePostValue();
    }
  }


  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset!;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList!.add(index);
      }
    }
    return Column(children: [

      widget.itemView,
      const SizedBox(height: Dimensions.paddingSizeDefault),
      (ResponsiveHelper.isDesktop(context) && (widget.totalSize == null || _offset >= (widget.totalSize! / 10).ceil() || _offsetList!.contains(_offset+1))) ?
      const SizedBox() :
      Center(child: Padding(
        padding: (_isLoading || ResponsiveHelper.isDesktop(context)) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : EdgeInsets.zero,
        child: _isLoading ? CustomLoaderWidget(color: Theme.of(context).colorScheme.primary) : (ResponsiveHelper.isDesktop(context) && widget.totalSize != null) ?
        InkWell(
          radius: 50,
          onTap: _paginate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Get.isDarkMode? light.cardColor: Theme.of(context).primaryColor),
            ),
            child: Text(
              'see_more'.tr,
              style: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Get.isDarkMode? light.cardColor: Theme.of(context).primaryColor
              ),
            ),
          ),
        ) : const SizedBox(),
      )),

       SizedBox(height: widget.bottomPadding ),
    ]);
  }
}
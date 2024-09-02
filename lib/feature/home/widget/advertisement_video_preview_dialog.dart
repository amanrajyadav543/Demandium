import 'package:chewie/chewie.dart';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';


class AdvertisementVideoPreviewDialog extends StatefulWidget {
  final ChewieController? chewieController;
  final double aspectRatio;
  const AdvertisementVideoPreviewDialog({super.key, this.chewieController, required this.aspectRatio});

  @override
  State<AdvertisementVideoPreviewDialog> createState() => _AdvertisementVideoPreviewDialogState();
}

class _AdvertisementVideoPreviewDialogState extends State<AdvertisementVideoPreviewDialog> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          Positioned.fill(child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Get.isDarkMode ? Colors.grey : Colors.white, // Color at the beginning
                Get.isDarkMode ? Colors.cyan.shade100 : Colors.cyan.shade50, // Color in the middle
                Get.isDarkMode ? Colors.grey : Colors.white,
              ]),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),

          )),

          AspectRatio(
            aspectRatio: ResponsiveHelper.isDesktop(context) ? 16/9 :  (widget.chewieController != null && widget.chewieController!.videoPlayerController.value.isInitialized) ? widget.chewieController!.videoPlayerController.value.aspectRatio : 16/9 ,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: widget.chewieController !=null ? Chewie(controller: widget.chewieController!,) : const Center(child: CircularProgressIndicator()),
            ),
          ),
          Positioned(top: -20,right: -20,child: InkWell(
            onTap: ()=> Get.back(),
            child: const Icon(Icons.cancel,color: Colors.white70,),
          )
          )
        ],
      ),
    );
  }
}

import 'package:demandium/components/core_export.dart';
import 'package:photo_view/photo_view.dart';


class ZoomImage extends StatefulWidget {
  final String image;
  final String imagePath;
  final String? createdAt;
  const ZoomImage({super.key, required this.image, required this.imagePath, this.createdAt})
      ;

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  bool isZoomed = false;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
     appBar: isZoomed ? null : CustomAppBar(title: widget.image, subTitle: widget.createdAt, centerTitle: false,),
      body: FooterBaseView(
        isScrollView: ResponsiveHelper.isDesktop(context) ? true : false,
        child: Center(
          child: SizedBox(width: Dimensions.webMaxWidth, height: Dimensions.webMaxWidth,
            child: PhotoView(

              scaleStateChangedCallback: (value) {
                if (value != PhotoViewScaleState.initial) {
                  isZoomed = true;
                } else {
                  isZoomed = false;
                }
                setState(() {});
              },

              minScale: PhotoViewComputedScale.contained,
              imageProvider: NetworkImage(widget.imagePath),
            ),
          ),
        ),
      ),
    );
  }
}
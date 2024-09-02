import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/utils/html_type.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType? htmlType;
  const HtmlViewerScreen({super.key, @required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<HtmlViewController>().getPagesContent();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      appBar: CustomAppBar(title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_and_conditions'.tr
          : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr :
      widget.htmlType == HtmlType.privacyPolicy ? 'privacy_policy'.tr :
      widget.htmlType == HtmlType.cancellationPolicy ? 'cancellation_policy'.tr :
      widget.htmlType == HtmlType.refundPolicy ? 'refund_policy'.tr :
      'no_data_found'.tr),


      body: GetBuilder<HtmlViewController>(
        builder: (htmlViewController){
          String? data;
          if(htmlViewController.pagesContent != null){
             data = widget.htmlType == HtmlType.termsAndCondition ? htmlViewController.pagesContent?.termsAndConditions?.liveValues??""
                : widget.htmlType == HtmlType.aboutUs ? htmlViewController.pagesContent?.aboutUs?.liveValues??""
                : widget.htmlType == HtmlType.privacyPolicy ? htmlViewController.pagesContent?.privacyPolicy?.liveValues ?? ""
                : widget.htmlType == HtmlType.refundPolicy ? htmlViewController.pagesContent?.refundPolicy?.liveValues ?? ""
                : widget.htmlType == HtmlType.cancellationPolicy ? htmlViewController.pagesContent?.cancellationPolicy?.liveValues??""
                : null;

               if(data != null) {
                 data = data.replaceAll('href=', 'target="_blank" href=');

               return FooterBaseView(
                 isScrollView:ResponsiveHelper.isMobile(context) ? false: true,
                 isCenter:true,
                 child: WebShadowWrap(
                   child: SizedBox(
                     width: Dimensions.webMaxWidth,
                     height: Get.height,
                     child:SingleChildScrollView(
                       padding: const EdgeInsets.all(Dimensions.paddingSizeSmall,
                       ),
                       physics: const BouncingScrollPhysics(),
                       child: Column(
                         children: [
                          if( ResponsiveHelper.isDesktop(context))
                           Padding(
                             padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                             child: Text(
                                 widget.htmlType == HtmlType.termsAndCondition ? 'terms_and_conditions'.tr
                                     : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr :
                                 widget.htmlType == HtmlType.privacyPolicy ? 'privacy_policy'.tr :
                                 widget.htmlType == HtmlType.cancellationPolicy ? 'cancellation_policy'.tr :
                                 widget.htmlType == HtmlType.refundPolicy ? 'refund_policy'.tr:'',
                               style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                             ),
                           ),
                           Html(
                             data: data,
                             style: {
                               "p": Style(
                                 fontSize: FontSize.medium,
                               ),

                             },
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               );
             }else{
               return const SizedBox();
             }
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: Get.find<AuthController>().isLoggedIn() ? GetBuilder<ConversationController>(builder: (conversationController){
        return FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          hoverColor:Colors.black26,
          onPressed: conversationController.isLoading ? null : (){
            String userId = Get.find<SplashController>().configModel.content!.adminDetails!.id!;
            String phone = Get.find<SplashController>().configModel.content?.businessPhone??"";
            String name = "admin";
            String image = "${Get.find<SplashController>().configModel.content?.faviconFullPath}";
            Get.find<ConversationController>().createChannel(userId, "",name: name,image: image,fromBookingDetailsPage: false,phone: phone);
          },
          child: Center(child: conversationController.isLoading ? const SizedBox(
            height: 25, width: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ) : Image.asset(Images.adminChat,scale: 2.8,)),
        );
        
      }) : null,
    );
  }
}

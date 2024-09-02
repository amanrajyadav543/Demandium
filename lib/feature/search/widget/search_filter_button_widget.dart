import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/search/widget/already_filtered_widget.dart';
import 'package:demandium/feature/search/widget/service_filter_dialog.dart';
import 'package:demandium/feature/search/widget/service_sort_dialog.dart';
import 'package:get/get.dart';

class SearchFilterButtonWidget extends StatelessWidget {
  const SearchFilterButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      return Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: Text('services'.tr.toUpperCase(), style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge,),),
          ),

          searchController.sortedByList.isNotEmpty && ResponsiveHelper.isDesktop(context) ?
          const Expanded(child: Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: AlreadyFilteredWidget(),
          )) : const SizedBox(),

          Row(children: [

            ResponsiveHelper.isDesktop(context) ? PopupMenuButton<String>(
              tooltip: "",
              constraints: BoxConstraints(maxWidth: Dimensions.webMaxWidth / 3, maxHeight: Get.height * 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault,)),
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
              ),
              position: PopupMenuPosition.under, elevation: 1,
              shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
              itemBuilder: (BuildContext context) {
                return ["Menu"].map((String option) {
                  return PopupMenuItem<String>(
                    onTap: null, enabled: false, value: option,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: const ServiceSortDialog(showCrossButton: false,),
                  );
                }).toList();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).hintColor),
                ),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall ),
                child: Row(mainAxisSize: MainAxisSize.min,children: [
                  Image.asset(Images.sort,width: 20,color: Theme.of(context).hintColor),
                  if(ResponsiveHelper.isDesktop(context)) Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight),
                        child: Text('sort_by'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Theme.of(context).hintColor,)
                    ],
                  )
                ],),
              ),
            ) : InkWell(
              onTap: (){
                showModalBottomSheet(
                  useRootNavigator: true, isScrollControlled: true, backgroundColor: Colors.transparent,
                  context: context, builder: (context) => const ServiceSortDialog(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).hintColor)
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall ),
                child: Row(mainAxisSize: MainAxisSize.min,children: [
                  Image.asset(Images.sort,width: 20,color: Theme.of(context).hintColor),
                ],),
              ),
            ),



            const SizedBox(width: Dimensions.paddingSizeDefault,),



            ResponsiveHelper.isDesktop(context) ? PopupMenuButton<String>(
              tooltip: "",
              constraints: const BoxConstraints(maxWidth: Dimensions.webMaxWidth / 3),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault,)),
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
              ),
              position: PopupMenuPosition.under, elevation: 1,
              shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
              itemBuilder: (BuildContext context) {
                return ["Menu"].map((String option) {
                  return PopupMenuItem<String>(
                    onTap: null, enabled: false, value: option,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                        child: const ServiceFilterDialog(showCrossButton: false)
                    ),
                  );
                }).toList();
              },
              child:  Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall + 2  , horizontal: Dimensions.paddingSizeDefault + 2 ),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall ),
                child: Row(mainAxisSize: MainAxisSize.min,children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(Images.filter,width: 16,color: Colors.white,),
                      if(searchController.filteredByList.isNotEmpty)Positioned(
                        top: -7,left: -10,
                        child: Container(height: 16,width: 16,
                          padding: const EdgeInsets.all(3),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text('${searchController.filteredByList.length}', style: ubuntuBold.copyWith(color: Colors.white),
                              ),),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  Text('filter'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white),),
                ],),
              ),
            ): InkWell(
              onTap: (){
                showModalBottomSheet(
                  useRootNavigator: true, isScrollControlled: true, backgroundColor: Colors.transparent,
                  context: context, builder: (context) => ConstrainedBox(constraints: BoxConstraints(maxHeight: Get.height * 0.7), child: const ServiceFilterDialog()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 2),
                child: Row(mainAxisSize: MainAxisSize.min,children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(Images.filter,width: 16,color: Colors.white,),
                      if(searchController.filteredByList.isNotEmpty)Positioned(
                        top: -7,left: -10,
                        child: Container(height: 16,width: 16,
                          padding: const EdgeInsets.all(3),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text('${searchController.filteredByList.length}', style: ubuntuBold.copyWith(color: Colors.white),
                              ),),
                          ),
                        ),
                      )
                    ],
                  ),
                ],),
              ),
            ),

          ]),
        ]),
      );
    });
  }
}

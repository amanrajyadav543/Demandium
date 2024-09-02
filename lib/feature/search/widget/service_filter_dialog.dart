import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/widgets/custom_checkbox.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';


class ServiceFilterDialog extends StatefulWidget {
  final bool showCrossButton;
  const ServiceFilterDialog({super.key, this.showCrossButton = true});

  @override
  State<ServiceFilterDialog> createState() => _ServiceFilterDialogState();
}

class _ServiceFilterDialogState extends State<ServiceFilterDialog> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){

      return Container(
        width:ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth/2 : Dimensions.webMaxWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        ),
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),

        child: Column(
          children: [

            if(widget.showCrossButton) Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                const SizedBox(width: Dimensions.paddingSizeLarge,),
                Container(height: 5, width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).hintColor.withOpacity(0.3),
                  ),
                ),

                InkWell(onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],),
            ),

            Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Text('filter_data'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                  color: Theme.of(context).textTheme.bodyMedium?.color
              ),),
            )),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [


                    const SizedBox(height: Dimensions.paddingSizeLarge,),

                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text('price'.tr,style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyMedium?.color),),
                    ),

                    FlutterSlider(
                      values: [searchController.filteredMinPrice ?? searchController.initialMinPrice, searchController.filteredMaxPrice ?? searchController.initialMaxPrice],
                      rangeSlider: true,
                      max:  searchController.initialMaxPrice, min: searchController.initialMinPrice,
                      trackBar: FlutterSliderTrackBar(
                        activeTrackBarHeight: 7,
                        inactiveTrackBarHeight: 7,
                        activeTrackBar: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                        inactiveTrackBar:  BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                      tooltip: FlutterSliderTooltip(
                        format: (String value) {
                          return PriceConverter.convertPrice(double.tryParse(value), decimalPointCount: 0);
                        },
                        disableAnimation: true,
                        textStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                        boxStyle: const FlutterSliderTooltipBox(decoration: BoxDecoration()),
                        positionOffset: FlutterSliderTooltipPositionOffset(top: 27),
                      ),

                      handler: FlutterSliderHandler(
                        decoration: const BoxDecoration(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 8, width: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration: const BoxDecoration(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: 8, width: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),

                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        searchController.updateFilterPriceRange(lowerValue,upperValue);
                      },
                    ),

                    Divider(color: Theme.of(context).hintColor.withOpacity(0.7), height: 0.5,),

                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                      child: Text('ratings'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium?.color),),
                    ),
                    ListView.builder(itemBuilder: (context,index){
                      return SizedBox(
                        height: 35,
                        child: RadioListTile(
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          activeColor: Theme.of(context).colorScheme.primary,
                          title: Text(
                            searchController.ratingFilter[index] == "5" ? "only_rated_5".tr :
                            "${searchController.ratingFilter[index]}+ ${'rating'.tr}",
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),
                          ),
                          value: searchController.ratingFilter[index],
                          groupValue: searchController.selectedRating,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (val) {
                            searchController.updateFilterByRating(searchController.ratingFilter[index]);
                          },
                        ),
                      );
                    },itemCount: searchController.ratingFilter.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Divider(color: Theme.of(context).hintColor.withOpacity(0.7), height: 0.5,),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Text('categories'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium?.color),),
                    ),

                    GetBuilder<CategoryController>(builder: (categoryController){
                      return ConstrainedBox(constraints: BoxConstraints(maxHeight: Get.height * 0.25, minHeight: Get.height * 0.1),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: ListView.builder(itemBuilder: (context,index){
                          
                            return SizedBox(
                              height: 35,
                              child: CustomCheckBox(title:  categoryController.categoryList?[index].name ?? "",
                          
                                value: searchController.categoryCheckList[index],
                                onTap: ()=> searchController.toggleFromCampaignChecked(index),
                              ),
                            );
                          },itemCount: categoryController.categoryList?.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                          ),
                        ),
                      );
                    }),


                  ]),
                ),
              ),
            ),

            Padding(padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),
              child: Row(
                children: [
                  (searchController.selectedRating != null || searchController.selectedCategoryId.isNotEmpty
                      || searchController.filteredMinPrice != null ||
                      searchController.filteredMaxPrice != null) ?
                  Expanded(
                    child: CustomButton(buttonText: 'clear_filter'.tr,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      textColor: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                      onPressed: () async {
                        if(searchController.filteredByList.isNotEmpty){
                          Get.back();
                          searchController.clearFilterDataValues(shouldUpdate: false);
                          Get.dialog(const CustomLoader(), barrierDismissible: false,);
                          await searchController.searchData(query:searchController.searchController.text,offset: 1, shouldUpdate: false);
                          Get.back();
                        }else{
                          searchController.clearFilterDataValues(shouldUpdate: true);
                        }
                      },
                    ),
                  ) : const SizedBox(),

                  (searchController.selectedRating != null || searchController.selectedCategoryId.isNotEmpty
                      || searchController.filteredMinPrice != null ||
                      searchController.filteredMaxPrice != null) ?

                  const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),


                  Expanded(
                    child: CustomButton(buttonText: 'filter'.tr,onPressed: () async{
                      Get.back();
                      Get.dialog(const CustomLoader(), barrierDismissible: false,);
                      await searchController.searchData(query:searchController.searchController.text,offset: 1, shouldUpdate: false);
                      Get.back();
                    },),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

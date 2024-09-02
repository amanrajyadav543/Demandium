import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ServiceSortDialog extends StatelessWidget {
  final bool showCrossButton;
  const ServiceSortDialog({super.key, this.showCrossButton = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){

      return Container(
        width:ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),

        child: Column(mainAxisSize: MainAxisSize.min, children: [

          if(showCrossButton) Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
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


          Text('sort_by'.tr,style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyMedium?.color
          )),

          const SizedBox(height: Dimensions.paddingSizeLarge,),


          SizedBox(height: 38, child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: searchController.sortBy.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
            return InkWell(
              onTap: ()=> searchController.updateSortBy(searchController.sortBy[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: searchController.sortBy[index] == searchController.selectedSortBy ?
                  Theme.of(context).colorScheme.primary.withOpacity(0.1): null,
                  border: Border.all( color:searchController.sortBy[index] == searchController.selectedSortBy ?
                  Theme.of(context).colorScheme.primary.withOpacity(0.3): Theme.of(context).hintColor.withOpacity(0.2)),
                ),
                child: Center(child: Text(searchController.sortBy[index].tr,style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyMedium?.color
                ),)),
              ),
            );},
          )),
          const SizedBox(height: Dimensions.paddingSizeLarge,),

          Divider(color: Theme.of(context).hintColor.withOpacity(0.3), height: 0.5,),
          const SizedBox(height: Dimensions.paddingSizeDefault,),

          ListView.builder(itemBuilder: (context,index){
            return RadioListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              contentPadding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text(searchController.sortByType[index].tr ,style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyMedium?.color
              )),
              value: searchController.sortByType[index],
              groupValue: searchController.selectedSortByType,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (val) {
                searchController.updateSortByType(searchController.sortByType[index]);
              },
            );
          },itemCount: searchController.sortByType.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge,),

          Row(
            children: [

              (searchController.selectedSortBy !=null || searchController.selectedSortByType !="default") ? Expanded(
                child: CustomButton(buttonText: 'clear_sorting'.tr,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  textColor: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  onPressed: () async {

                  if(searchController.sortedByList.isNotEmpty){
                    Get.back();
                    searchController.clearSortByValues(shouldUpdate: false);
                    Get.dialog(const CustomLoader(), barrierDismissible: false,);
                    await searchController.searchData(query:searchController.searchController.text,offset: 1, shouldUpdate: false);

                    Get.back();
                  }else{
                    searchController.clearSortByValues();
                  }},

                ),
              ): const SizedBox(),

              (searchController.selectedSortBy !=null || searchController.selectedSortByType !="default") ?
              const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),

              Expanded(
                child: CustomButton(buttonText: 'sort_by'.tr,onPressed: () async{
                  Get.back();
                  Get.dialog(const CustomLoader(), barrierDismissible: false,);
                  await searchController.searchData(query:searchController.searchController.text,offset: 1, shouldUpdate: false);
                  Get.back();
                },),
              ),
            ],
          ),
        ],),
      );
    });
  }
}

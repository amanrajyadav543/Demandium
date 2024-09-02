import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/search/widget/filtter_remove_item.dart';
import 'package:get/get.dart';

class AlreadyFilteredWidget extends StatelessWidget {
  const AlreadyFilteredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding( padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, ),
      child: GetBuilder<AllSearchController>(builder: (searchController){
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            if(ResponsiveHelper.isDesktop(context)) Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text("applied_filters".tr,
                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
              ),
            ),

            Expanded(
              child: SizedBox(
                height: 35,
                child: ListView.builder(itemBuilder: (context,index){
                  return FilterRemoveItem(
                    title: "${searchController.sortedByList[index].title}".tr,
                    onTap: () async {
                      Get.dialog(const CustomLoader(), barrierDismissible: false);
                      searchController.removeSortedItem(removeItem: searchController.sortedByList[index].type, shouldUpdate: false);
                      await searchController.searchData(query:searchController.searchController.text,offset: 1, shouldUpdate: false);

                      Get.back();
                    },
                  );
                },
                  itemCount: searchController.sortedByList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

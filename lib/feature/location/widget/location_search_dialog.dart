import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 120 : 0),
      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: GetBuilder<LocationController>(builder: (locationController){
          return SizedBox(width: Dimensions.webMaxWidth-30, child: TypeAheadField(
            suggestionsCallback: (pattern) async => await Get.find<LocationController>().searchLocation(context, pattern),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'search_location'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                  ),
                  filled: true, fillColor: Theme.of(context).cardColor,
                ),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                ),
              );
            },

            itemBuilder: (context,  suggestion) {
              return Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                      )),
                    ),
                  ]),
                ),
              );
            },

            onSelected: (suggestion) {
              Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController!);
              Get.back();
            },
            errorBuilder : (_,value) {
              return const SizedBox();
            },
          ),);
        }),
      ),
    );
  }

}

import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ConversationDetailsAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? name;
  final String? image;
  final String? phone;
  final String fromNotification;
  const ConversationDetailsAppBar({super.key, this.name, this.image, this.phone, this.fromNotification =""}) ;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor.withOpacity(.2):Theme.of(context).primaryColor,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImage(image: image),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text( name?.tr ??"", style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color:  Colors.white,
            )),

            if(phone !="") Padding(padding: const EdgeInsets.only(top: 3),
              child: Text(phone ?? "", style: ubuntuLight.copyWith( fontSize: Dimensions.fontSizeSmall,
                color:  Colors.white,
              )),
            ),

          ]),
        ],
      ),
      leading: IconButton(onPressed: () {
        if(fromNotification == "fromNotification"){
          Get.offNamed(RouteHelper.getInboxScreenRoute(fromNotification: fromNotification));
        }else{
          Get.back();
        }
      },
        icon: Icon(Icons.arrow_back_ios,color:Theme.of(context).primaryColorLight,size: 20,),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 55);
}

import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/custom_loader_widget.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      height: 85, width: 85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      alignment: Alignment.center,
      child: CustomLoaderWidget(color: Theme.of(context).colorScheme.primary,),
    ));
  }
}

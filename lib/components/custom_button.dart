import 'package:demandium/components/core_export.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool? transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final String? assetIcon;
  final Color? backgroundColor;
  final bool isLoading;
  final Color? textColor;
  const CustomButton({super.key, this.onPressed, @required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.radius = 5, this.icon, this.assetIcon, this.backgroundColor, this.isLoading = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: backgroundColor ?? (onPressed != null ? Theme.of(context).colorScheme.primary : transparent! ?
      Colors.transparent:  Theme.of(context).disabledColor),
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth, height != null ? height! : ResponsiveHelper.isDesktop(context) ? 50 : 45),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
    );

    return Center(child: SizedBox(width: width ?? Dimensions.webMaxWidth,
      child: Padding( padding: margin == null ? const EdgeInsets.all(0) : margin!,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: flatButtonStyle,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            icon != null ? Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall,),
              child: Icon(icon, color: transparent! ? Theme.of(context).colorScheme.primary : Colors.white,size: 18,),) :
            assetIcon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Image.asset(assetIcon!,height: 16,width: 16,),
            ) :const SizedBox(),

            isLoading ? Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight),
              child: SizedBox(height:  fontSize ?? Dimensions.fontSizeDefault, width:  fontSize ?? Dimensions.fontSizeDefault,
                child: CircularProgressIndicator( strokeWidth : 2 , color: transparent! ? Theme.of(context).colorScheme.primary : Colors.white),),
            )
                : const SizedBox(),

            Text(buttonText ??'',
              textAlign: TextAlign.center,
              style: ubuntuMedium.copyWith(
                color: transparent! ? Theme.of(context).colorScheme.primary : textColor ?? Colors.white,
                fontSize: fontSize ?? Dimensions.fontSizeDefault,
            ),)
          ],),
        ),
      ),
    ),);
  }
}
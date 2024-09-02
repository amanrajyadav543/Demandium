import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/onboarding/controller/on_board_pager_controller.dart';

class OnBoardingScreen extends GetView<OnBoardController> {
  const OnBoardingScreen({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xfff2f5f9),
      body: GetBuilder<OnBoardController>(builder: (onBoardingController){
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  controller.onPageChanged(value);
                },
                controller: onBoardingController.pageController,
                itemCount: onBoardingController.onBoardPagerData.length,
                itemBuilder: (context, index) => PagerContent(
                  image: onBoardingController.onBoardPagerData[onBoardingController.pageIndex]["image"]!,
                  text: onBoardingController.onBoardPagerData[onBoardingController.pageIndex]["text"]!,
                  subText: onBoardingController.onBoardPagerData[onBoardingController.pageIndex]["subTitle"]!,
                  topImage: onBoardingController.onBoardPagerData[onBoardingController.pageIndex]["top_image"]!,
                ),
              ),
            ),

            controller.pageIndex != 2 ?
            Column( children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        onBoardingController.onBoardPagerData.length, (index) => GetBuilder<OnBoardController>(
                      builder: (onBoardController) {
                        return PagerDot(index: index, currentIndex: onBoardController.pageIndex, dotSize: 6,);
                      },
                    )),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              GestureDetector(
                onTap: () => onBoardingController.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary
                  ),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 3),
                  child: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white, size: 20,),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
            ],) : const SizedBox()
          ],
        );
      }),
    );
  }
}
